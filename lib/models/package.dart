class ClinicPackage {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String duration;
  final List<String> features;
  final String imageUrl;
  final String category;
  final bool isActive;
  final bool isFeatured;
  final int sortOrder;

  ClinicPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.duration,
    required this.features,
    required this.imageUrl,
    required this.category,
    required this.isActive,
    required this.isFeatured,
    required this.sortOrder,
  });

  factory ClinicPackage.fromJson(Map<String, dynamic> json) {
    return ClinicPackage(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      duration: json['duration'] ?? '',
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? 'preventive',
      isActive: json['isActive'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
        if (originalPrice != null) 'originalPrice': originalPrice,
        'duration': duration,
        'features': features,
        'imageUrl': imageUrl,
        'category': category,
        'isActive': isActive,
        'isFeatured': isFeatured,
        'sortOrder': sortOrder,
      };
}
