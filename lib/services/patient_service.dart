import 'dart:convert';
import 'package:dental_admin_web/models/patient.dart';
import 'package:http/http.dart' as http;

class PatientService {
  final String apiBaseUrl = "https://dental-backend-0e7e.onrender.com/api/patients";
  static const String baseUrl = "https://dental-backend-0e7e.onrender.com/api/auth";

  Future<List<dynamic>> fetchAllPatients() async {
    final response = await http.get(Uri.parse('$apiBaseUrl/getAllPatients'));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data']; // returns List
    } else {
      throw Exception("Failed to load dentists");
    }
  }

    Future<List<Patient>> fetchAlllPatients() async {
  final response = await http.get(Uri.parse('$apiBaseUrl/getAllPatients'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];

    return data
        .map<Patient>((json) => Patient.fromJson(json))
        .toList();
  } else {
    throw Exception("Failed to load patients");
  }
}


    Future<bool> addPatient(
    String name,
    String email,
    String password,
    
  ) async {
    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        
      }),
    );

    return response.statusCode == 200;
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
    final response = await http.get(Uri.parse("https://dental-backend-0e7e.onrender.com/api/patients/getAllPatients"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"].length;  // if API returns list
    } else {
      return 0;
    }
  }
  


}
