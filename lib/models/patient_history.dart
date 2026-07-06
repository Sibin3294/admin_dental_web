


// class PatientHistory {
//   final String id;
//   final Patient patient;
//   final String reason;
//   final Dentist dentist;
//   final DateTime startTime;
//   final DateTime endTime;
//   final String status;
//   String paymentStatus;

//   PatientHistory({
//     required this.id,
//     required this.patient,
//     required this.reason,
//     required this.dentist,
//     required this.startTime,
//     required this.endTime,
//     required this.status,
//     required this.paymentStatus,
//   });

//   factory PatientHistory.fromJson(Map<String, dynamic> json) {
//     return PatientHistory(
//       id: json['_id'],
//       patient: Patient.fromJson(json['patientId']),
//       reason: json['reason'],
//       dentist: Dentist.fromJson(json['dentist']),
//       startTime: DateTime.parse(json['startTime']),
//       endTime: DateTime.parse(json['endTime']),
//       status: json['status'],
//       paymentStatus: json['paymentStatus'],
//     );
//   }

//   get visitId => null;
// }

// class Patient {
//   final String id;
//   final String name;
//   final String email;
//   final String? photoUrl; // Optional if you want to show a profile image

//   Patient({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.photoUrl,
//   });

//   factory Patient.fromJson(Map<String, dynamic> json) {
//     return Patient(
//       id: json['_id'],
//       name: json['name'],
//       email: json['email'],
//       photoUrl: json['image'] ?? '', // use 'image' if API has a photo
//     );
//   }
// }

// class Dentist {
//   final String id;
//   final String name;
//   final String specialization;
//   final String? image;

//   Dentist({
//     required this.id,
//     required this.name,
//     required this.specialization,
//     this.image,
//   });

//   factory Dentist.fromJson(Map<String, dynamic> json) {
//     return Dentist(
//       id: json['_id'],
//       name: json['name'],
//       specialization: json['specialization'],
//       image: json['image'] ?? '',
//     );
//   }
// }

import 'dart:convert';

import 'package:dental_admin_web/models/branch.dart';

class PatientHistory {
  final String id;
  final Patient patient;
  final String reason;
  final Dentist dentist;
  final Branch? branch;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  String paymentStatus;
  String? paidAmount;

  PatientHistory({
    required this.id,
    required this.patient,
    required this.reason,
    required this.dentist,
    this.branch,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.paymentStatus,
    this.paidAmount,
  });

  factory PatientHistory.fromJson(Map<String, dynamic> json) {
    return PatientHistory(
      id: json['_id']?.toString() ?? '',
      patient: Patient.fromJson(json['patientId'] ?? <String, dynamic>{}),
      reason: (json['reason'] ?? '').toString(),
      dentist: Dentist.fromJson(json['dentist'] ?? <String, dynamic>{}),
      branch: json['branch'] != null
          ? Branch.fromJson(json['branch'] as Map<String, dynamic>)
          : null,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'])
          : DateTime.now(),
      status: (json['status'] ?? '').toString(),
      paymentStatus: (json['paymentStatus'] ?? 'pending').toString(),
      // paidAmount: json['paidAmount']?.toString(),
      paidAmount: json['paidAmount']?.toString() ?? json['amount']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'patientId': patient.toJson(),
        'reason': reason,
        'dentist': dentist.toJson(),
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'status': status,
        'paymentStatus': paymentStatus,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class Patient {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  Patient({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id']?.toString() ?? '',
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      photoUrl: (json['image'] ?? json['photoUrl'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'image': photoUrl ?? '',
      };

  @override
  String toString() => jsonEncode(toJson());
}

class Dentist {
  final String id;
  final String name;
  final String specialization;
  final String? image;

  Dentist({
    required this.id,
    required this.name,
    required this.specialization,
    this.image,
  });

  factory Dentist.fromJson(Map<String, dynamic> json) {
    return Dentist(
      id: json['_id']?.toString() ?? '',
      name: (json['name'] ?? '').toString(),
      specialization: (json['specialization'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'specialization': specialization,
        'image': image ?? '',
      };

  @override
  String toString() => jsonEncode(toJson());
}

