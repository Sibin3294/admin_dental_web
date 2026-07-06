import 'dart:convert';

import 'package:dental_admin_web/config/api_config.dart';
import 'package:dental_admin_web/models/enquiry.dart';
import 'package:http/http.dart' as http;

class EnquiryService {
  static String get _base => ApiConfig.enquiries;

  Future<List<Enquiry>> fetchAll() async {
    final response = await http.get(
      Uri.parse('$_base/getAllEnquiries'),
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = json.decode(response.body);
    if (response.statusCode == 200 && decoded['success'] == true) {
      final List list = decoded['data'] ?? [];
      return list
          .map((e) => Enquiry.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(decoded['message'] ?? 'Failed to load enquiries');
  }

  Future<Enquiry> replyToEnquiry(String id, String adminReply) async {
    final response = await http.put(
      Uri.parse('$_base/$id/reply'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'adminReply': adminReply}),
    );

    final decoded = json.decode(response.body);
    if (response.statusCode == 200 && decoded['success'] == true) {
      return Enquiry.fromJson(decoded['data']);
    }
    throw Exception(decoded['message'] ?? 'Failed to send reply');
  }
}
