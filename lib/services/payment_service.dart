import 'dart:convert';
import 'package:dental_admin_web/models/all_payment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/payment.dart';

class PaymentService {
  final String baseUrl = "https://dental-backend-0e7e.onrender.com/api/payments";

  /// Fetch payments by patient ID
  Future<List<Payment>> getPaymentsByPatient(String patientId) async {
    try {
      final url = Uri.parse("$baseUrl/$patientId");
      debugPrint("📡 GET: $url");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == true) {
          return (data["data"] as List)
              .map((e) => Payment.fromJson(e))
              .toList();
        }
      }

      return [];
    } catch (e) {
      debugPrint("❌ PaymentService error: $e");
      return [];
    }
  }

//     Future<List<AllPaymentModel>> fetchAlllPayments() async {
//   final response = await http.get(Uri.parse('$baseUrl/getAllPayments'));

//   if (response.statusCode == 200) {
//     final List<dynamic> data = json.decode(response.body)['data'];

//     return data
//         .map<AllPaymentModel>((json) => AllPaymentModel.fromJson(json))
//         .toList();
//   } else {
//     throw Exception("Failed to load payments");
//   }
// }
 
  static Future<int> getPaymentCount() async {
    final response = await http.get(Uri.parse("https://dental-backend-0e7e.onrender.com/api/payments/getAllPayments"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"].length;  // if API returns list
    } else {
      return 0;
    }
  }


}
