import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/transaction.dart';

class ApiService {
  final String baseUrl;
  ApiService(this.baseUrl);

  Future<void> push(Transaction txn) async {
    await http.post(
      Uri.parse('$baseUrl/transactions'),
      body: jsonEncode(txn.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<List<Transaction>> pull() async {
    final response = await http.get(Uri.parse('$baseUrl/transactions'));
    final data = jsonDecode(response.body) as List;
    return data.map((e) => Transaction.fromJson(e)).toList();
  }
}
