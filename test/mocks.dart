import 'package:mockito/mockito.dart';
import 'package:seamless_data_sync/seamless_data_sync.dart';

// Mock LocalStorage
class MockLocalStorage extends Mock implements LocalStorage {}

// Mock RemoteService
class MockRemoteService extends Mock implements RemoteStorage {}

// Mock ConflictResolutionStrategy
class MockConflictResolutionStrategy extends Mock implements ConflictResolver {}
