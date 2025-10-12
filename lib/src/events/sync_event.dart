import 'sync_status.dart';

class SyncEvent {
  final String? model;
  final SyncStatus status;
  final String? message;
  final dynamic payload;

  SyncEvent({
    this.model,
    required this.status,
    this.message,
    this.payload,
  });

  @override
  String toString() {
    return 'SyncEvent(model: $model, status: $status, message: $message)';
  }
}
