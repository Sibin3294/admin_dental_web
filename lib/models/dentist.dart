// // class Dentist {
// //   final String name;
// //   final String specialization;
// //   final String image;
// //   final String experience;
// //   final String qualification; 

// //   Dentist({
// //     required this.name,
// //     required this.specialization,
// //     required this.image,
// //     required this.experience,
// //     required this.qualification,
// //   });

// //   factory Dentist.fromJson(Map<String, dynamic> json) {
// //     return Dentist(
// //       name: json['name'],
// //       specialization: json['specialization'],
// //       image: json['image'],
// //       experience: json['experience'],
// //       qualification: json['qualification'],
// //     );
// //   }

// //     Map<String, dynamic> toJson() {
// //     return {
// //       "name": name,
// //       "specialization": specialization,
// //       "experience": experience,
// //       "qualification": qualification,
// //       "image": image,
// //     };
// //   }
// // }


// class Dentist {
//   final String id;
//   final String name;
//   final String specialization;
//   final String image;
//   final String experience;
//   final String qualification;

//   // ⭐ New More Info Fields
//   final String clinicName;
//   final String about;
//   final String timings;

//   Dentist({
//     required this.id,
//     required this.name,
//     required this.specialization,
//     required this.image,
//     required this.experience,
//     required this.qualification,
//     required this.clinicName,
//     required this.about,
//     required this.timings,
//   });

//   factory Dentist.fromJson(Map<String, dynamic> json) {
//     return Dentist(
//       id: json['_id'] ?? "",               // MongoDB ID
//       name: json['name'] ?? "",
//       specialization: json['specialization'] ?? "",
//       image: json['image'] ?? "",
//       experience: json['experience'] ?? "",
//       qualification: json['qualification'] ?? "",

//       // ⭐ Read new fields (if they exist, else empty string)
//       clinicName: json['clinicName'] ?? "",
//       about: json['about'] ?? "",
//       timings: json['timings'] ?? "",
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "name": name,
//       "specialization": specialization,
//       "experience": experience,
//       "qualification": qualification,
//       "image": image,

//       // ⭐ Include new fields
//       "clinicName": clinicName,
//       "about": about,
//       "timings": timings,
//     };
//   }
// }

class Dentist {
  final String id;
  final String name;
  final String specialization;
  final String image;
  final String experience;
  final String qualification;
  bool hasMoreInfo;

  // NEW FIELDS
  final String? biography;
  final String? availableDays;
  final String? consultationTimings;
  final String? languagesKnown;
  final String? awards;
  final String? specialProcedures;
  final String? website;
  final Map<String, dynamic>? consultingSchedule;

  Dentist({
    required this.id,
    required this.name,
    required this.specialization,
    required this.image,
    required this.experience,
    required this.qualification,
    this.biography,
    this.availableDays,
    this.consultationTimings,
    this.languagesKnown,
    this.awards,
    this.specialProcedures,
    this.website,
    this.consultingSchedule,
    this.hasMoreInfo = false,
  });

  factory Dentist.fromJson(Map<String, dynamic> json) {
    return Dentist(
      id: json['_id'],  // or "id"
      name: json['name'],
      specialization: json['specialization'],
      image: json['image'],
      experience: json['experience'],
      qualification: json['qualification'],

      // NEW FIELDS (nullable)
      biography: json['biography'],
      availableDays: json['availableDays'],
      consultationTimings: json['consultationTimings'],
      languagesKnown: json['languagesKnown'],
      awards: json['awards'],
      specialProcedures: json['specialProcedures'],
      website: json['website'],
      consultingSchedule: json['consultingSchedule'] is Map
          ? Map<String, dynamic>.from(json['consultingSchedule'])
          : null,
    );
  }
}
  