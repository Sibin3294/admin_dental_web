import 'dart:convert';
import 'package:dental_admin_web/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminUser {
  final String id;
  final String name;
  final String email;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

class AuthService {
  static String get baseUrl => ApiConfig.auth;
  static const _tokenKey = 'adminAuthToken';
  static const _nameKey = 'adminName';

  static Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<String?> getAdminName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  static Future<void> _saveSession(String token, String? name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    if (name != null) {
      await prefs.setString(_nameKey, name);
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_nameKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        final token = body['token'] as String;
        final userName = body['user']?['name']?.toString();
        await _saveSession(token, userName);
        return {'success': true, 'token': token};
      }

      return {
        'success': false,
        'message': body['message'] ?? 'Invalid email or password',
      };
    } catch (e) {
      return {'success': false, 'message': 'Server error: $e'};
    }
  }

  static Future<List<AdminUser>> fetchAdmins() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/list'),
      headers: await _authHeaders(),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['success'] == true) {
      final List list = body['data'] ?? [];
      return list
          .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(body['message'] ?? 'Failed to load admins');
  }

  static Future<void> createAdmin({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/create'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode != 201 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to create admin');
    }
  }
}
