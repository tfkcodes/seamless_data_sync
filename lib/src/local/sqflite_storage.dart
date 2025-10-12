import 'dart:async';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'local_storage_interface.dart';

/// Simple sqflite-backed local storage. This implementation stores
/// each model in its own table with a JSON blob column `data`.
class SqfliteStorage implements LocalStorage {
  final String dbName;
  Database? _db;

  SqfliteStorage({this.dbName = 'seamless_data_sync.db'});

  Future<void> init() async {
    if (_db != null) return;
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, dbName);
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // no tables created upfront; they will be created dynamically
      },
    );
  }

  Future<void> _ensureTable(String modelName) async {
    await init();
    final db = _db!;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "$modelName" (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        updatedAt INTEGER NOT NULL
      );
    ''');
  }

  @override
  Future<void> upsert(String modelName, Map<String, dynamic> record) async {
    await _ensureTable(modelName);
    final db = _db!;
    final id = record['id']?.toString() ??
        (throw ArgumentError('record must have id'));
    final data = jsonEncode(record); // ✅ proper JSON
    final updatedAt =
        record['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch;

    await db.insert(
      modelName,
      {
        'id': id,
        'data': data,
        'updatedAt': updatedAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<Map<String, dynamic>?> get(String modelName, String id) async {
    await _ensureTable(modelName);
    final db = _db!;
    final rows = await db.query(modelName, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    final dataStr = rows.first['data'] as String;
    try {
      return jsonDecode(dataStr)
          as Map<String, dynamic>; // ✅ proper type decoding
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(String modelName) async {
    await _ensureTable(modelName);
    final db = _db!;
    final rows = await db.query(modelName);
    final out = <Map<String, dynamic>>[];
    for (final r in rows) {
      final row = await get(modelName, r['id'] as String);
      if (row != null) out.add(row);
    }
    return out;
  }

  @override
  Future<void> delete(String modelName, String id) async {
    await _ensureTable(modelName);
    final db = _db!;
    await db.delete(modelName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
