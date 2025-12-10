import 'dart:convert';
import 'package:dental_admin_web/models/appointment.dart';
import 'package:http/http.dart' as http;

class AppointmentService {
  // final String apiBaseUrl = "http://localhost:3000/api/appointments";
  final String apiBaseUrl = "https://dental-backend-0e7e.onrender.com/api/appointments";

  /// CREATE Appointment
  Future<AppointmentModel> createAppointment(Map<String, dynamic> data) async {
    print("request data");
    print(data);
    final response = await http.post(
      Uri.parse("$apiBaseUrl/createAppointment"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse['success']) {
      return AppointmentModel.fromJson(jsonResponse['data']);
    } else {
      throw Exception(jsonResponse['message']);
    }
  }

  /// GET all appointments
  Future<List<AppointmentModel>> getAppointments() async {
    final response = await http.get(
      Uri.parse("$apiBaseUrl/getAppointments"),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List data = jsonResponse['data'];
      print("data of appointments..");
      print(data);
      return data.map((e) => AppointmentModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load appointments");
    }
  }

  /// GET appointments by specific date
  Future<List<AppointmentModel>> getAppointmentsByDate(String date) async {
    final response = await http.get(
      Uri.parse("$apiBaseUrl/getAppointmentsByDate?date=$date"),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List data = jsonResponse['data'];
      return data.map((e) => AppointmentModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load appointments for date");
    }
  }

  /// UPDATE appointment
  Future<AppointmentModel> updateAppointment(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$apiBaseUrl/update/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse['success']) {
      return AppointmentModel.fromJson(jsonResponse['data']);
    } else {
      throw Exception(jsonResponse['message']);
    }
  }

  /// DELETE appointment
  Future<bool> deleteAppointment(String id) async {
    final response = await http.delete(
      Uri.parse("$apiBaseUrl/$id"),
    );

    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse['success']) {
      return true;
    } else {
      throw Exception(jsonResponse['message']);
    }
  }

  // get appointment service

  static Future<int> getAppointmentCount() async {
    final response = await http.get(Uri.parse("https://dental-backend-0e7e.onrender.com/api/appointments/getAppointments"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"].length;  // if API returns list
    } else {
      return 0;
    }
  }

  //updateAppointmentStatus

  Future<bool> updateAppointmentStatus(String id, String status) async {
  final url = Uri.parse("$apiBaseUrl/updateAppointmentStatus");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"id": id, "status": status}),
  );

  return response.statusCode == 200;
}

// patient appointment history

Future<List<dynamic>> fetchPatientHistory(String patientId) async {
    try {
      final response = await http.get(
        Uri.parse('/$patientId'),
        headers: {
          'Content-Type': 'application/json',
          // Add Authorization header if needed
          // 'Authorization': 'Bearer YOUR_TOKEN',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data'];
        }
      }
      return [];
    } catch (e) {
      print("Error fetching patient history: $e");
      return [];
    }
  }

}
