import 'conflict_resolution_interface.dart';

class LastWriteWinsStrategy implements ConflictResolutionStrategy {
  @override
  dynamic resolve(dynamic localData, dynamic remoteData) {
    // Simple strategy: prefer remote data over local data
    return remoteData ?? localData;
  }
}
