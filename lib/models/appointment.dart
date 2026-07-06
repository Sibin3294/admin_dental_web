

import 'package:dental_admin_web/models/branch.dart';
import 'package:dental_admin_web/models/dentist.dart';

class AppointmentModel {
  final String id;
  final PatientModel? patient;
  final String mobile;
  final String reason;
  final Dentist? dentist;
  final Branch? branch;
  final DateTime startTime;
  final DateTime endTime;
  final String status;

  AppointmentModel({
    required this.id,
    required this.patient,
    required this.mobile,
    required this.reason,
    required this.dentist,
    this.branch,
    required this.startTime,
    required this.endTime,
    required this.status
  });

  // factory AppointmentModel.fromJson(Map<String, dynamic> json) {
  //   return AppointmentModel(
  //     id: json['_id'],
  //     patient: json['patientId'] != null
  //         ? PatientModel.fromJson(json['patientId'])
  //         : null,  
  //     mobile: json['mobile'],
  //     reason: json['reason'],
  //     dentist: json['dentist'] != null
  //         ? Dentist.fromJson(json['dentist'])
  //         : null,
  //     startTime: DateTime.parse(json['startTime']),
  //     endTime: DateTime.parse(json['endTime']),
  //     status: json['status'] ?? "scheduled",
  //   );
  // }
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
  final patientJson = json['patientId'];
  return AppointmentModel(
    id: json['_id'] ?? "",
    patient: patientJson != null
        ? PatientModel.fromJson(patientJson)
        : null,
    mobile: patientJson != null
        ? patientJson['mobile'] ?? ""
        : json['mobile'] ?? "",
    reason: json['reason'] ?? "",
    dentist: json['dentist'] != null
        ? Dentist.fromJson(json['dentist'])
        : null,
    branch: json['branch'] != null
        ? Branch.fromJson(json['branch'])
        : null,
    startTime: DateTime.parse(json['startTime']),
    endTime: DateTime.parse(json['endTime']),
    status: json['status'] ?? "scheduled",
  );
}


  
}

class PatientModel {
  final String id;
  final String name;
  final String mobile;

  PatientModel({required this.id, required this.name, required this.mobile});

  // factory PatientModel.fromJson(Map<String, dynamic> json) {
  //   return PatientModel(
  //     id: json["_id"] ?? "",
  //     name: json["name"] ?? "",
  //     mobile: json["mobile"] ?? "",
  //   );
  // }
  factory PatientModel.fromJson(Map<String, dynamic> json) {
  return PatientModel(
    id: json["_id"] ?? "",
    name: json["name"] ?? "",
    mobile: json["mobile"] ?? "",
  );
}

}

