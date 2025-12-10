import 'package:dental_admin_web/providers/dentist_provider.dart';
import 'package:dental_admin_web/screens/add_dentist_page.dart';
import 'package:dental_admin_web/screens/dentist_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DentistsListPage extends StatelessWidget {
  const DentistsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   "Dentists",
            //   style: TextStyle(
            //     fontSize: 30,
            //     fontWeight: FontWeight.bold,
            //     color: Color(0xff2c3e50),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Dentists",
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
                      MaterialPageRoute(builder: (_) => const AddDentistPage()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Dentist"),
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
                future: Provider.of<DentistsProvider>(context, listen: false)
                    .fetchAllDentists(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final dentists =
                      Provider.of<DentistsProvider>(context).dentist;

                  if (dentists.isEmpty) {
                    return const Center(
                      child: Text("No dentists found.",
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
                        showCheckboxColumn: false,
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2c3e50),
                        ),
                        dataTextStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff34495e),
                        ),
                        headingRowColor:
                            WidgetStateProperty.all(Colors.blue.shade50),
                        dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            return Colors.grey.shade100;
                          },
                        ),
                        columnSpacing: 30,
                        // ignore: deprecated_member_use
                        dataRowHeight: 65,
                        columns: const [
                          DataColumn(label: Text('Dentist Name')),
                          DataColumn(label: Text('Specialization')),
                          DataColumn(label: Text('Experience')),
                          DataColumn(label: Text('Qualification')),
                          DataColumn(label: Text('ConsultationTiming')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: dentists
                            .map(
                              (a) => DataRow(
                                onSelectChanged: (_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DentistDetailsPage(dentist: a),
                                    ),
                                  );
                                },
                                cells: [
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
                                  DataCell(Text(a.specialization)),
                                  DataCell(Text("${a.experience} yrs")),
                                  DataCell(Text(a.qualification)),
                                  DataCell(Text(a.consultationTimings ?? " ")),
                                  DataCell(
                                    Row(
                                      children: [
                                        // IconButton(
                                        //   icon: const Icon(Icons.edit,
                                        //       color: Colors.blue),
                                        //   onPressed: () {},
                                        // ),
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => AddDentistPage(
                                                  dentist:
                                                      a, // pass dentist to edit
                                                  isEdit:
                                                      true, // tell page it is editing
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
                                                Provider.of<DentistsProvider>(
                                                    context,
                                                    listen: false);

                                            bool success = await provider
                                                .removeDentist(a.id);

                                            if (success) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Dentist deleted successfully")),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Failed to delete dentist")),
                                              );
                                            }
                                          },
                                        )
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
            title: Text("Delete Dentist"),
            content: Text("Are you sure you want to delete this dentist?"),
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
