class Patient {
  final String userId;
  final String name;
  final String email;
  final String password;

  // NEW FIELDS
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
    required this.password,
     required this.phone,
    required this.address,
     required this.gender,
     required this.dob,
    required this.bloodGroup,
     required this.weight,
    required this.height,
    required this.lastVisitDate,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      userId:json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      address: json['address'],
      gender: json['gender'],
      dob: json['dob'],
      bloodGroup: json['bloodGroup'],
      weight: json['weight'],
      height: json['height'],
      lastVisitDate: json['lastVisitDate'],
     
    );
  }
}
