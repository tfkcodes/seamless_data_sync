import 'package:http/http.dart' as http;

import 'remote_storage_interface.dart';

class HttpRemoteService implements RemoteService {
  final String baseUrl;

  HttpRemoteService(this.baseUrl);

  @override
  Future<void> uploadData(String key, dynamic data) async {
    await http.post(Uri.parse('$baseUrl/upload/$key'), body: data);
  }

  @override
  Future<dynamic> fetchData(String key) async {
    final response = await http.get(Uri.parse('$baseUrl/fetch/$key'));
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  @override
  Future<void> deleteData(String key) async {
    await http.delete(Uri.parse('$baseUrl/delete/$key'));
  }
}
