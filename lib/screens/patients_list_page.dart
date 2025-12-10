import 'package:dental_admin_web/providers/patient_provider.dart';
import 'package:dental_admin_web/screens/add_dentist_page.dart';
import 'package:dental_admin_web/screens/add_patient_page.dart';
import 'package:dental_admin_web/screens/patient_history.dart';
import 'package:dental_admin_web/screens/patient_payment_history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientsListPage extends StatelessWidget {
  const PatientsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Patients",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2c3e50),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddPatientPage()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Patient"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<PatientsProvider>(context, listen: false)
                    .fetchAllPatients(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final dentists =
                      Provider.of<PatientsProvider>(context).patient ?? [];

                  if (dentists.isEmpty) {
                    return const Center(
                      child: Text("No patients found.",
                          style: TextStyle(fontSize: 18)),
                    );
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black.withOpacity(0.07),
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2c3e50),
                        ),
                        dataTextStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff34495e),
                        ),
                        headingRowColor:
                            MaterialStateProperty.all(Colors.blue.shade50),
                        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            return Colors.grey.shade100;
                          },
                        ),
                        columnSpacing: 30,
                        dataRowHeight: 65,
                        columns: const [
                          DataColumn(label: Text('Patient Name')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: dentists
                            .map(
                              (a) => DataRow(
                                cells: [
                                  // ⭐ Avatar + patient Name
                                  DataCell(
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 22,
                                          backgroundColor: Colors.blue.shade100,
                                          child: Text(
                                            a.name.isNotEmpty
                                                ? a.name[0].toUpperCase()
                                                : "?",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
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

                                  // ⭐ Actions (edit / delete)
                                  // DataCell(
                                  //   Row(
                                  //     children: [
                                  //       // IconButton(
                                  //       //   icon: const Icon(Icons.edit,
                                  //       //       color: Colors.blue),
                                  //       //   onPressed: () {
                                  //       //     // TODO: navigate to edit
                                  //       //   },
                                  //       // ),
                                  //         IconButton(
                                  //         icon: const Icon(Icons.edit,
                                  //             color: Colors.blue),
                                  //         onPressed: () {
                                  //           Navigator.push(
                                  //             context,
                                  //             MaterialPageRoute(
                                  //               builder: (_) => AddPatientPage(
                                  //                 patient:
                                  //                     a, // pass dentist to edit
                                  //                 isEdit:
                                  //                     true, // tell page it is editing
                                  //               ),
                                  //             ),
                                  //           );
                                  //         },
                                  //       ),
                                  //       // IconButton(
                                  //       //   icon: const Icon(Icons.delete,
                                  //       //       color: Colors.red),
                                  //       //   onPressed: () {
                                  //       //     // TODO: delete logic
                                  //       //   },
                                  //       // ),
                                  //       IconButton(
                                  //         icon: const Icon(Icons.delete,
                                  //             color: Colors.red),
                                  //         onPressed: () async {
                                  //           bool confirm =
                                  //               await _showDeleteConfirmDialog(
                                  //                   context);

                                  //           if (!confirm) return;

                                  //           final provider =
                                  //               Provider.of<PatientsProvider>(
                                  //                   context,
                                  //                   listen: false);

                                  //           bool success = await provider
                                  //               .removePatient(a.userId);

                                  //           if (success) {
                                  //             ScaffoldMessenger.of(context)
                                  //                 .showSnackBar(
                                  //               SnackBar(
                                  //                   content: Text(
                                  //                       "Dentist deleted successfully")),
                                  //             );
                                  //           } else {
                                  //             ScaffoldMessenger.of(context)
                                  //                 .showSnackBar(
                                  //               SnackBar(
                                  //                   content: Text(
                                  //                       "Failed to delete dentist")),
                                  //             );
                                  //           }
                                  //         },
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  DataCell(
                                    Row(
                                      children: [
                                        // ⭐ Patient History Button
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PatientHistoryPage(
                                                  patientId: a
                                                      .userId, // pass patientId if needed
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.teal,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          child: const Text("History"),
                                        ),

                                        const SizedBox(width: 8),

                                        // ⭐ Payment History Button
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentHistoryPage(
                                                  patientId: a
                                                      .userId, // pass patientId
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          child: const Text("Payments"),
                                        ),

                                        const SizedBox(width: 12),

                                        // ⭐ Edit Icon
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
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

                                        // ⭐ Delete Icon
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () async {
                                            bool confirm =
                                                await _showDeleteConfirmDialog(
                                                    context);
                                            if (!confirm) return;

                                            final provider =
                                                Provider.of<PatientsProvider>(
                                                    context,
                                                    listen: false);
                                            bool success = await provider
                                                .removePatient(a.userId);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(success
                                                    ? "Patient deleted successfully"
                                                    : "Failed to delete patient"),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Delete patient"),
            content: Text("Are you sure you want to delete this patient?"),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text("Delete", style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }
}
