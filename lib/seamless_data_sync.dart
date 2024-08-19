library seamless_data_sync;

import 'package:seamless_data_sync/seamless_data_sync.dart';

import 'src/conflict_resolution/conflict_resolution_interface.dart';
import 'src/local/local_storage_interfance.dart';
import 'src/remote/remote_storage_interface.dart';

export 'src/sync/sync_storage_impl.dart';

/// Seamless Data Sync
///
/// A Flutter package that provides seamless data synchronization between local storage and remote servers.
/// It includes offline support, conflict resolution strategies, and network monitoring.
class SeamlessDataSync {
  /// Returns a [String] description of the package.
  String get description =>
      'A package for seamless data synchronization with offline support and conflict resolution.';

  /// Initialize the sync manager with necessary configurations.
  /// [localStorage] The local storage implementation.
  /// [remoteService] The remote service implementation.
  /// [conflictResolutionStrategy] The strategy for conflict resolution.
  static SeamlessDataManager initialize({
    required LocalStorage localStorage,
    required RemoteService remoteService,
    required ConflictResolutionStrategy conflictResolutionStrategy,
  }) {
    return SeamlessDataManager(
      localStorage: localStorage,
      remoteService: remoteService,
      conflictResolutionStrategy: conflictResolutionStrategy,
    );
  }
}
