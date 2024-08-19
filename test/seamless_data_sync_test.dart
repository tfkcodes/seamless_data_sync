import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart'; // Import mockito for mocking and verification
import 'package:seamless_data_sync/seamless_data_sync.dart';
import 'package:seamless_data_sync/src/conflict_resolution/conflict_resolution_interface.dart';
import 'package:seamless_data_sync/src/local/local_storage_interfance.dart';
import 'package:seamless_data_sync/src/remote/remote_storage_interface.dart';
import 'mocks.dart'; // Import your mock classes

void main() {
  group('SeamlessDataSync Tests', () {
    late LocalStorage localStorage;
    late RemoteService remoteService;
    late ConflictResolutionStrategy conflictResolutionStrategy;
    late SeamlessDataManager syncManager;

    setUp(() {
      // Initialize mock implementations
      localStorage = MockLocalStorage();
      remoteService = MockRemoteService();
      conflictResolutionStrategy = MockConflictResolutionStrategy();

      // Initialize SyncManager
      syncManager = SeamlessDataSync.initialize(
        localStorage: localStorage,
        remoteService: remoteService,
        conflictResolutionStrategy: conflictResolutionStrategy,
      );
    });

    test('SyncManager syncs data correctly', () async {
      // Arrange
      final localData = {'key': 'value'};
      final remoteData = {'key': 'remoteValue'};
      final resolvedData = {'key': 'resolvedValue'};

      // Mock methods
      when(localStorage.getData('key')).thenAnswer((_) async => localData);
      when(remoteService.fetchData('key')).thenAnswer((_) async => remoteData);
      when(conflictResolutionStrategy.resolve(localData, remoteData))
          .thenReturn(resolvedData);

      // Act
      await syncManager.sync();

      // Assert
      verify(localStorage.saveData('key', resolvedData)).called(1);
      verify(remoteService.uploadData('key', resolvedData)).called(1);
    });

    test('Conflict resolution strategy works as expected', () {
      // Arrange
      final localData = {'key': 'localValue'};
      final remoteData = {'key': 'remoteValue'};
      final resolvedData = {'key': 'resolvedValue'};

      when(conflictResolutionStrategy.resolve(localData, remoteData))
          .thenReturn(resolvedData);

      // Act
      final result = conflictResolutionStrategy.resolve(localData, remoteData);

      // Assert
      expect(result, equals(resolvedData));
    });

    // Additional tests for LocalStorage, RemoteService, and NetworkMonitor...
  });
}
