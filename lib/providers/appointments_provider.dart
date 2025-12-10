import 'package:dental_admin_web/services/appointment_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/appointment.dart';

class AppointmentsProvider with ChangeNotifier {
  List<AppointmentModel> _appointments = [];
  List<AppointmentModel> get appointments => _appointments;
    final AppointmentService _service = AppointmentService();

  List<dynamic> history = [];
  bool isLoading = false;

  final String apiBaseUrl = "https://dental-backend-0e7e.onrender.com/api/appointments"; // your backend

  // Future<void> fetchAppointments() async {
  //   try {
  //     final response = await http.get(Uri.parse('$apiBaseUrl/getAppointments'));

  //     if (response.statusCode == 200) {
  //       List data = json.decode(response.body);
  //       _appointments = data.map((e) => AppointmentModel.fromJson(e)).toList();
  //       notifyListeners();
  //     } else {
  //       throw Exception('Failed to load appointments');
  //     }
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }

  Future<void> fetchAppointments() async {
  try {
    final response = await http.get(Uri.parse('$apiBaseUrl/getAppointments'));

    if (response.statusCode == 200) {
      // Decode as Map
      final Map<String, dynamic> jsonMap = json.decode(response.body);

      // Extract the 'data' list
      final List<dynamic> data = jsonMap['data'];

      _appointments = data
          .map((e) => AppointmentModel.fromJson(e))
          .toList();

      notifyListeners();
    } else {
      throw Exception('Failed to load appointments');
    }
  } catch (e) {
    print("Error fetching appointments: $e");
    rethrow;
  }
}

// patient appointment history

 Future<void> loadHistory(String patientId) async {
    isLoading = true;
    notifyListeners();

    history = await _service.fetchPatientHistory(patientId);

    isLoading = false;
    notifyListeners();
  }


}
