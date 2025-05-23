import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client _httpClient = http.Client();

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await _httpClient.get(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getList(String endpoint) async {
    final response = await _httpClient.get(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await _httpClient.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create data: ${response.statusCode}');
    }
  }
}
