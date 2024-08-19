abstract class RemoteService {
  Future<void> uploadData(String key, dynamic data);
  Future<dynamic> fetchData(String key);
  Future<void> deleteData(String key);
}
