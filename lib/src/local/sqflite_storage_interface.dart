import 'package:sqflite/sqflite.dart';

import 'local_storage_interfance.dart';

class SqfliteLocalStorage implements LocalStorage {
  final Database db;

  SqfliteLocalStorage(this.db);

  @override
  Future<void> saveData(String key, dynamic data) async {
    await db.insert('storage', {'key': key, 'data': data});
  }

  @override
  Future<dynamic> getData(String key) async {
    final List<Map<String, dynamic>> maps =
        await db.query('storage', where: 'key = ?', whereArgs: [key]);
    if (maps.isNotEmpty) {
      return maps.first['data'];
    }
    return null;
  }

  @override
  Future<void> deleteData(String key) async {
    await db.delete('storage', where: 'key = ?', whereArgs: [key]);
  }

  @override
  Future<void> clearAllData() async {
    await db.delete('storage');
  }
}
