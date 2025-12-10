class PatientPaymentHistory {
  final String id;
  final PatientInfo patient;
  final AppointmentInfo appointment;
  final String appointmentType;
  final String paymentMode;
  final DentistInfo dentist;
  final String amount;
  final String notes;
  final DateTime paymentDate;
  final String paymentStatus;

  PatientPaymentHistory({
    required this.id,
    required this.patient,
    required this.appointment,
    required this.appointmentType,
    required this.paymentMode,
    required this.dentist,
    required this.amount,
    required this.notes,
    required this.paymentDate,
    required this.paymentStatus,
  });

  factory PatientPaymentHistory.fromJson(Map<String, dynamic> json) {
    return PatientPaymentHistory(
      id: json["_id"] ?? "",
      patient: PatientInfo.fromJson(json["patientId"]),
      appointment: AppointmentInfo.fromJson(json["appointmentId"]),
      appointmentType: json["appointmentType"] ?? "",
      paymentMode: json["paymentMode"] ?? "",
      dentist: DentistInfo.fromJson(json["dentist"]),
      amount: json["amount"]?.toString() ?? "0",
      notes: json["notes"] ?? "",
      paymentDate: DateTime.parse(json["paymentDate"]),
      paymentStatus: json["paymentStatus"] ?? "",
    );
  }
}

class PatientInfo {
  final String id;
  final String name;
  final String email;

  PatientInfo({
    required this.id,
    required this.name,
    required this.email,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
    );
  }
}

class DentistInfo {
  final String id;
  final String name;
  final String specialization;
  final String image;

  DentistInfo({
    required this.id,
    required this.name,
    required this.specialization,
    required this.image,
  });

  factory DentistInfo.fromJson(Map<String, dynamic> json) {
    return DentistInfo(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      specialization: json["specialization"] ?? "",
      image: json["image"] ?? "",
    );
  }
}

class AppointmentInfo {
  final String id;
  final String patientId;
  final String reason;
  final String dentist;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final String paymentStatus;

  AppointmentInfo({
    required this.id,
    required this.patientId,
    required this.reason,
    required this.dentist,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.paymentStatus,
  });

  factory AppointmentInfo.fromJson(Map<String, dynamic> json) {
    return AppointmentInfo(
      id: json["_id"] ?? "",
      patientId: json["patientId"] ?? "",
      reason: json["reason"] ?? "",
      dentist: json["dentist"] ?? "",
      startTime: DateTime.parse(json["startTime"]),
      endTime: DateTime.parse(json["endTime"]),
      status: json["status"] ?? "",
      paymentStatus: json["paymentStatus"] ?? "",
    );
  }
}
