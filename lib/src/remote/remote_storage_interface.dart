/// Minimal remote storage interface. Concrete implementations should handle
/// network calls and return server-side records as Map<String, dynamic>.
abstract class RemoteStorage {
  /// Fetch all records for model
  Future<List<Map<String, dynamic>>> fetchAll(String modelName);

  /// Fetch a single remote record
  Future<Map<String, dynamic>?> fetchOne(String modelName, String id);

  /// Push (create or update) a record on remote
  Future<Map<String, dynamic>> push(
      String modelName, Map<String, dynamic> record);

  /// Delete remote record
  Future<void> delete(String modelName, String id);
}
