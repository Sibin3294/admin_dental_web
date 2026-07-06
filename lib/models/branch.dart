class Branch {
  final String id;
  final String name;
  final String address;
  final String? city;
  final String? phone;
  final String? code;
  final bool isActive;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    this.city,
    this.phone,
    this.code,
    this.isActive = true,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: (json['name'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      city: json['city']?.toString(),
      phone: json['phone']?.toString(),
      code: json['code']?.toString(),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        if (city != null) 'city': city,
        if (phone != null) 'phone': phone,
        if (code != null && code!.isNotEmpty) 'code': code,
        'isActive': isActive,
      };
}
