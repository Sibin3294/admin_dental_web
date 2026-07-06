import 'dart:convert';

import 'package:dental_admin_web/config/api_config.dart';
import 'package:dental_admin_web/models/package.dart';
import 'package:http/http.dart' as http;

class PackageService {
  static String get _base => ApiConfig.packages;

  Future<List<ClinicPackage>> fetchAll() async {
    final response = await http.get(Uri.parse('$_base/getAllPackages'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List list = body['data'] ?? [];
      return list.map((e) => ClinicPackage.fromJson(e)).toList();
    }
    throw Exception('Failed to load packages');
  }

  Future<ClinicPackage> addPackage(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$_base/addPackage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode == 201 && decoded['success'] == true) {
      return ClinicPackage.fromJson(decoded['data']);
    }
    throw Exception(decoded['message'] ?? 'Failed to add package');
  }

  Future<ClinicPackage> updatePackage(
    String id,
    Map<String, dynamic> payload,
  ) async {
    final response = await http.put(
      Uri.parse('$_base/updatePackage/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200 && decoded['success'] == true) {
      return ClinicPackage.fromJson(decoded['data']);
    }
    throw Exception(decoded['message'] ?? 'Failed to update package');
  }

  Future<void> deletePackage(String packageId) async {
    final response = await http.delete(
      Uri.parse('$_base/deletePackage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'packageId': packageId}),
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode != 200 || decoded['success'] != true) {
      throw Exception(decoded['message'] ?? 'Failed to delete package');
    }
  }
}
