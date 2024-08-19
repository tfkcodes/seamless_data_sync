enum SyncEventType {
  started,
  completed,
  failed,
}

class SyncEvent {
  final SyncEventType type;
  final String message;
  final dynamic data;

  SyncEvent({
    required this.type,
    required this.message,
    this.data,
  });
}
