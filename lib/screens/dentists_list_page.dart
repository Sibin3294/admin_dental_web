// import 'package:dental_admin_web/providers/dentist_provider.dart';
// import 'package:dental_admin_web/screens/add_dentist_page.dart';
// import 'package:dental_admin_web/screens/dentist_details_page.dart';
// import 'package:dental_admin_web/screens/mark_dentist_attendence.dart';
// import 'package:dental_admin_web/widgets/add_dentist_slot_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class DentistsListPage extends StatelessWidget {
//   const DentistsListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff5f6fa),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
         
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Dentists",
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xff2c3e50),
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => const MarkDentistAttendence()),
//                     );
//                   },
//                   icon: const Icon(Icons.check),
//                   label: const Text("Mark Attendance"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const AddDentistPage()),
//                     );
//                   },
//                   icon: const Icon(Icons.add),
//                   label: const Text("Add Dentist"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             Expanded(
//               child: FutureBuilder(
//                 future: Provider.of<DentistsProvider>(context, listen: false)
//                     .fetchAllDentists(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   }

//                   final dentists =
//                       Provider.of<DentistsProvider>(context).dentist;

//                   if (dentists.isEmpty) {
//                     return const Center(
//                       child: Text("No dentists found.",
//                           style: TextStyle(fontSize: 18)),
//                     );
//                   }

//                   return Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(14),
//                       boxShadow: [
//                         BoxShadow(
//                           blurRadius: 8,
//                           color: Colors.black.withOpacity(0.07),
//                           offset: const Offset(0, 3),
//                         )
//                       ],
//                     ),
//                     child: SingleChildScrollView(
//   scrollDirection: Axis.vertical,
//   child: SingleChildScrollView(
//     scrollDirection: Axis.horizontal,
//     child: DataTable(
//       showCheckboxColumn: false,
//       headingTextStyle: const TextStyle(
//         fontWeight: FontWeight.bold,
//         color: Color(0xff2c3e50),
//       ),
//       dataTextStyle: const TextStyle(
//         fontSize: 14,
//         color: Color(0xff34495e),
//       ),
//       headingRowColor:
//           WidgetStateProperty.all(Colors.blue.shade50),
//       dataRowColor: WidgetStateProperty.resolveWith<Color?>(
//         (Set<WidgetState> states) {
//           return Colors.grey.shade100;
//         },
//       ),
//       columnSpacing: 30,
//       dataRowHeight: 65,
//       columns: const [
//         DataColumn(label: Text('Dentist Name')),
//         DataColumn(label: Text('Specialization')),
//         DataColumn(label: Text('Experience')),
//         DataColumn(label: Text('Qualification')),
//         DataColumn(label: Text('Consultation Timing')),
//         DataColumn(label: Text('Actions')),
//       ],
//       rows: dentists.map((a) => DataRow(
//         onSelectChanged: (_) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => DentistDetailsPage(dentist: a),
//             ),
//           );
//         },
//         cells: [
//           DataCell(
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 22,
//                   backgroundColor: Colors.blue.shade100,
//                   child: Text(
//                     a.name.isNotEmpty
//                         ? a.name[0].toUpperCase()
//                         : "?",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   a.name,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           DataCell(Text(a.specialization)),
//           DataCell(Text("${a.experience} yrs")),
//           DataCell(Text(a.qualification)),
//           DataCell(Text(a.consultationTimings ?? "-")),
//           DataCell(
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.calendar_month,
//                       color: Colors.blue),
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (_) =>
//                           AddDentistSlotDialog(dentistId: a.id),
//                     );
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => AddDentistPage(
//                           dentist: a,
//                           isEdit: true,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () async {
//                     bool confirm =
//                         await _showDeleteConfirmDialog(context);
//                     if (!confirm) return;

//                     final provider =
//                         Provider.of<DentistsProvider>(
//                             context,
//                             listen: false);

//                     bool success =
//                         await provider.removeDentist(a.id);

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           success
//                               ? "Dentist deleted successfully"
//                               : "Failed to delete dentist",
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       )).toList(),
//     ),
//   ),
// ),

//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<bool> _showDeleteConfirmDialog(BuildContext context) async {
//     return await showDialog<bool>(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text("Delete Dentist"),
//             content: Text("Are you sure you want to delete this dentist?"),
//             actions: [
//               TextButton(
//                 child: Text("Cancel"),
//                 onPressed: () => Navigator.pop(context, false),
//               ),
//               TextButton(
//                 child: Text("Delete", style: TextStyle(color: Colors.red)),
//                 onPressed: () => Navigator.pop(context, true),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }
// }

import 'package:dental_admin_web/providers/dentist_provider.dart';
import 'package:dental_admin_web/screens/add_dentist_page.dart';
import 'package:dental_admin_web/screens/dentist_details_page.dart';
import 'package:dental_admin_web/screens/mark_dentist_attendence.dart';
import 'package:dental_admin_web/theme/app_colors.dart';
import 'package:dental_admin_web/widgets/add_dentist_slot_dialog.dart';
import 'package:dental_admin_web/widgets/consulting_timings_dialog.dart';
import 'package:dental_admin_web/widgets/admin_page_layout.dart';
import 'package:dental_admin_web/widgets/admin_search_field.dart';
import 'package:dental_admin_web/widgets/admin_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DentistsListPage extends StatefulWidget {
  const DentistsListPage({super.key});

  @override
  State<DentistsListPage> createState() => _DentistsListPageState();
}

class _DentistsListPageState extends State<DentistsListPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return AdminPageLayout(
      title: 'Dentists',
      subtitle: 'Manage dentist profiles, slots, and attendance',
      actions: [
        OutlinedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MarkDentistAttendence()),
            );
          },
          icon: const Icon(Icons.fact_check_outlined),
          label: const Text('Attendance'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddDentistPage()),
            );
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Dentist'),
        ),
      ],
      searchField: AdminSearchField(
        hintText: 'Search by name, specialization or qualification...',
        onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
      ),
      child: FutureBuilder(
                future: Provider.of<DentistsProvider>(context, listen: false)
                    .fetchAllDentists(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}'));
                  }

                  final allDentists =
                      Provider.of<DentistsProvider>(context).dentist;

                  final dentists = allDentists.where((d) {
                    return d.name
                            .toLowerCase()
                            .contains(searchQuery) ||
                        d.specialization
                            .toLowerCase()
                            .contains(searchQuery) ||
                        d.qualification
                            .toLowerCase()
                            .contains(searchQuery);
                  }).toList();

                  if (dentists.isEmpty) {
                    return Center(
                      child: Text(
                        searchQuery.isEmpty
                            ? "No dentists found."
                            : "No results for \"$searchQuery\"",
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return AdminTableCard(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          showCheckboxColumn: false,
                          headingRowColor:
                              WidgetStateProperty.all(AppColors.surfaceMuted),
                          dataRowColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.hovered)
                                ? AppColors.primary.withValues(alpha: 0.04)
                                : null,
                          ),
                          columns: const [
                            DataColumn(label: Text('Dentist Name')),
                            DataColumn(
                                label: Text('Specialization')),
                            DataColumn(label: Text('Experience')),
                            DataColumn(
                                label: Text('Qualification')),
                            DataColumn(
                                label: Text(
                                    'Consultation Timing')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: dentists.map((a) {
                            return DataRow(
                              onSelectChanged: (_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DentistDetailsPage(
                                            dentist: a),
                                  ),
                                );
                              },
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundColor:
                                            Colors.blue.shade100,
                                        child: Text(
                                          a.name.isNotEmpty
                                              ? a.name[0]
                                                  .toUpperCase()
                                              : "?",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                                FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        a.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                    Text(a.specialization)),
                                DataCell(
                                    Text("${a.experience} yrs")),
                                DataCell(
                                    Text(a.qualification)),
                                DataCell(Text(
                                    a.consultationTimings ?? "-")),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        tooltip: 'Set consulting timings',
                                        icon: const Icon(
                                            Icons.schedule,
                                            color: Colors.teal),
                                        onPressed: () async {
                                          final saved = await showDialog<bool>(
                                            context: context,
                                            builder: (_) =>
                                                ConsultingTimingsDialog(
                                                    dentist: a),
                                          );
                                          if (saved == true && context.mounted) {
                                            setState(() {});
                                          }
                                        },
                                      ),
                                      IconButton(
                                        tooltip: 'Add slots for a date',
                                        icon: const Icon(
                                            Icons.calendar_month,
                                            color: Colors.blue),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                AddDentistSlotDialog(
                                                    dentistId:
                                                        a.id),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  AddDentistPage(
                                                dentist: a,
                                                isEdit: true,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          bool confirm =
                                              await _showDeleteConfirmDialog(
                                                  context);
                                          if (!confirm) return;

                                          final provider =
                                              Provider.of<
                                                      DentistsProvider>(
                                                  context,
                                                  listen: false);

                                          bool success =
                                              await provider
                                                  .removeDentist(
                                                      a.id);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                success
                                                    ? "Dentist deleted successfully"
                                                    : "Failed to delete dentist",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Future<bool> _showDeleteConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Delete Dentist"),
            content: const Text(
                "Are you sure you want to delete this dentist?"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () =>
                    Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text("Delete",
                    style: TextStyle(color: Colors.red)),
                onPressed: () =>
                    Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }
}
