import 'dart:convert';

import 'package:http/http.dart' as http;

import 'remote_storage_interface.dart';

/// Simple REST remote adapter. Expects conventional endpoints:
/// GET  /{model}        -> list
/// GET  /{model}/{id}   -> single
/// POST /{model}        -> create
/// PUT  /{model}/{id}   -> update
/// DELETE /{model}/{id} -> delete
class RestRemoteStorage implements RemoteStorage {
  final String baseUrl;
  final Map<String, String> headers;

  RestRemoteStorage({
    required this.baseUrl,
    this.headers = const {'Content-Type': 'application/json'},
  });

  Uri _uri(String path) => Uri.parse(baseUrl + path);

  @override
  Future<void> delete(String modelName, String id) async {
    final res = await http.delete(_uri('/$modelName/$id'), headers: headers);
    if (res.statusCode >= 400) {
      throw Exception('Remote delete failed: ${res.statusCode} ${res.body}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAll(String modelName) async {
    final res = await http.get(_uri('/$modelName'), headers: headers);
    if (res.statusCode >= 400) {
      throw Exception('Remote fetchAll failed: ${res.statusCode}');
    }
    final data = jsonDecode(res.body);
    if (data is List) {
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Unexpected payload from fetchAll');
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchOne(String modelName, String id) async {
    final res = await http.get(_uri('/$modelName/$id'), headers: headers);
    if (res.statusCode == 404) return null;
    if (res.statusCode >= 400) throw Exception('Remote fetchOne failed');
    return Map<String, dynamic>.from(jsonDecode(res.body));
  }

  @override
  Future<Map<String, dynamic>> push(
      String modelName, Map<String, dynamic> record) async {
    print(record);

    final id = record['id'] as String?;
    if (id == null) {
      // create

      final res = await http.post(_uri('/$modelName'),
          headers: headers, body: jsonEncode(record));

      if (res.statusCode >= 400)
        throw Exception('Remote create failed: ${res.body}');
      return Map<String, dynamic>.from(jsonDecode(res.body));
    } else {
      // update via PUT
      final res = await http.put(_uri('/$modelName/$id'),
          headers: headers, body: jsonEncode(record));
      if (res.statusCode >= 400)
        throw Exception('Remote update failed: ${res.body}');
      return Map<String, dynamic>.from(jsonDecode(res.body));
    }
  }
}
