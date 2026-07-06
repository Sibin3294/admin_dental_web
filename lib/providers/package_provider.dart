import 'package:dental_admin_web/models/package.dart';
import 'package:dental_admin_web/services/package_service.dart';
import 'package:flutter/material.dart';

class PackageProvider extends ChangeNotifier {
  final PackageService _service = PackageService();

  List<ClinicPackage> packages = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchPackages() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      packages = await _service.fetchAll();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPackage(Map<String, dynamic> payload) async {
    isLoading = true;
    notifyListeners();
    try {
      await _service.addPackage(payload);
      await fetchPackages();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updatePackage(String id, Map<String, dynamic> payload) async {
    isLoading = true;
    notifyListeners();
    try {
      await _service.updatePackage(id, payload);
      await fetchPackages();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deletePackage(String id) async {
    isLoading = true;
    notifyListeners();
    try {
      await _service.deletePackage(id);
      await fetchPackages();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
