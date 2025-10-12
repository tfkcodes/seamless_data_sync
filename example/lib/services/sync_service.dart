import 'package:seamless_data_sync/seamless_data_sync.dart';

class SyncService {
  late final SeamlessSync _sync;

  SyncService() {
    _sync = SeamlessSync(
      local: SqfliteStorage(),
      remote: RestRemoteStorage(baseUrl: 'https://www.dike.co.tz/api/sync'),
      conflictResolver: DefaultConflictResolver(),
      networkMonitor: NetworkMonitor(),
    );

    _sync.events.listen((status) {
      print('Sync status: $status');
    });
  }

  Future<void> startSync() async {
    await _sync.push();
    await _sync.pull('transactions');
  }
}
