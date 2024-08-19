import 'dart:async';
import '../conflict_resolution/conflict_resolution_interface.dart';
import '../local/local_storage_interfance.dart';
import '../remote/remote_storage_interface.dart';
import 'sync_event.dart';

class SeamlessDataManager {
  final LocalStorage localStorage;
  final RemoteService remoteService;
  final ConflictResolutionStrategy conflictResolutionStrategy;
  final StreamController<SyncEvent> _eventController =
      StreamController<SyncEvent>.broadcast();

  Stream<SyncEvent> get events => _eventController.stream;

  SeamlessDataManager({
    required this.localStorage,
    required this.remoteService,
    required this.conflictResolutionStrategy,
  });

  Future<void> sync() async {
    _eventController
        .add(SyncEvent(type: SyncEventType.started, message: 'Sync started'));

    try {
      final localData = await localStorage.getData('key');
      final remoteData = await remoteService.fetchData('key');

      final resolvedData =
          conflictResolutionStrategy.resolve(localData, remoteData);

      await localStorage.saveData('key', resolvedData);
      await remoteService.uploadData('key', resolvedData);

      _eventController.add(SyncEvent(
          type: SyncEventType.completed,
          message: 'Sync completed',
          data: resolvedData));
    } catch (e) {
      _eventController.add(SyncEvent(
          type: SyncEventType.failed, message: 'Sync failed', data: e));
    }
  }

  void dispose() {
    _eventController.close();
  }
}
