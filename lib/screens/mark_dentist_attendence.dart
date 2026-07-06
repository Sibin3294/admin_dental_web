// import 'package:dental_admin_web/models/dentist_attendance_model.dart';
// import 'package:dental_admin_web/providers/dentist_attendance_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../providers/dentist_provider.dart';

// enum AttendanceStatus { present, absent, leave }

// class MarkDentistAttendence extends StatefulWidget {
//   const MarkDentistAttendence({super.key});

//   @override
//   State<MarkDentistAttendence> createState() => _MarkDentistAttendenceState();
// }

// class _MarkDentistAttendenceState extends State<MarkDentistAttendence> {
//   DateTime selectedDate = DateTime.now();

//   /// dentistId -> status
//   final Map<String, AttendanceStatus> attendanceMap = {};

//   bool isLoading = true; // 👈 LOCAL LOADING FLAG

//   @override
//   void initState() {
//     super.initState();
//     // _loadDentists();
//       _loadDentistsAndAttendance();

//   }

//   // Future<void> _loadDentists() async {
//   //   try {
//   //     await context.read<DentistsProvider>().fetchAllDentists();
//   //   } catch (e) {
//   //     debugPrint(e.toString());
//   //   } finally {
//   //     setState(() => isLoading = false);
//   //   }
//   // }
//   Future<void> _loadDentistsAndAttendance() async {
//   try {
//     final provider = context.read<DentistsProvider>();
//      final attendenceProvider = context.read<DentistAttendanceProvider>();
//     await provider.fetchAllDentists();
//     await attendenceProvider.fetchAttendanceByDate(selectedDate);

//     attendanceMap.addAll(provider.attendanceMap);
//   } catch (e) {
//     debugPrint(e.toString());
//   } finally {
//     setState(() => isLoading = false);
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     final dentistProvider = context.watch<DentistsProvider>();
//     final dentists = dentistProvider.dentist;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         title: const Text("Mark Dentist Attendance"),
//         backgroundColor: const Color(0xFF1A73E8),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           children: [
//             _dateHeader(),
//             const SizedBox(height: 20),

//             /// ✅ SAFE UI HANDLING
//             Expanded(
//               child: isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : dentists.isEmpty
//                       ? const Center(
//                           child: Text(
//                             "No dentists found",
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         )
//                       : _dentistList(dentists),
//             ),

//             const SizedBox(height: 16),
//             _saveButton(dentists),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================= UI =================

//   Widget _dateHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _cardDecoration(),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}",
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           OutlinedButton.icon(
//             icon: const Icon(Icons.calendar_today),
//             label: const Text("Change Date"),
//             onPressed: _pickDate,
//           )
//         ],
//       ),
//     );
//   }

//   Widget _dentistList(List dentists) {
//     return ListView.separated(
//       itemCount: dentists.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 12),
//       itemBuilder: (context, index) {
//         final dentist = dentists[index];
//         final dentistId = dentist.id;

//         attendanceMap.putIfAbsent(dentistId, () => AttendanceStatus.present);

//         return Container(
//           padding: const EdgeInsets.all(16),
//           decoration: _cardDecoration(),
//           child: Row(
//             children: [
//               const CircleAvatar(
//                 radius: 22,
//                 child: Icon(Icons.medical_services),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       dentist.name,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       dentist.specialization,
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//               DropdownButton<AttendanceStatus>(
//                 value: attendanceMap[dentistId],
//                 underline: const SizedBox(),
//                 onChanged: (value) {
//                   setState(() {
//                     attendanceMap[dentistId] = value!;
//                   });
//                 },
//                 items: AttendanceStatus.values.map((status) {
//                   return DropdownMenuItem(
//                     value: status,
//                     child: Text(
//                       status.name.toUpperCase(),
//                       style: TextStyle(
//                         color: _statusColor(status),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _saveButton(List dentists) {
//     final attendanceProvider = context.watch<DentistAttendanceProvider>();

//     return SizedBox(
//       width: double.infinity,
//       height: 48,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.green,
//         ),
//         onPressed: attendanceProvider.isSubmitting
//             ? null
//             : () async {
//                 /// ✅ ENSURE DEFAULT STATUS FOR ALL DENTISTS
//                 for (final dentist in dentists) {
//                   attendanceMap.putIfAbsent(
//                     dentist.id,
//                     () => AttendanceStatus.present,
//                   );
//                 }

//                 final attendancePayload = dentists.map((dentist) {
//                   return DentistAttendance(
//                     dentistId: dentist.id,
//                     status: attendanceMap[dentist.id]!.name,
//                   ).toJson();
//                 }).toList();

//                 final payload = {
//                   "date": DateFormat('yyyy-MM-dd').format(selectedDate),
//                   "attendance": attendancePayload,
//                 };

//                 try {
//                   await context
//                       .read<DentistAttendanceProvider>()
//                       .markAttendance(payload);

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Attendance marked successfully"),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(e.toString()),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//         child: attendanceProvider.isSubmitting
//             ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.white,
//                 ),
//               )
//             : const Text(
//                 "Save Attendance",
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//       ),
//     );
//   }

//   // ================= HELPERS =================

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime.now().subtract(const Duration(days: 30)),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );

//     if (picked != null) {
//       setState(() => selectedDate = picked);
//     }
//   }

//   Color _statusColor(AttendanceStatus status) {
//     switch (status) {
//       case AttendanceStatus.present:
//         return Colors.green;
//       case AttendanceStatus.absent:
//         return Colors.red;
//       case AttendanceStatus.leave:
//         return Colors.orange;
//     }
//   }

//   BoxDecoration _cardDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: const [
//         BoxShadow(
//           color: Colors.black12,
//           blurRadius: 6,
//           offset: Offset(0, 3),
//         ),
//       ],
//     );
//   }
// }

import 'package:dental_admin_web/models/dentist_attendance_model.dart';
import 'package:dental_admin_web/providers/dentist_attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/dentist_provider.dart';

enum AttendanceStatus { present, absent, leave }

class MarkDentistAttendence extends StatefulWidget {
  const MarkDentistAttendence({super.key});

  @override
  State<MarkDentistAttendence> createState() =>
      _MarkDentistAttendenceState();
}

class _MarkDentistAttendenceState extends State<MarkDentistAttendence> {
  DateTime selectedDate = DateTime.now();

  /// dentistId -> status (LOCAL UI STATE)
  final Map<String, AttendanceStatus> attendanceMap = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDentistsAndAttendance();
  }

  // ================= LOAD DATA =================

  Future<void> _loadDentistsAndAttendance() async {
    try {
      final dentistProvider = context.read<DentistsProvider>();
      final attendanceProvider =
          context.read<DentistAttendanceProvider>();

      await dentistProvider.fetchAllDentists();
      await attendanceProvider.fetchAttendanceByDate(selectedDate);

      attendanceMap
        ..clear()
        ..addAll(attendanceProvider.attendanceMap);
    } catch (e) {
      debugPrint("Load error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final dentists = context.watch<DentistsProvider>().dentist;
    final attendanceProvider =
        context.watch<DentistAttendanceProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Mark Dentist Attendance"),
        backgroundColor: const Color(0xFF1A73E8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _dateHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : dentists.isEmpty
                      ? const Center(child: Text("No dentists found"))
                      : _dentistList(dentists),
            ),
            const SizedBox(height: 16),
            _saveButton(dentists, attendanceProvider),
          ],
        ),
      ),
    );
  }

  Widget _dateHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: const Text("Change Date"),
            onPressed: _pickDate,
          )
        ],
      ),
    );
  }

  Widget _dentistList(List dentists) {
    return ListView.separated(
      itemCount: dentists.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final dentist = dentists[index];
        final dentistId = dentist.id;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 22,
                child: Icon(Icons.medical_services),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dentist.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      dentist.specialization,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              DropdownButton<AttendanceStatus>(
                value:
                    attendanceMap[dentistId] ?? AttendanceStatus.present,
                underline: const SizedBox(),
                onChanged: (value) {
                  setState(() {
                    attendanceMap[dentistId] = value!;
                  });
                },
                items: AttendanceStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status.name.toUpperCase(),
                      style: TextStyle(
                        color: _statusColor(status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _saveButton(
      List dentists, DentistAttendanceProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        onPressed: provider.isSubmitting
            ? null
            : () async {
                for (final dentist in dentists) {
                  attendanceMap.putIfAbsent(
                    dentist.id,
                    () => AttendanceStatus.present,
                  );
                }

                final payload = {
                  "date":
                      DateFormat('yyyy-MM-dd').format(selectedDate),
                  "attendance": dentists.map((dentist) {
                    return DentistAttendance(
                      dentistId: dentist.id,
                      status: attendanceMap[dentist.id]!.name,
                    ).toJson();
                  }).toList(),
                };

                try {
                  await provider.markAttendance(payload);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("Attendance marked successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
        child: provider.isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Save Attendance",
                style:
                    TextStyle(fontSize: 16, color: Colors.white),
              ),
      ),
    );
  }

  // ================= HELPERS =================

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        isLoading = true;
      });

      final attendanceProvider =
          context.read<DentistAttendanceProvider>();

      await attendanceProvider.fetchAttendanceByDate(selectedDate);

      setState(() {
        attendanceMap
          ..clear()
          ..addAll(attendanceProvider.attendanceMap);
        isLoading = false;
      });
    }
  }

  Color _statusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.leave:
        return Colors.orange;
    }
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    );
  }
}

