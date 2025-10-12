import 'dart:async';

import '../conflict_resolution/conflict_resolution_interface.dart';
import '../events/sync_event.dart';
import '../events/sync_status.dart';
import '../local/local_storage_interface.dart';
import '../network/network_monitor.dart';
import '../remote/remote_storage_interface.dart';
import 'sync_config.dart';
import 'sync_queue.dart';

class SyncManager {
  final LocalStorage local;
  final RemoteStorage remote;
  final ConflictResolver resolver;
  final NetworkMonitor monitor;
  final SyncQueue queue;
  final SyncConfig config;

  final StreamController<SyncEvent> _events = StreamController.broadcast();
  Stream<SyncEvent> get events => _events.stream;

  StreamSubscription<bool>? _netSub;
  bool _running = false;

  SyncManager({
    required this.local,
    required this.remote,
    required this.resolver,
    required this.monitor,
    required this.queue,
    SyncConfig? config,
  }) : config = config ?? SyncConfig();

  Future<void> start() async {
    if (_running) return;
    _running = true;
    await monitor.start();
    _netSub = monitor.onStatusChanged.listen((online) {
      if (online) {
        _events.add(SyncEvent(
            status: SyncStatus.running,
            message: 'Network back; starting sync'));
        _runBackgroundSync();
      }
    });
  }

  Future<void> stop() async {
    _running = false;
    await _netSub?.cancel();
    await monitor.stop();
    await _events.close();
  }

  /// Manual push: try to upload pending local changes from the queue.
  Future<void> push() async {
    _events.add(SyncEvent(status: SyncStatus.running, message: 'Push started'));

    while (!queue.isEmpty) {
      final op = queue.pop();
      if (op == null) break;

      // --- DEBUG INFO ---
      print("🔹 Push Operation:");
      print("Model: ${op.model}");
      print("ID: ${op.id}");
      print("Type: ${op.type}");
      print("Payload: ${op.payload}");
      print("Attempts: ${op.attempts}");
      // ------------------

      try {
        op.attempts++;
        final remoteResult = await remote.push(op.model, op.payload);

        // --- DEBUG INFO ---
        print(
            "✅ Remote push result for ${op.model} (ID: ${op.id}): $remoteResult");
        // ------------------

        // Update local DB with remote canonical
        await local.upsert(op.model, remoteResult);

        _events.add(SyncEvent(
            status: SyncStatus.completed,
            message: 'Operation ${op.id} pushed successfully'));
      } catch (e) {
        print("❌ Push failed for ${op.model} (ID: ${op.id}): $e");

        _events
            .add(SyncEvent(status: SyncStatus.failed, message: e.toString()));

        if (op.attempts < config.maxRetries) {
          await Future.delayed(Duration(seconds: config.retryDelaySeconds));
          queue.add(op); // requeue for retry
        } else {
          _events.add(SyncEvent(
              status: SyncStatus.failed, message: 'Giving up on op ${op.id}'));
        }
      }
    }

    _events
        .add(SyncEvent(status: SyncStatus.completed, message: 'Push finished'));
  }

  Future<void> pull(String model) async {
    _events.add(SyncEvent(
        status: SyncStatus.running, message: 'Pull started', model: model));

    print("🔹 Pulling data for model: $model");

    try {
      final remoteList = await remote.fetchAll(model);

      print("🔹 Remote fetch returned ${remoteList.length} records for $model");

      for (final remoteRecord in remoteList) {
        print("🔸 Remote record: $remoteRecord");

        final id = remoteRecord['id']?.toString();
        if (id == null) continue;
        print("Remote Record ${model}");

        final localRecord = await local.get(model, id);
        print("🔸 Local record: $localRecord");

        if (localRecord == null) {
          await local.upsert(model, remoteRecord);
          print("✅ Inserted new record into local DB for $model ID: $id");
        } else {
          final resolved =
              resolver.resolve(local: localRecord, remote: remoteRecord);
          await local.upsert(model, resolved);
          print("✅ Resolved conflict and updated record for $model ID: $id");
        }
      }

      _events.add(SyncEvent(
          status: SyncStatus.completed,
          message: 'Pull finished',
          model: model));
    } catch (e) {
      print("❌ Pull failed for $model: $e");
      _events.add(SyncEvent(
          status: SyncStatus.failed, message: e.toString(), model: model));
    }
  }

  /// Small helper to run push then pull for all models currently queued (MVP)
  Future<void> _runBackgroundSync() async {
    if (!_running) return;
    _events.add(SyncEvent(
        status: SyncStatus.running, message: 'Background sync running'));
    try {
      await push();
      // For MVP, we assume user will define model names; optionally scan queue for models
      _events.add(SyncEvent(
          status: SyncStatus.completed, message: 'Background sync completed'));
    } catch (e) {
      _events.add(SyncEvent(status: SyncStatus.failed, message: e.toString()));
    }
  }

  /// Add a local change to queue so it will be pushed later
  void enqueueOperation(SyncOperation op) {
    queue.add(op);
    _events.add(SyncEvent(
        status: SyncStatus.idle, message: 'Operation enqueued', payload: op));
  }
}
