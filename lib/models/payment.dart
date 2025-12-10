class Payment {
  final String? id;
  final String patientId;
  final String appointmentId;
  final String appointmentType;
  final String paymentMode;
  final String dentist;
  final String amount;
  final String notes;
  final DateTime? paymentDate;
  final String paymentStatus;
  final DateTime? createdAt;

  Payment({
    this.id,
    required this.patientId,
    required this.appointmentId,
    required this.appointmentType,
    required this.paymentMode,
    required this.dentist,
    required this.amount,
    required this.notes,
    this.paymentDate,
    required this.paymentStatus,
    this.createdAt,
  });

  /// -----------------------------
  /// From JSON → Dart Object
  /// -----------------------------
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json["_id"],
      patientId: json["patientId"],
      appointmentId: json["appointmentId"],
      appointmentType: json["appointmentType"] ?? "",
      paymentMode: json["paymentMode"] ?? "",
      dentist: json["dentist"],
      amount: json["amount"] ?? "0",
      notes: json["notes"] ?? "",
      paymentDate: json["paymentDate"] != null
          ? DateTime.parse(json["paymentDate"])
          : null,
      paymentStatus: json["paymentStatus"],
      createdAt:
          json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    );
  }

  /// -----------------------------
  /// Dart Object → JSON
  /// -----------------------------
  Map<String, dynamic> toJson() {
    return {
      "patientId": patientId,
      "appointmentId": appointmentId,
      "appointmentType": appointmentType,
      "paymentMode": paymentMode,
      "dentist": dentist,
      "amount": amount,
      "notes": notes,
      "paymentDate": paymentDate?.toIso8601String(),
      "paymentStatus": paymentStatus,
      "createdAt": createdAt?.toIso8601String(),
    };
  }

  
}


class Dentist {
  final String id;
  final String name;

  Dentist({
    required this.id,
    required this.name,
  });

  factory Dentist.fromJson(Map<String, dynamic> json) {
    return Dentist(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
    );
  }
}
