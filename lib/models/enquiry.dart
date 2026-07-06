class Enquiry {
  final String id;
  final String? patientId;
  final String? patientName;
  final String? patientEmail;
  final String subject;
  final String message;
  final String status;
  final String? adminReply;
  final DateTime? repliedAt;
  final DateTime createdAt;

  Enquiry({
    required this.id,
    this.patientId,
    this.patientName,
    this.patientEmail,
    required this.subject,
    required this.message,
    required this.status,
    this.adminReply,
    this.repliedAt,
    required this.createdAt,
  });

  bool get isReplied => status == 'replied';

  factory Enquiry.fromJson(Map<String, dynamic> json) {
    final patient = json['patientId'];
    String? patientId;
    String? patientName;
    String? patientEmail;

    if (patient is Map<String, dynamic>) {
      patientId = patient['_id']?.toString();
      patientName = patient['name']?.toString();
      patientEmail = patient['email']?.toString();
    } else if (patient != null) {
      patientId = patient.toString();
    }

    return Enquiry(
      id: json['_id']?.toString() ?? '',
      patientId: patientId ?? json['patientId']?.toString(),
      patientName: patientName ?? json['patientName']?.toString(),
      patientEmail: patientEmail ?? json['patientEmail']?.toString(),
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? 'pending',
      adminReply: json['adminReply'],
      repliedAt: json['repliedAt'] != null
          ? DateTime.tryParse(json['repliedAt'].toString())
          : null,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
