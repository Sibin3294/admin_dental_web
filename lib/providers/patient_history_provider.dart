import 'package:dental_admin_web/models/patient_history.dart';
import 'package:flutter/material.dart';
import '../services/patient_history_service.dart';

class PatientHistoryProvider with ChangeNotifier {
  final PatientHistoryService _service = PatientHistoryService();
  List<PatientHistory> history = [];
  bool isLoading = false;

  Future<void> loadHistory(String patientId) async {
    isLoading = true;
    notifyListeners();

    // try {
    //   history = await _service.fetchPatientHistory(patientId);
    //   print("PatientHistory loaded for patientId=$patientId");
    //   print("history");
    //   print(history.first.toString());
    // } catch (e) {
    //   history = [];
    //   print("Error fetching patient history: $e");
    // }
    try {
  history = await _service.fetchPatientHistory(patientId);
  print("History Loaded:");
  for (var h in history) {
    print(h.toJson()); // safer than toString()
  }
} catch (e) {
  print("Error fetching patient history: $e");
}

    isLoading = false;
    notifyListeners();
  }

  Future<void> addPayment({
  required String patientId,
  required double amount,
  String? note, required String mode, required String type, required DateTime date, required visitId,
}) async {
  try {
    // call your API
    await _service.addPaymentAPI({
      "patientId": patientId,
      "amount": amount,
      "note": note ?? "",
    });

    // refresh if needed
    loadHistory(patientId);
  } catch (e) {
    print("Error saving payment: $e");
  }
}

}
