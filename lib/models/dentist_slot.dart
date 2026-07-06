class DentistSlot {
  final String time;
  final bool isBooked;

  DentistSlot({
    required this.time,
    required this.isBooked,
  });

  factory DentistSlot.fromJson(Map<String, dynamic> json) {
    return DentistSlot(
      time: json['time'],
      isBooked: json['isBooked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'isBooked': isBooked,
    };
  }
}
