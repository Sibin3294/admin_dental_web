import 'dart:convert';
import 'package:dental_admin_web/config/api_config.dart';
import 'package:http/http.dart' as http;

class DentistSlotService {
  static String get baseUrl => ApiConfig.baseUrl;

  Future<void> addDentistSlots({
    required String dentistId,
    required DateTime date,
    required List<String> slots,
  }) async {
    final url = Uri.parse("$baseUrl/dentists/$dentistId/slots");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "date": date.toIso8601String(),
        "slots": slots,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body["message"] ?? "Failed to add slots");
    }
  }
}
