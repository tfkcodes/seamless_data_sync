/// Minimal local storage interface for the library.
/// Implementations must map to modelName (table) operations.
abstract class LocalStorage {
  /// Get a single record by id from local storage
  Future<Map<String, dynamic>?> get(String modelName, String id);

  /// Get all records (optionally filtered)
  Future<List<Map<String, dynamic>>> getAll(String modelName);

  /// Insert or update (upsert) a record locally
  Future<void> upsert(String modelName, Map<String, dynamic> record);

  /// Delete a local record
  Future<void> delete(String modelName, String id);

  /// Return pending operations from local DB if you store them
  /// For MVP we use in-memory queue; this can be extended to persist queue.
  Future<void> close();
}
