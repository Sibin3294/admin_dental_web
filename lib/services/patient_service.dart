import 'dart:convert';
import 'package:dental_admin_web/config/api_config.dart';
import 'package:dental_admin_web/models/patient.dart';
import 'package:dental_admin_web/utils/api_client.dart';
import 'package:http/http.dart' as http;

class PatientService {
  String get apiBaseUrl => ApiConfig.patients;
  String get authBaseUrl => ApiConfig.auth;

  Future<List<dynamic>> fetchAllPatients() async {
    final uri = cacheBust(Uri.parse('$apiBaseUrl/getAllPatients'));
    final response = await apiGet(uri);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to load patients (${response.statusCode})');
    }
  }

    Future<List<Patient>> fetchAlllPatients() async {
  final data = await fetchAllPatients();
  return data
      .map((item) => Patient.fromJson(
            jsonDecode(jsonEncode(item)) as Map<String, dynamic>,
          ))
      .toList();
}


    Future<bool> addPatient(
    String name,
    String email,
    String password,
    
  ) async {
    final url = Uri.parse("$authBaseUrl/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }


Future<bool> updatePatient({
  required String id,
  required String name,
  required String email,
  required String password,
  
  
}) async {
  final url = Uri.parse("$apiBaseUrl/update/$id");
  print("id od dentist");
  print(id);

  final response = await http.put(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "name": name,
      "email": email,
      "password": password,
   
    }),
  );

  final result = jsonDecode(response.body);
  return result["success"] == true;
}
// delete dentist

Future<bool> deletePatient(String userId) async {
  final url = Uri.parse("$apiBaseUrl/$userId");

  final response = await http.delete(url);

  final result = jsonDecode(response.body);
  return result["success"] == true;
}

static Future<int> getPatientCount() async {
    final response = await http.get(Uri.parse('${ApiConfig.patients}/getAllPatients'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"].length;  // if API returns list
    } else {
      return 0;
    }
  }
  


}
