import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "https://dental-backend-0e7e.onrender.com/api/auth";

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/login");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return {"success": true, "token": body["token"]};
      } else {
        return {"success": false, "message": "Invalid email or password"};
      }
    } catch (e) {
      return {"success": false, "message": "Server error: $e"};
    }
  }
}
