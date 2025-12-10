import 'dart:convert';
import 'package:dental_admin_web/models/patient_history.dart';
import 'package:http/http.dart' as http;

class PatientHistoryService {
  final String baseUrl = "https://dental-backend-0e7e.onrender.com/api/appointments"; // update

  // Future<List<PatientHistory>> fetchPatientHistory(String patientId) async {
  //   final url = Uri.parse("$baseUrl/$patientId");

  //   final response = await http.get(url);

  //   print("Status code: ${response.statusCode}");
  //   print("Response body: ${response.body}");

  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body);
  //     final List data = jsonData['data'] ?? [];
  //     return data.map((e) => PatientHistory.fromJson(e)).toList();
  //   } else {
  //     throw Exception("Failed to fetch patient history");
  //   }
  // }

  Future<List<PatientHistory>> fetchPatientHistory(String patientId) async {
  final response = await http.get(
    Uri.parse("$baseUrl/$patientId"),
  );

  print("Status code: ${response.statusCode}");
  print("RAW Response: ${response.body}");

  final data = jsonDecode(response.body);

  print("Parsed JSON: $data");

  // 👇 Only now convert to model
  final List<dynamic> historyList = data["data"];

  return historyList.map((e) => PatientHistory.fromJson(e)).toList();
}


  Future<void> addPaymentAPI(Map<String, dynamic> data) async {
  final url = Uri.parse("$baseUrl/payment/add");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(data),
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to save payment");
  }
}

}
