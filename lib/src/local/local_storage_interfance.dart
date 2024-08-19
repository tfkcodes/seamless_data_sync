abstract class LocalStorage {
  Future<void> saveData(String key, dynamic data);
  Future<dynamic> getData(String key);
  Future<void> deleteData(String key);
  Future<void> clearAllData();
}
