import 'package:dental_admin_web/screens/mark_dentist_attendence.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/dentist_attendance_service.dart';

// class DentistAttendanceProvider with ChangeNotifier {
//   final _service = DentistAttendanceService();
//     Map<String, AttendanceStatus> attendanceMap = {};


//   bool _isSubmitting = false;
//   bool get isSubmitting => _isSubmitting;

//   Future<void> markAttendance(Map<String, dynamic> payload) async {
//     _isSubmitting = true;
//     notifyListeners();

//     try {
//       await _service.markAttendance(payload);
//     } finally {
//       _isSubmitting = false;
//       notifyListeners();
//     }
//   }


// Future<void> fetchAttendanceByDate(DateTime date) async {
//   final formattedDate = DateFormat('yyyy-MM-dd').format(date);

//   final data = await _service.fetchAttendanceByDate(formattedDate);

//   attendanceMap.clear();

//   for (final item in data) {
//     attendanceMap[item['dentistId']] =
//         AttendanceStatus.values.firstWhere(
//           (e) => e.name == item['status'],
//         );
//   }

//   notifyListeners();
// }
// }

class DentistAttendanceProvider extends ChangeNotifier {
  final DentistAttendanceService _service;

  DentistAttendanceProvider(this._service);

  bool isSubmitting = false;

  /// dentistId -> AttendanceStatus
  final Map<String, AttendanceStatus> attendanceMap = {};

  Future<void> fetchAttendanceByDate(DateTime date) async {
    final data = await _service.fetchAttendanceByDate(date);

    attendanceMap.clear();

    for (final item in data) {
      attendanceMap[item["dentistId"]] =
          AttendanceStatus.values.firstWhere(
        (e) => e.name == item["status"],
        orElse: () => AttendanceStatus.present,
      );
    }

    notifyListeners();
  }

  Future<void> markAttendance(Map<String, dynamic> payload) async {
    isSubmitting = true;
    notifyListeners();

    try {
      await _service.markAttendance(payload);
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
