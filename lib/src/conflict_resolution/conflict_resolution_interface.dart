abstract class ConflictResolver {
  /// Return the resolved record (map) given local & remote versions.
  /// Implementations should merge or choose based on timestamp or custom logic.
  Map<String, dynamic> resolve({
    required Map<String, dynamic> local,
    required Map<String, dynamic> remote,
  });
}
