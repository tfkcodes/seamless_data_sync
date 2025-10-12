import 'dart:async';

import '../conflict_resolution/conflict_resolution_interface.dart';
import '../conflict_resolution/default_conflict_resolver.dart';
import '../core/sync_manager.dart';
import '../events/sync_event.dart';
import '../local/local_storage_interface.dart';
import '../network/network_monitor.dart';
import '../remote/remote_storage_interface.dart';
import 'sync_config.dart';
import 'sync_queue.dart';

class SeamlessSync {
  final LocalStorage local;
  final RemoteStorage remote;
  final ConflictResolver resolver;
  final NetworkMonitor monitor;
  final SyncQueue queue;
  final SyncConfig config;

  late final SyncManager _manager;

  SeamlessSync({
    required this.local,
    required this.remote,
    ConflictResolver? conflictResolver,
    NetworkMonitor? networkMonitor,
    SyncQueue? queue,
    SyncConfig? config,
  })  : resolver = conflictResolver ?? DefaultConflictResolver(),
        monitor = networkMonitor ?? NetworkMonitor(),
        queue = queue ?? SyncQueue(),
        config = config ?? SyncConfig() {
    _manager = SyncManager(
      local: local,
      remote: remote,
      resolver: resolver,
      monitor: monitor,
      queue: this.queue,
      config: this.config,
    );
  }

  Stream<SyncEvent> get events => _manager.events;

  Future<void> start() async {
    await _manager.start();
  }

  Future<void> stop() async {
    await _manager.stop();
  }

  Future<void> push() => _manager.push();

  Future<void> pull(String model) => _manager.pull(model);

  void enqueueOperation(SyncOperation op) => _manager.enqueueOperation(op);
}
