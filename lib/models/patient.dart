class Patient {
  final String userId;
  final String name;
  final String email;
  final String? password;

  final String? phone;
  final String? address;
  final String? gender;
  final String? dob;
  final String? bloodGroup;
  final String? weight;
  final String? height;
  final String? lastVisitDate;

  Patient({
    required this.userId,
    required this.name,
    required this.email,
    this.password,
    this.phone,
    this.address,
    this.gender,
    this.dob,
    this.bloodGroup,
    this.weight,
    this.height,
    this.lastVisitDate,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      userId: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      gender: json['gender']?.toString(),
      dob: json['dob']?.toString(),
      bloodGroup: json['bloodGroup']?.toString(),
      weight: json['weight']?.toString(),
      height: json['height']?.toString(),
      lastVisitDate: json['lastVisitDate']?.toString(),
    );
  }
}
