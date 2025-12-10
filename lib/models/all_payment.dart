class AllPaymentModel {
  final String id;
  final String amount;
  final String paymentStatus;
  final String? notes;
  final DateTime? paymentDate;
  final Patient? patient;
  final Dentist? dentist;

  AllPaymentModel({
    required this.id,
    required this.amount,
    required this.paymentStatus,
    this.notes,
    this.paymentDate,
    this.patient,
    this.dentist,
  });

  factory AllPaymentModel.fromJson(Map<String, dynamic> json) {
    return AllPaymentModel(
      id: json['_id'] ?? '',
      amount: json['amount'] ?? '0',
      paymentStatus: json['paymentStatus'] ?? '',
      notes: json['notes'],
      paymentDate: json['paymentDate'] != null
          ? DateTime.tryParse(json['paymentDate'])
          : null,
      patient: json['patientId'] != null
          ? Patient.fromJson(json['patientId'])
          : null,
      dentist: json['dentist'] != null
          ? Dentist.fromJson(json['dentist'])
          : null,
    );
  }
}

class Patient {
  final String id;
  final String name;
  final String email;

  Patient({required this.id, required this.name, required this.email});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class Dentist {
  final String id;
  final String name;

  Dentist({required this.id, required this.name});

  factory Dentist.fromJson(Map<String, dynamic> json) {
    return Dentist(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
