import 'dart:collection';

enum SyncOperationType { create, update, delete }

class SyncOperation {
  final String model;
  final String id; // local id or uuid
  final SyncOperationType type;
  final Map<String, dynamic> payload;
  int attempts;

  SyncOperation({
    required this.model,
    required this.id,
    required this.type,
    required this.payload,
    this.attempts = 0,
  });
}

class SyncQueue {
  final Queue<SyncOperation> _queue = Queue();

  void add(SyncOperation op) => _queue.add(op);

  bool get isEmpty => _queue.isEmpty;

  SyncOperation? pop() => _queue.isEmpty ? null : _queue.removeFirst();

  List<SyncOperation> get pending => List.unmodifiable(_queue);

  void clear() => _queue.clear();
}
