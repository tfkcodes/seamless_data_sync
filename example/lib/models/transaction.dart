class Transaction {
  final String id;
  final double amount;
  final String type;
  final DateTime date;
  final bool synced;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
    this.synced = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'type': type,
    'date': date.toIso8601String(),
    'synced': synced ? 1 : 0,
  };

  static Transaction fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'].toString(),
    amount: json['amount'],
    type: json['type'],
    date: DateTime.parse(json['date']),
    synced: json['synced'] == 1,
  );
}
