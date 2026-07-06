class DentistAttendance {
  final String dentistId;
  final String status;
  final String? remarks;

  DentistAttendance({
    required this.dentistId,
    required this.status,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      "dentistId": dentistId,
      "status": status,
      if (remarks != null) "remarks": remarks,
    };
  }
}
