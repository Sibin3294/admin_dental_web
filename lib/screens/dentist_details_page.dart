import 'package:dental_admin_web/providers/dentist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dentist.dart';

class DentistDetailsPage extends StatelessWidget {
  final Dentist dentist;

  const DentistDetailsPage({super.key, required this.dentist});

  void _openMoreInfoModal(BuildContext context) {
    final TextEditingController bioCtrl = TextEditingController();
    final TextEditingController daysCtrl = TextEditingController();
    final TextEditingController timingsCtrl = TextEditingController();
    final TextEditingController languagesCtrl = TextEditingController();
    final TextEditingController awardsCtrl = TextEditingController();
    final TextEditingController proceduresCtrl = TextEditingController();
    final TextEditingController websiteCtrl = TextEditingController();

    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Add More Information",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Biography
                  const Text("Biography"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: bioCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Short description about the dentist",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Available Days
                  const Text("Available Days"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: daysCtrl,
                    decoration: const InputDecoration(
                      hintText: "Mon - Sat",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Timings
                  const Text("Consultation Timings"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: timingsCtrl,
                    decoration: const InputDecoration(
                      hintText: "10:00 AM - 5:00 PM",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Languages
                  const Text("Languages Known"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: languagesCtrl,
                    decoration: const InputDecoration(
                      hintText: "English, Hindi, Tamil",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Awards
                  const Text("Awards & Recognition"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: awardsCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: "Any awards or achievements",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Special procedures
                  const Text("Special Procedures"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: proceduresCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: "Root canal, Orthodontics, etc.",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Social Media
                  const Text("Website / Social Profile"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: websiteCtrl,
                    decoration: const InputDecoration(
                      hintText: "https://www.example.com",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isSaving
                          ? null
                          : () async {
                              setState(() => isSaving = true);

                              bool success =
                                  await Provider.of<DentistsProvider>(
                                context,
                                listen: false,
                              ).addMoreInfo(
                                dentistId: dentist.id,
                                bio: bioCtrl.text,
                                days: daysCtrl.text,
                                timings: timingsCtrl.text,
                                languages: languagesCtrl.text,
                                awards: awardsCtrl.text,
                                procedures: proceduresCtrl.text,
                                website: websiteCtrl.text,
                              );

                              setState(() => isSaving = false);

                              if (success) {
                                // Close modal
                                Navigator.pop(context);

                                // Refresh list again
                                await Provider.of<DentistsProvider>(context,
                                        listen: false)
                                    .fetchAllDentists();

                                // Reopen updated page
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DentistDetailsPage(
                                      dentist: Provider.of<DentistsProvider>(
                                              context,
                                              listen: false)
                                          .dentist
                                          .firstWhere(
                                              (d) => d.id == dentist.id),
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to save info"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },


                      child: isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save Information",
                              style: TextStyle(fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        });
      },
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text(
//           dentist.name,
//           style:
//               const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),

//       // ----------- Background Gradient ---------------
//       body: Container(
//         decoration: const BoxDecoration(
//             // gradient: LinearGradient(
//             //   colors: [Color(0xff2980b9), Color(0xff6dd5fa)],
//             //   begin: Alignment.topCenter,
//             //   end: Alignment.bottomCenter,
//             // ),
//             ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
//           child: Column(
//             children: [
              
//               // ----------------- Profile Card -----------------
//               Container(
//                 padding: const EdgeInsets.all(25),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     )
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     // Avatar
//                     CircleAvatar(
//                       radius: 55,
//                       backgroundColor: Colors.blue.shade100,
//                       backgroundImage:
//                           (dentist.image != null && dentist.image.isNotEmpty)
//                               ? NetworkImage(dentist.image)
//                               : null,
//                       child: (dentist.image == null || dentist.image.isEmpty)
//                           ? Text(
//                               dentist.name[0].toUpperCase(),
//                               style: const TextStyle(
//                                 fontSize: 38,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue,
//                               ),
//                             )
//                           : null,
//                     ),

//                     const SizedBox(height: 20),

//                     Text(
//                       dentist.name,
//                       style: const TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff2c3e50),
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     Text(
//                       dentist.specialization,
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.blue.shade600,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // ------------------ Info Section -------------------
//               _infoTile(
//                 icon: Icons.work_outline,
//                 title: "Experience",
//                 value: "${dentist.experience} years",
//               ),

//               _infoTile(
//                 icon: Icons.school_outlined,
//                 title: "Qualification",
//                 value: dentist.qualification,
//               ),

//               _infoTile(
//                 icon: Icons.medical_services_outlined,
//                 title: "Specialization",
//                 value: dentist.specialization,
//               ),

//               if (dentist.bio != null && dentist.bio!.isNotEmpty)
//                 _infoTile(
//                   icon: Icons.person_outline,
//                   title: "Biography",
//                   value: dentist.bio!,
//                 ),

//               if (dentist.availableDays != null &&
//                   dentist.availableDays!.isNotEmpty)
//                 _infoTile(
//                   icon: Icons.calendar_month,
//                   title: "Available Days",
//                   value: dentist.availableDays!,
//                 ),

//               if (dentist.timings != null && dentist.timings!.isNotEmpty)
//                 _infoTile(
//                   icon: Icons.access_time,
//                   title: "Timings",
//                   value: dentist.timings!,
//                 ),

//               if (dentist.languages != null && dentist.languages!.isNotEmpty)
//                 _infoTile(
//                   icon: Icons.language,
//                   title: "Languages Known",
//                   value: dentist.languages!,
//                 ),

//               if (dentist.awards != null && dentist.awards!.isNotEmpty)
//                 _infoTile(
//                   icon: Icons.emoji_events_outlined,
//                   title: "Awards",
//                   value: dentist.awards!,
//                 ),

//               if (dentist.specialProcedures != null &&
//                   dentist.specialProcedures!.isNotEmpty)
//                 _infoTile(
//                   icon: Icons.medical_information_outlined,
//                   title: "Special Procedures",
//                   value: dentist.specialProcedures!,
//                 ),

//               if (dentist.website != null && dentist.website!.isNotEmpty)
//                 _infoTile(
//                   icon: Icons.link,
//                   title: "Website",
//                   value: dentist.website!,
//                 ),

//               // ElevatedButton.icon(
//               //   onPressed: () {
//               //     _openMoreInfoModal(context);
//               //   },
//               //   icon: const Icon(Icons.add_circle_outline),
//               //   label: const Text("Add More Info"),
//               //   style: ElevatedButton.styleFrom(
//               //     backgroundColor: Colors.white,
//               //     foregroundColor: Colors.blue,
//               //     elevation: 2,
//               //     padding:
//               //         const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
//               //     shape: RoundedRectangleBorder(
//               //       borderRadius: BorderRadius.circular(12),
//               //     ),
//               //   ),
//               // ),
//               // --------- Show Add More Info only if NOT already saved ---------
// bool hasMoreInfo =
//     (dentist.bio != null && dentist.bio!.isNotEmpty) ||
//     (dentist.availableDays != null && dentist.availableDays!.isNotEmpty) ||
//     (dentist.timings != null && dentist.timings!.isNotEmpty) ||
//     (dentist.languages != null && dentist.languages!.isNotEmpty) ||
//     (dentist.awards != null && dentist.awards!.isNotEmpty) ||
//     (dentist.specialProcedures != null && dentist.specialProcedures!.isNotEmpty) ||
//     (dentist.website != null && dentist.website!.isNotEmpty);

// if (!hasMoreInfo) ...[
//   const SizedBox(height: 20),
//   ElevatedButton.icon(
//     onPressed: () {
//       _openMoreInfoModal(context);
//     },
//     icon: const Icon(Icons.add_circle_outline),
//     label: const Text("Add More Info"),
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.blue,
//       elevation: 2,
//       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//     ),
//   ),
// ],

              
            
//           ),
//         ),
//       ),
//     );
//   }

@override
Widget build(BuildContext context) {
  // Compute this before returning the widget tree (NOT inside children list)
  final bool hasMoreInfo = (dentist.biography != null && dentist.biography!.isNotEmpty) ||
      (dentist.availableDays != null && dentist.availableDays!.isNotEmpty) ||
      (dentist.consultationTimings != null && dentist.consultationTimings!.isNotEmpty) ||
      (dentist.languagesKnown != null && dentist.languagesKnown!.isNotEmpty) ||
      (dentist.awards != null && dentist.awards!.isNotEmpty) ||
      (dentist.specialProcedures != null &&
          dentist.specialProcedures!.isNotEmpty) ||
      (dentist.website != null && dentist.website!.isNotEmpty);

  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        dentist.name,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    // ----------- Background Gradient ---------------
    body: Container(
      decoration: const BoxDecoration(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
        child: Column(
          children: [
            // ----------------- Profile Card -----------------
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage:
                        (dentist.image != null && dentist.image.isNotEmpty)
                            ? NetworkImage(dentist.image)
                            : null,
                    child: (dentist.image == null || dentist.image.isEmpty)
                        ? Text(
                            dentist.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          )
                        : null,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    dentist.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2c3e50),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    dentist.specialization,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ------------------ Info Section -------------------
            _infoTile(
              icon: Icons.work_outline,
              title: "Experience",
              value: "${dentist.experience} years",
            ),

            _infoTile(
              icon: Icons.school_outlined,
              title: "Qualification",
              value: dentist.qualification,
            ),

            _infoTile(
              icon: Icons.medical_services_outlined,
              title: "Specialization",
              value: dentist.specialization,
            ),

            if (dentist.biography != null && dentist.biography!.isNotEmpty)
              _infoTile(
                icon: Icons.person_outline,
                title: "Biography",
                value: dentist.biography!,
              ),

            if (dentist.availableDays != null &&
                dentist.availableDays!.isNotEmpty)
              _infoTile(
                icon: Icons.calendar_month,
                title: "Available Days",
                value: dentist.availableDays!,
              ),

            if (dentist.consultationTimings != null && dentist.consultationTimings!.isNotEmpty)
              _infoTile(
                icon: Icons.access_time,
                title: "Timings",
                value: dentist.consultationTimings!,
              ),

            if (dentist.languagesKnown != null && dentist.languagesKnown!.isNotEmpty)
              _infoTile(
                icon: Icons.language,
                title: "Languages Known",
                value: dentist.languagesKnown!,
              ),

            if (dentist.awards != null && dentist.awards!.isNotEmpty)
              _infoTile(
                icon: Icons.emoji_events_outlined,
                title: "Awards",
                value: dentist.awards!,
              ),

            if (dentist.specialProcedures != null &&
                dentist.specialProcedures!.isNotEmpty)
              _infoTile(
                icon: Icons.medical_information_outlined,
                title: "Special Procedures",
                value: dentist.specialProcedures!,
              ),

            if (dentist.website != null && dentist.website!.isNotEmpty)
              _infoTile(
                icon: Icons.link,
                title: "Website",
                value: dentist.website!,
              ),

            // ---------- Show Add More Info button only when no more-info exists ----------
            if (!hasMoreInfo) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  _openMoreInfoModal(context);
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text("Add More Info"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  elevation: 2,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}


  // ---------- Reusable Beautiful Tile Widget ----------
  Widget _infoTile(
      {required IconData icon, required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, color: Colors.blue.shade700, size: 26),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff7f8c8d),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2c3e50),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
