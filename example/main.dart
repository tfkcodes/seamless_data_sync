import 'package:flutter/material.dart';
import 'package:seamless_data_sync/seamless_data_sync.dart';
import 'package:seamless_data_sync/src/conflict_resolution/conflict_resolution_interface.dart';
import 'package:seamless_data_sync/src/local/local_storage_interfance.dart';
import 'package:seamless_data_sync/src/remote/remote_storage_interface.dart';

// Example implementation of LocalStorage
class InMemoryLocalStorage implements LocalStorage {
  final Map<String, dynamic> _storage = {};

  @override
  Future<void> saveData(String key, dynamic data) async {
    _storage[key] = data;
  }

  @override
  Future<dynamic> getData(String key) async {
    return _storage[key];
  }

  @override
  Future<void> deleteData(String key) async {
    _storage.remove(key);
  }

  @override
  Future<void> clearAllData() async {
    _storage.clear();
  }
}

// Example implementation of RemoteService
class MockRemoteService implements RemoteService {
  final Map<String, dynamic> _remoteData = {};

  @override
  Future<void> uploadData(String key, dynamic data) async {
    _remoteData[key] = data;
  }

  @override
  Future<dynamic> fetchData(String key) async {
    return _remoteData[key];
  }

  @override
  Future<void> deleteData(String key) async {
    _remoteData.remove(key);
  }
}

// Example implementation of ConflictResolutionStrategy
class LastWriteWinsStrategy implements ConflictResolutionStrategy {
  @override
  dynamic resolve(dynamic localData, dynamic remoteData) {
    // In this example, the remote data wins
    return remoteData;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SyncDemoScreen(),
    );
  }
}

class SyncDemoScreen extends StatefulWidget {
  @override
  _SyncDemoScreenState createState() => _SyncDemoScreenState();
}

class _SyncDemoScreenState extends State<SyncDemoScreen> {
  late SeamlessDataManager _seamlessDataManager;
  final InMemoryLocalStorage _localStorage = InMemoryLocalStorage();
  final MockRemoteService _remoteService = MockRemoteService();
  final LastWriteWinsStrategy _conflictResolutionStrategy = LastWriteWinsStrategy();

  @override
  void initState() {
    super.initState();
    _seamlessDataManager = SeamlessDataSync.initialize(
      localStorage: _localStorage,
      remoteService: _remoteService,
      conflictResolutionStrategy: _conflictResolutionStrategy,
    );

    // Example of using the sync manager
    _syncData();
  }

  Future<void> _syncData() async {
    // Adding some initial data to local storage
    await _localStorage.saveData('key', 'localValue');
    
    // Simulate remote data
    await _remoteService.uploadData('key', 'remoteValue');

    // Perform synchronization
    await _seamlessDataManager.sync();

    // Fetch and display synchronized data
    final syncedData = await _localStorage.getData('key');
    print('Synchronized Data: $syncedData'); // Should print 'remoteValue'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Seamless Data Sync Example')),
      body: Center(
        child: Text('Check the console for synchronization results.'),
      ),
    );
  }
}
