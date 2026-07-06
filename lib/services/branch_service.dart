import 'dart:convert';

import 'package:dental_admin_web/config/api_config.dart';
import 'package:dental_admin_web/models/branch.dart';
import 'package:http/http.dart' as http;

class BranchService {
  static String get _base => ApiConfig.branches;

  Future<List<Branch>> fetchAll({bool activeOnly = false}) async {
    final response = await http.get(
      Uri.parse('$_base/getAllBranches?activeOnly=$activeOnly'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['success'] == true) {
        final List list = decoded['data'] ?? [];
        return list
            .map((e) => Branch.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    throw Exception('Failed to load branches');
  }

  Future<List<Branch>> fetchActive() => fetchAll(activeOnly: true);

  Future<Branch> addBranch(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$_base/addBranch'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    final decoded = json.decode(response.body);
    if (response.statusCode == 201 && decoded['success'] == true) {
      return Branch.fromJson(decoded['data']);
    }
    throw Exception(decoded['message'] ?? 'Failed to add branch');
  }

  Future<Branch> updateBranch(String id, Map<String, dynamic> payload) async {
    final response = await http.put(
      Uri.parse('$_base/updateBranch/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    final decoded = json.decode(response.body);
    if (response.statusCode == 200 && decoded['success'] == true) {
      return Branch.fromJson(decoded['data']);
    }
    throw Exception(decoded['message'] ?? 'Failed to update branch');
  }

  Future<void> deleteBranch(String branchId) async {
    final response = await http.delete(
      Uri.parse('$_base/deleteBranch'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'branchId': branchId}),
    );

    final decoded = json.decode(response.body);
    if (response.statusCode != 200 || decoded['success'] != true) {
      throw Exception(decoded['message'] ?? 'Failed to delete branch');
    }
  }
}
