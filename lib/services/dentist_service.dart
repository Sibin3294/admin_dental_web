import 'dart:convert';
import 'package:dental_admin_web/config/api_config.dart';
import 'package:dental_admin_web/models/dentist.dart';
import 'package:dental_admin_web/models/dentist_attendance_model.dart';
import 'package:http/http.dart' as http;

class DentistService {
  String get apiBaseUrl => ApiConfig.dentists;
  String get attendenceapiBaseUrl => ApiConfig.attendance;

  Future<List<dynamic>> fetchAllDentists() async {
    final response = await http.get(Uri.parse('$apiBaseUrl/getAllDentists'));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data']; // returns List
    } else {
      throw Exception("Failed to load dentists");
    }
  }

  Future<List<Dentist>> fetchAlllDentists() async {
  final response = await http.get(Uri.parse('$apiBaseUrl/getAllDentists'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];

    return data
        .map<Dentist>((json) => Dentist.fromJson(json))
        .toList();
  } else {
    throw Exception("Failed to load dentists");
  }
}



  // add new dentist

    Future<bool> addDentist(
    String name,
    String specialization,
    String experience,
    String qualification,
    String image,
  ) async {
    final url = Uri.parse("$apiBaseUrl/addDentist");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "specialization": specialization,
        "experience": experience,
        "qualification": qualification,
        "image": image,
      }),
    );

    return response.statusCode == 200;
  }

// more dentist info
Future<bool> addMoreInfo({
  required String dentistId,
  required String bio,
  required String days,
  required String timings,
  required String languages,
  required String procedures,
  required String awards,
  required String website,
}) async {
  final url = Uri.parse("$apiBaseUrl/addMoreInfo");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "dentistId": dentistId,
      "biography": bio,
      "availableDays": days,
      "consultationTimings": timings,
      "languagesKnown": languages,
      "specialProcedures": procedures,
      "awards": awards,
      "website": website,
    }),
  );

  final result = jsonDecode(response.body);
  return result["success"] == true;
}

// delete dentist

Future<bool> deleteDentist(String dentistId) async {
  final url = Uri.parse("$apiBaseUrl/$dentistId");

  final response = await http.delete(url);

  final result = jsonDecode(response.body);
  return result["success"] == true;
}

// update dentist

Future<bool> updateDentist({
  required String id,
  required String name,
  required String specialization,
  required String experience,
  required String qualification,
  
}) async {
  final url = Uri.parse("$apiBaseUrl/update/$id");
  print("id od dentist");
  print(id);

  final response = await http.put(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "name": name,
      "specialization": specialization,
      "experience": experience,
      "qualification": qualification,
    }),
  );

  final result = jsonDecode(response.body);
  return result["success"] == true;
}

Future<Map<String, dynamic>> setConsultingSchedule({
  required String dentistId,
  required List<String> days,
  required String startTime,
  required String endTime,
  int slotDurationMinutes = 30,
  int generateDays = 30,
}) async {
  final url = Uri.parse("$apiBaseUrl/$dentistId/consultingSchedule");

  final response = await http.put(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "days": days,
      "startTime": startTime,
      "endTime": endTime,
      "slotDurationMinutes": slotDurationMinutes,
      "generateDays": generateDays,
    }),
  );

  final result = jsonDecode(response.body);
  if (response.statusCode == 200 && result["success"] == true) {
    return result;
  }
  throw Exception(result["message"] ?? "Failed to save consulting schedule");
}

static Future<int> getDentistCount() async {
    final response = await http.get(Uri.parse('${ApiConfig.dentists}/getAllDentists'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"].length;  // if API returns list
    } else {
      return 0;
    }
  }


}




