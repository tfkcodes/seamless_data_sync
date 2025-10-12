import 'conflict_resolution_interface.dart';

class DefaultConflictResolver implements ConflictResolver {
  /// Assumes both maps contain 'updatedAt' key with ISO8601 or unix epoch numeric.
  @override
  Map<String, dynamic> resolve({
    required Map<String, dynamic> local,
    required Map<String, dynamic> remote,
  }) {
    final localUpdated = _getUpdatedAt(local);
    final remoteUpdated = _getUpdatedAt(remote);

    if (remoteUpdated >= localUpdated) {
      return remote;
    } else {
      return local;
    }
  }

  int _getUpdatedAt(Map<String, dynamic> m) {
    final dynamic t = m['updatedAt'];
    if (t == null) return 0;
    if (t is int) return t;
    if (t is String) {
      try {
        return DateTime.parse(t).millisecondsSinceEpoch;
      } catch (_) {
        return 0;
      }
    }
    return 0;
  }
}
