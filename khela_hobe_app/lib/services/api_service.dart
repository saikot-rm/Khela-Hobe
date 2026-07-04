import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  String get baseUrl {
    const defaultUrl = 'http://10.0.2.2:5000/api';
    return defaultUrl;
  }

  Future<List<dynamic>> fetchVenues() async {
    final response = await _client.get(Uri.parse('$baseUrl/venues'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load venues: ${response.statusCode}');
    }

    final body = jsonDecode(response.body);
    if (body is! List) {
      throw Exception('Unexpected venues response format');
    }

    return body;
  }

  Future<Map<String, dynamic>> createVenue(Map<String, dynamic> data) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/venues'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create venue: ${response.statusCode}');
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw Exception('Unexpected create venue response format');
    }

    return body;
  }

  Future<Map<String, dynamic>> updateVenue(int id, Map<String, dynamic> data) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/venues/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update venue: ${response.statusCode}');
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw Exception('Unexpected update venue response format');
    }

    return body;
  }

  Future<void> deleteVenue(int id) async {
    final response = await _client.delete(Uri.parse('$baseUrl/venues/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete venue: ${response.statusCode}');
    }
  }
}
