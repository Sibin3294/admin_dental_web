import 'package:dental_admin_web/models/branch.dart';
import 'package:dental_admin_web/services/branch_service.dart';
import 'package:flutter/material.dart';

class BranchProvider extends ChangeNotifier {
  final BranchService _service = BranchService();

  List<Branch> branches = [];
  bool isLoading = false;
  String? error;

  List<Branch> get activeBranches =>
      branches.where((b) => b.isActive).toList();

  Future<void> fetchBranches() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      branches = await _service.fetchAll(activeOnly: false);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBranch(Map<String, dynamic> payload) async {
    isLoading = true;
    notifyListeners();
    try {
      await _service.addBranch(payload);
      await fetchBranches();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateBranch(String id, Map<String, dynamic> payload) async {
    isLoading = true;
    notifyListeners();
    try {
      await _service.updateBranch(id, payload);
      await fetchBranches();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteBranch(String id) async {
    isLoading = true;
    notifyListeners();
    try {
      await _service.deleteBranch(id);
      await fetchBranches();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
