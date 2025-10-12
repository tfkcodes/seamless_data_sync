import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;

import '../models/transaction.dart';

class DBService {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'transactions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions (
            id TEXT PRIMARY KEY,
            amount REAL,
            type TEXT,
            date TEXT,
            synced INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> insert(Transaction txn) async {
    final database = await db;
    await database.insert(
      'transactions',
      txn.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Transaction>> getAll() async {
    final database = await db;
    final data = await database.query('transactions');
    return data.map(Transaction.fromJson).toList();
  }

  static Future<void> clear() async {
    final database = await db;
    await database.delete('transactions');
  }
}
