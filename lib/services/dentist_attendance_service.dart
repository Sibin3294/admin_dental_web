import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// class DentistAttendanceService {
//   final String apiBaseUrl =
//       "https://dental-backend-0e7e.onrender.com/api/attendance";

//   Future<void> markAttendance(Map<String, dynamic> payload) async {
//     final response = await http.post(
//       Uri.parse('$apiBaseUrl/markDentistAttendance'),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode(payload),
//     );

//     if (response.statusCode != 200) {
//       final decoded = jsonDecode(response.body);
//       throw Exception(decoded['message'] ?? "Failed to mark attendance");
//     }
//   }

// //fetchAttendanceByDate
//   Future<List<dynamic>> fetchAttendanceByDate(String date) async {
//     final response = await http.get(
//       Uri.parse('$apiBaseUrl/dentist-attendance?date=$date'),
//     );

//     if (response.statusCode == 200) {
//       final decoded = json.decode(response.body);
//       return decoded['data'];
//     } else {
//       throw Exception("Failed to load attendance");
//     }
//   }
// }

class DentistAttendanceService {
  final String apiBaseUrl;

  DentistAttendanceService(this.apiBaseUrl);

  Future<List<dynamic>> fetchAttendanceByDate(DateTime date) async {
    final response = await http.post(
      Uri.parse("$apiBaseUrl/getDentistAttendanceByDate"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "date": DateFormat('yyyy-MM-dd').format(date),
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded["data"] ?? [];
    } else {
      throw Exception("Failed to fetch attendance");
    }
  }

  Future<void> markAttendance(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse("$apiBaseUrl/markDentistAttendance"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to mark attendance");
    }
  }
}
