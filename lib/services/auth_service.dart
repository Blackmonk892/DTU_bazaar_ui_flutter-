import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dtu_bazaar/utils/token_storage.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8000';

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    final result = await _handleResponse(response);

    if (result.containsKey('access_token')) {
      await TokenStorage.saveToken(result['access_token']);
    }

    return result;
  }

  static Future<Map<String, dynamic>> register(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    final result = await _handleResponse(response);

    if (result.containsKey('access_token')) {
      await TokenStorage.saveToken(result['access_token']);
    }

    return result;
  }

  static Future<Map<String, dynamic>> fetchProfile(String token) async {
    final url = Uri.parse('$baseUrl/me/profile');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

  static Future<void> updateProfile(
    String token,
    Map<String, String> data,
  ) async {
    final url = Uri.parse('$baseUrl/me/profile');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to update profile');
    }
  }

  static Future<Map<String, dynamic>> fetchUserHistory(String token) async {
    final url = Uri.parse('$baseUrl/me/history');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> _handleResponse(
    http.Response response,
  ) async {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final Map<String, dynamic> error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Unknown error');
    }
  }
}
