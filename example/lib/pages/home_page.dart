import 'dart:math';

import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../services/db_service.dart';
import '../services/sync_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final syncService = SyncService();

  Future<void> _addTransaction() async {
    final txn = Transaction(
      id: Random().nextInt(999999).toString(),
      amount: Random().nextDouble() * 10000,
      type: "sale",
      date: DateTime.now(),
    );
    await DBService.insert(txn);
    setState(() {});
  }

  Future<void> _syncNow() async {
    await syncService.startSync();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seamless Data Sync Demo")),
      body: FutureBuilder(
        future: DBService.getAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final txns = snapshot.data!;
          return ListView.builder(
            itemCount: txns.length,
            itemBuilder: (context, i) {
              final t = txns[i];
              return ListTile(
                title: Text("Tsh ${t.amount.toStringAsFixed(2)}"),
                subtitle: Text(t.date.toString()),
                trailing: Icon(t.synced ? Icons.cloud_done : Icons.cloud_off),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _addTransaction,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'sync',
            onPressed: () async {
              await _syncNow();
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.sync),
          ),
        ],
      ),
    );
  }
}
