import 'package:mockito/mockito.dart';
import 'package:seamless_data_sync/src/conflict_resolution/conflict_resolution_interface.dart';
import 'package:seamless_data_sync/src/local/local_storage_interfance.dart';
import 'package:seamless_data_sync/src/remote/remote_storage_interface.dart';

// Mock LocalStorage
class MockLocalStorage extends Mock implements LocalStorage {}

// Mock RemoteService
class MockRemoteService extends Mock implements RemoteService {}

// Mock ConflictResolutionStrategy
class MockConflictResolutionStrategy extends Mock
    implements ConflictResolutionStrategy {}
