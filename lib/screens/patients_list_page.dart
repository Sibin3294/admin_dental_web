// import 'package:dental_admin_web/providers/patient_provider.dart';
// import 'package:dental_admin_web/screens/add_dentist_page.dart';
// import 'package:dental_admin_web/screens/add_patient_page.dart';
// import 'package:dental_admin_web/screens/patient_history.dart';
// import 'package:dental_admin_web/screens/patient_payment_history.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class PatientsListPage extends StatelessWidget {
//   const PatientsListPage({super.key});

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
//                   "Patients",
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
//                       MaterialPageRoute(builder: (_) => const AddPatientPage()),
//                     );
//                   },
//                   icon: const Icon(Icons.add),
//                   label: const Text("Add Patient"),
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
//                 future: Provider.of<PatientsProvider>(context, listen: false)
//                     .fetchAllPatients(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   }

//                   final dentists =
//                       Provider.of<PatientsProvider>(context).patient ?? [];

//                   if (dentists.isEmpty) {
//                     return const Center(
//                       child: Text("No patients found.",
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
//                       scrollDirection: Axis.horizontal,
//                       child: DataTable(
//                         headingTextStyle: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff2c3e50),
//                         ),
//                         dataTextStyle: const TextStyle(
//                           fontSize: 14,
//                           color: Color(0xff34495e),
//                         ),
//                         headingRowColor:
//                             MaterialStateProperty.all(Colors.blue.shade50),
//                         dataRowColor: MaterialStateProperty.resolveWith<Color?>(
//                           (Set<MaterialState> states) {
//                             return Colors.grey.shade100;
//                           },
//                         ),
//                         columnSpacing: 30,
//                         dataRowHeight: 65,
//                         columns: const [
//                           DataColumn(label: Text('Patient Name')),
//                           DataColumn(label: Text('Email')),
//                           DataColumn(label: Text('Actions')),
//                         ],
//                         rows: dentists
//                             .map(
//                               (a) => DataRow(
//                                 cells: [
//                                   // ⭐ Avatar + patient Name
//                                   DataCell(
//                                     Row(
//                                       children: [
//                                         CircleAvatar(
//                                           radius: 22,
//                                           backgroundColor: Colors.blue.shade100,
//                                           child: Text(
//                                             a.name.isNotEmpty
//                                                 ? a.name[0].toUpperCase()
//                                                 : "?",
//                                             style: const TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.blue,
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Text(
//                                           a.name,
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                   DataCell(Text(a.email)),
//                                   DataCell(
//                                     Row(
//                                       children: [
//                                         // ⭐ Patient History Button
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     PatientHistoryPage(
//                                                   patientId: a
//                                                       .userId, // pass patientId if needed
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.teal,
//                                             foregroundColor: Colors.white,
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 12, vertical: 8),
//                                             textStyle: const TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           child: const Text("History"),
//                                         ),

//                                         const SizedBox(width: 8),

//                                         // ⭐ Payment History Button
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     PaymentHistoryPage(
//                                                   patientId: a
//                                                       .userId, // pass patientId
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.deepPurple,
//                                             foregroundColor: Colors.white,
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 12, vertical: 8),
//                                             textStyle: const TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           child: const Text("Payments"),
//                                         ),

//                                         const SizedBox(width: 12),

//                                         // ⭐ Edit Icon
//                                         IconButton(
//                                           icon: const Icon(Icons.edit,
//                                               color: Colors.blue),
//                                           onPressed: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) => AddPatientPage(
//                                                   patient: a,
//                                                   isEdit: true,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),

//                                         // ⭐ Delete Icon
//                                         IconButton(
//                                           icon: const Icon(Icons.delete,
//                                               color: Colors.red),
//                                           onPressed: () async {
//                                             bool confirm =
//                                                 await _showDeleteConfirmDialog(
//                                                     context);
//                                             if (!confirm) return;

//                                             final provider =
//                                                 Provider.of<PatientsProvider>(
//                                                     context,
//                                                     listen: false);
//                                             bool success = await provider
//                                                 .removePatient(a.userId);

//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               SnackBar(
//                                                 content: Text(success
//                                                     ? "Patient deleted successfully"
//                                                     : "Failed to delete patient"),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                             .toList(),
//                       ),
//                     ),
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
//             title: Text("Delete patient"),
//             content: Text("Are you sure you want to delete this patient?"),
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

// scrooll issue fixed
// import 'package:dental_admin_web/providers/patient_provider.dart';
// import 'package:dental_admin_web/screens/add_patient_page.dart';
// import 'package:dental_admin_web/screens/patient_history.dart';
// import 'package:dental_admin_web/screens/patient_payment_history.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class PatientsListPage extends StatelessWidget {
//   const PatientsListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff5f6fa),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔹 Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Patients",
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
//                         builder: (_) => const AddPatientPage(),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.add),
//                   label: const Text("Add Patient"),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // 🔹 Table
//             Expanded(
//               child: FutureBuilder(
//                 future: Provider.of<PatientsProvider>(
//                   context,
//                   listen: false,
//                 ).fetchAllPatients(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return const Center(
//                         child: CircularProgressIndicator());
//                   }

//                   if (snapshot.hasError) {
//                     return Center(
//                         child: Text("Error: ${snapshot.error}"));
//                   }

//                   final patients =
//                       Provider.of<PatientsProvider>(context)
//                               .patient ??
//                           [];

//                   if (patients.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         "No patients found",
//                         style: TextStyle(fontSize: 18),
//                       ),
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
//                         ),
//                       ],
//                     ),
//                     child: Scrollbar(
//                       thumbVisibility: true,
//                       child: SingleChildScrollView(
//                         // 🔽 Vertical scroll
//                         child: SingleChildScrollView(
//                           // ↔ Horizontal scroll
//                           scrollDirection: Axis.horizontal,
//                           child: DataTable(
//                             columnSpacing: 30,
//                             dataRowHeight: 65,
//                             headingRowColor:
//                                 MaterialStateProperty.all(
//                                     Colors.blue.shade50),
//                             columns: const [
//                               DataColumn(
//                                   label: Text("Patient Name")),
//                               DataColumn(label: Text("Email")),
//                               DataColumn(label: Text("Actions")),
//                             ],
//                             rows: patients.map((a) {
//                               return DataRow(
//                                 cells: [
//                                   // 1️⃣ Name
//                                   DataCell(
//                                     Row(
//                                       children: [
//                                         CircleAvatar(
//                                           radius: 22,
//                                           backgroundColor:
//                                               Colors.blue.shade100,
//                                           child: Text(
//                                             a.name.isNotEmpty
//                                                 ? a.name[0]
//                                                     .toUpperCase()
//                                                 : "?",
//                                             style: const TextStyle(
//                                               fontWeight:
//                                                   FontWeight.bold,
//                                               color: Colors.blue,
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Text(
//                                           a.name,
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight:
//                                                 FontWeight.w600,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                   // 2️⃣ Email
//                                   DataCell(Text(a.email)),

//                                   // 3️⃣ Actions
//                                   DataCell(
//                                     Row(
//                                       children: [
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) =>
//                                                     PatientHistoryPage(
//                                                   patientId: a.userId,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child:
//                                               const Text("History"),
//                                         ),
//                                         const SizedBox(width: 8),
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) =>
//                                                     PaymentHistoryPage(
//                                                   patientId: a.userId,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child:
//                                               const Text("Payments"),
//                                         ),
//                                         IconButton(
//                                           icon: const Icon(Icons.edit,
//                                               color: Colors.blue),
//                                           onPressed: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) =>
//                                                     AddPatientPage(
//                                                   patient: a,
//                                                   isEdit: true,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                         IconButton(
//                                           icon: const Icon(Icons.delete,
//                                               color: Colors.red),
//                                           onPressed: () async {
//                                             bool confirm =
//                                                 await _showDeleteConfirmDialog(
//                                                     context);
//                                             if (!confirm) return;

//                                             final provider =
//                                                 Provider.of<
//                                                     PatientsProvider>(
//                                               context,
//                                               listen: false,
//                                             );

//                                             bool success =
//                                                 await provider
//                                                     .removePatient(
//                                                         a.userId);

//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               SnackBar(
//                                                 content: Text(success
//                                                     ? "Patient deleted successfully"
//                                                     : "Failed to delete patient"),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 🔹 Confirm dialog
//   Future<bool> _showDeleteConfirmDialog(
//       BuildContext context) async {
//     return await showDialog<bool>(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text("Delete Patient"),
//             content: const Text(
//                 "Are you sure you want to delete this patient?"),
//             actions: [
//               TextButton(
//                 onPressed: () =>
//                     Navigator.pop(context, false),
//                 child: const Text("Cancel"),
//               ),
//               TextButton(
//                 onPressed: () =>
//                     Navigator.pop(context, true),
//                 child: const Text(
//                   "Delete",
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }
// }

// search implemented

import 'package:dental_admin_web/providers/data_sheet_provider.dart';
import 'package:dental_admin_web/providers/patient_provider.dart';
import 'package:dental_admin_web/screens/add_patient_page.dart';
import 'package:dental_admin_web/screens/patient_history.dart';
import 'package:dental_admin_web/screens/patient_payment_history.dart';
import 'package:dental_admin_web/theme/app_colors.dart';
import 'package:dental_admin_web/widgets/admin_page_layout.dart';
import 'package:dental_admin_web/widgets/admin_search_field.dart';
import 'package:dental_admin_web/widgets/admin_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientsListPage extends StatefulWidget {
  const PatientsListPage({super.key});

  @override
  State<PatientsListPage> createState() => _PatientsListPageState();
}

class _PatientsListPageState extends State<PatientsListPage> {
  String searchQuery = "";
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await Provider.of<PatientsProvider>(context, listen: false)
          .fetchAllPatients();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminPageLayout(
      title: 'Patients',
      subtitle: 'Manage patient records, history, and payments',
      actions: [
        OutlinedButton.icon(
          onPressed: () {
            Provider.of<DataSheetProvider>(context, listen: false).exportPatients();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Export started')),
            );
          },
          icon: const Icon(Icons.download_rounded),
          label: const Text('Export'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddPatientPage()),
            );
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Patient'),
        ),
      ],
      searchField: AdminSearchField(
        hintText: 'Search by patient name or email...',
        onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $_error', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadPatients,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final allPatients = Provider.of<PatientsProvider>(context).patient;
    final patients = allPatients.where((p) {
      return p.name.toLowerCase().contains(searchQuery) ||
          p.email.toLowerCase().contains(searchQuery);
    }).toList();

    if (patients.isEmpty) {
      return Center(
        child: Text(
          searchQuery.isEmpty
              ? 'No patients found'
              : 'No results for "$searchQuery"',
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    return AdminTableCard(
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor:
                  WidgetStateProperty.all(AppColors.surfaceMuted),
              dataRowColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.hovered)
                    ? AppColors.primary.withValues(alpha: 0.04)
                    : null,
              ),
              columns: const [
                DataColumn(label: Text('Patient Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Actions')),
              ],
              rows: patients.map((a) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.12),
                            child: Text(
                              a.name.isNotEmpty
                                  ? a.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            a.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(a.email)),
                    DataCell(Text(a.phone ?? '—')),
                    DataCell(
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PatientHistoryPage(
                                    patientId: a.userId,
                                  ),
                                ),
                              );
                            },
                            child: const Text('History'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PaymentHistoryPage(
                                    patientId: a.userId,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Payments'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: AppColors.primary),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddPatientPage(
                                    patient: a,
                                    isEdit: true,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: AppColors.error),
                            onPressed: () async {
                              final confirm =
                                  await _showDeleteConfirmDialog(context);
                              if (!confirm || !context.mounted) return;

                              final provider = Provider.of<PatientsProvider>(
                                context,
                                listen: false,
                              );
                              final success =
                                  await provider.removePatient(a.userId);

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Patient deleted successfully'
                                        : 'Failed to delete patient',
                                  ),
                                ),
                              );

                              if (success) await _loadPatients();
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
      ),
    );
  }

  /// 🔹 Confirm dialog
  Future<bool> _showDeleteConfirmDialog(
      BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Delete Patient"),
            content: const Text(
                "Are you sure you want to delete this patient?"),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, true),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

}
