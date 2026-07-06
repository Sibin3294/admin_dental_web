
import 'dart:convert';

import 'package:dental_admin_web/models/patient.dart';
import 'package:dental_admin_web/services/patient_service.dart';
import 'package:flutter/material.dart';


class PatientsProvider with ChangeNotifier {
  List<Patient> _patients = [];
  List<Patient> get patient => _patients;

  final PatientService _service = PatientService();

  List<Patient> _parsePatients(List<dynamic> data) {
    return data.map((item) {
      final map = jsonDecode(jsonEncode(item)) as Map<String, dynamic>;
      return Patient.fromJson(map);
    }).toList();
  }

  Future<void> fetchAllPatients() async {
    try {
      final data = await _service.fetchAllPatients();
      _patients = _parsePatients(data);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addPatient(
  String name,
  String email,
  String password,
 
) async {
  try {
    final response = await _service.addPatient(
      name,
      email,
      password,
      
    );

    if (response) {
      // refresh list again so UI updates
      await fetchAllPatients();
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("Add dentist error: $e");
    return false;
  }
}

Future<bool> updatePatient(
  String id,
  String name,
  String email,
  String password,
  
) async {
  try {
    final response = await _service.updatePatient(
      id: id,
      name: name,
      email: email,
      password: password,
      
    );

    if (response) {
      await fetchAllPatients(); // refresh list after update
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("Update dentist error: $e");
    return false;
  }
}

// remove patient

Future<bool> removePatient(String userId) async {
  try {
    final success = await _service.deletePatient(userId);

    if (success) {
      _patients.removeWhere((d) => d.userId == userId);
      notifyListeners();
    }

    return success;
  } catch (e) {
    print("Delete error: $e");
    return false;
  }
}

}
