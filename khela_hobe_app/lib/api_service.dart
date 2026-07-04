import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5000/api/venues';

  Future<List<Map<String, dynamic>>> fetchVenues() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load venues: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    if (data is! List) {
      throw Exception('Invalid response format from server');
    }

    return data
        .map<Map<String, dynamic>>(
          (item) => Map<String, dynamic>.from(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Map<String, dynamic>> createVenue(Map<String, dynamic> venue) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(venue),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create venue: ${response.statusCode}');
    }

    return Map<String, dynamic>.from(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> updateVenue(int id, Map<String, dynamic> venue) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(venue),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update venue: ${response.statusCode}');
    }

    return Map<String, dynamic>.from(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> deleteVenue(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete venue: ${response.statusCode}');
    }
  }
}
