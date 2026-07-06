import 'dart:convert';
import 'package:dental_admin_web/config/api_config.dart';
import 'package:dental_admin_web/models/all_payment.dart';
import 'package:dental_admin_web/models/patient_paymentHistory.dart';
import 'package:dental_admin_web/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentProvider with ChangeNotifier {
  String get baseUrl => ApiConfig.payments;

  bool isLoading = false;
  List<Payment> payments = [];
  List<PatientPaymentHistory> patientPayments = [];
  List<AllPaymentModel> allPayments = [];

  /// ---------------------------------------------------
  /// 🔥 Fetch ALL payments
  /// ---------------------------------------------------
//   Future<void> getAllPayments() async {
//     try {
//       isLoading = true;
//       notifyListeners();

//       final url = Uri.parse("$baseUrl/getAllPayments");
//       final response = await http.get(url);

//       final data = json.decode(response.body);

// if (data["success"] == true) {
//   payments = (data["data"] as List)
//       .map((e) => Payment.fromJson(e))
//       .toList();
// }
//     } catch (e) {
//       debugPrint("Get all payments error: $e");
//     }

//     isLoading = false;
//     notifyListeners();
//   }


  Future<void> getAllPayments() async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('$baseUrl/getAllPayments');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        allPayments = (data['data'] as List)
            .map((json) => AllPaymentModel.fromJson(json))
            .toList();
      } else {
        allPayments = [];
      }
    } catch (e) {
      debugPrint("Error fetching all payments: $e");
      allPayments = [];
    }

    isLoading = false;
    notifyListeners();
  }



  /// ---------------------------------------------------
  /// 🔥 Fetch payments by patient ID
  /// ---------------------------------------------------
  // Future<void> getPaymentsByPatient(String patientId) async {
  //   try {
  //     isLoading = true;
  //     notifyListeners();

  //     final url = Uri.parse("$baseUrl/byPatient/$patientId");
  //     final response = await http.get(url);
  //     final data = json.decode(response.body);

  //     if (data["success"] == true) {
  //       payments = (data["data"] as List)
  //           .map((e) => Payment.fromJson(e))
  //           .toList();
  //     }
  //   } catch (e) {
  //     debugPrint("Get payments by patient error: $e");
  //   }

  //   isLoading = false;
  //   notifyListeners();
  // }


Future<void> getPaymentsByPatient(String patientId) async {
  isLoading = true;
  notifyListeners();

  try {
    final url = Uri.parse("$baseUrl/$patientId");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      patientPayments = (data['data'] as List)
          .map((json) => PatientPaymentHistory.fromJson(json))
          .toList();
    } else {
      payments = [];
    }
  } catch (e) {
    debugPrint("Error fetching payments: $e");
    payments = [];
  }

  isLoading = false;
  notifyListeners();
}


  /// ---------------------------------------------------
  /// 🔥 Add new payment
  /// ---------------------------------------------------
  // Future<bool> addPayment(Payment payment) async {
  //   try {
  //     /// 🔥 Console Log the Payment Request BEFORE API CALL
  //   print("📤 ADD PAYMENT REQUEST:");
  //   print(payment.toJson());
  //     final url = Uri.parse("$baseUrl/addPayment");

  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode(payment.toJson()),
  //     );

  //     final data = json.decode(response.body);

  //     if (data["success"] == true) {
  //       payments.add(Payment.fromJson(data["data"]));
  //       notifyListeners();
  //       return true;
  //     }
  //   } catch (e) {
  //     debugPrint("Add payment error: $e");
  //   }

  //   return false;
  // }

  Future<Map<String, dynamic>> addPayment(Payment payment) async {
  try {
    print("📤 ADD PAYMENT REQUEST:");
    print(payment.toJson());

    final url = Uri.parse("$baseUrl/addPayment");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(payment.toJson()),
    );

    final data = json.decode(response.body);

    // Return backend response directly
    return {
      "success": data["success"] ?? false,
      "message": data["message"] ?? "Something went wrong",
      "data": data["data"]
    };
  } catch (e) {
    debugPrint("Add payment error: $e");
    return {
      "success": false,
      "message": "Server error occurred",
    };
  }
}


  /// ---------------------------------------------------
  /// 🔥 Delete payment
  /// ---------------------------------------------------
  Future<bool> deletePayment(String paymentId) async {
    try {
      final url = Uri.parse("$baseUrl/delete/$paymentId");

      final response = await http.delete(url);
      final data = json.decode(response.body);

      if (data["success"] == true) {
        payments.removeWhere((p) => p.id == paymentId);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("Delete payment error: $e");
    }

    return false;
  }
}
