// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/dentist_slot_provider.dart';

// class DentistSlotsDialog extends StatelessWidget {
//   final String dentistId;

//   const DentistSlotsDialog({super.key, required this.dentistId});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.all(24),
//       child: SizedBox(
//         width: 600,
//         height: 500,
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Available Slots",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   )
//                 ],
//               ),

//               const SizedBox(height: 16),

//               /// Slots list
//               Expanded(
//                 child: FutureBuilder(
//                   future: Provider.of<DentistSlotProvider>(
//                     context,
//                     listen: false,
//                   ).fetchDentistSlots(dentistId),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }

//                     if (snapshot.hasError) {
//                       return Center(
//                         child: Text("Error: ${snapshot.error}"),
//                       );
//                     }

//                     final slotsProvider =
//                         Provider.of<DentistSlotProvider>(context);
//                     final slots = slotsProvider.slots;

//                     if (slots.isEmpty) {
//                       return const Center(
//                         child: Text(
//                           "No slots added yet",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       );
//                     }

//                     /// Group by date UI
//                     return ListView.builder(
//                       itemCount: slots.length,
//                       itemBuilder: (context, index) {
//                         final slot = slots[index];

//                         return Card(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(14),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 /// Date
//                                 Text(
//                                   slot.dateFormatted, // format on model
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),

//                                 const SizedBox(height: 10),

//                                 /// Slots
//                                 Wrap(
//                                   spacing: 8,
//                                   runSpacing: 6,
//                                   children: slot.slots
//                                       .map<Widget>(
//                                         (time) => Chip(
//                                           label: Text(time),
//                                           backgroundColor:
//                                               Colors.blue.shade50,
//                                         ),
//                                       )
//                                       .toList(),
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
