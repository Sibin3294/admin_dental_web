import 'package:dental_admin_web/models/appointment.dart';
import 'package:dental_admin_web/models/branch.dart';
import 'package:dental_admin_web/models/dentist.dart';
import 'package:dental_admin_web/models/patient.dart';
import 'package:dental_admin_web/providers/branch_provider.dart';
import 'package:dental_admin_web/screens/all_appointments_page.dart';
import 'package:dental_admin_web/services/appointment_service.dart';
import 'package:dental_admin_web/services/dentist_service.dart';
import 'package:dental_admin_web/services/patient_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<Appointment> appointments = [];

  final DentistService dentistService = DentistService();
  final PatientService patientService = PatientService();
  List<Dentist> allDentists = [];
  List<Patient> allpatients = [];
  DateTime selectedDay = DateTime.now();
  List<Appointment> dayAppointments = [];
  List<Patient> allPatients = []; // Fetch this from your backend or provider
  Patient? selectedPatient;

  @override
  void initState() {
    super.initState();
    loadDentists();
    loadPatients();
    loadAppointments();
    filterAppointmentsByDay();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BranchProvider>(context, listen: false).fetchBranches();
    });
  }

  Future<void> loadDentists() async {
    try {
      List<Dentist> fetched = await dentistService.fetchAlllDentists();

      setState(() {
        allDentists = fetched; // works now ✔️
      });
    } catch (e) {
      print("Failed to load dentists: $e");
    }
  }

  Future<void> loadPatients() async {
    try {
      List<Patient> fetchedpatients = await patientService.fetchAlllPatients();

      setState(() {
        allPatients = fetchedpatients; // works now ✔️
      });
    } catch (e) {
      print("Failed to load dentists: $e");
    }
  }

  // void _onCalendarTap(CalendarTapDetails details) {
  //   if (details.targetElement == CalendarElement.calendarCell ||
  //       details.targetElement == CalendarElement.appointment) {
  //     _openCreateAppointmentDialog(details.date!);
  //   }
  // }

  void _onCalendarTap(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment) {
      final Appointment tapped = details.appointments!.first;
      _openCreateAppointmentDialog(tapped.startTime!, existing: tapped);
    } else if (details.targetElement == CalendarElement.calendarCell) {
      _openCreateAppointmentDialog(details.date!);
    }
  }

  // void _openCreateAppointmentDialog(DateTime selectedDate) async {
  void _openCreateAppointmentDialog(DateTime selectedDate,
      {Appointment? existing}) async {
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    if (branchProvider.branches.isEmpty) {
      await branchProvider.fetchBranches();
    }

    // If editing existing appointment, parse the subject
    String initialPatient = "";
    String initialReason = "";
    String initialDentist = "";

    if (existing != null) {
      final parts = existing.subject.split(" - ");
      initialPatient = parts[0];

      final parts2 = parts.length > 1 ? parts[1].split("(") : [];
      initialReason = parts2[0].trim();
      initialDentist =
          existing.subject.split("(").last.replaceAll(")", "").trim();
    }

    Dentist? selectedDentist = existing == null
        ? null
        : allDentists.firstWhere(
            (x) => x.name == initialDentist,
            orElse: () => allDentists.first,
          );

    List<Dentist> dentists = allDentists;

    // Dentist? selectedDentist;
    TextEditingController nameCtrl = TextEditingController();
    TextEditingController reasonCtrl = TextEditingController();
    TextEditingController mobileCtrl = TextEditingController();
    TimeOfDay? selectedTime = TimeOfDay.fromDateTime(selectedDate);
    Branch? selectedBranch;
    if (branchProvider.activeBranches.isNotEmpty) {
      selectedBranch = branchProvider.activeBranches.first;
    }

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          final activeBranches =
              Provider.of<BranchProvider>(context).activeBranches;
          if (selectedBranch == null && activeBranches.isNotEmpty) {
            selectedBranch = activeBranches.first;
          }

          return AlertDialog(
            // title: const Text("Create Appointment"),
            title: Text(
                existing == null ? "Create Appointment" : "Edit Appointment"),

            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show selected date
                  Text(
                      "Selected Date: ${selectedDate.toLocal().toString().split(' ')[0]}"),
                  const SizedBox(height: 10),

                  // Pick exact time
                  Row(
                    children: [
                      Text("Time: ${selectedTime!.format(context)}"),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? picked =
                              await pickValidTime(context, selectedDate);

                          if (picked != null) {
                            setState(() => selectedTime = picked);
                          }
                        },
                        child: const Text("Pick Time"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Dentist selection
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person),
                    label: Text(selectedDentist?.name ?? "Select Dentist"),
                    onPressed: () async {
                      final d =
                          await openDentistSelectionDialog(context, dentists);
                      if (d != null) setState(() => selectedDentist = d);
                    },
                  ),

                  if (selectedDentist != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(selectedDentist!.image),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedDentist!.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(selectedDentist!.specialization),
                          ],
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 10),

                  if (activeBranches.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: const Text(
                        'No active branches found. Add a branch from the Branches menu first.',
                        style: TextStyle(color: Colors.orange),
                      ),
                    )
                  else
                    DropdownButtonFormField<Branch>(
                      value: selectedBranch,
                      decoration: const InputDecoration(
                        labelText: "Select Branch *",
                        border: OutlineInputBorder(),
                      ),
                      items: activeBranches.map((branch) {
                        return DropdownMenuItem<Branch>(
                          value: branch,
                          child: Text(branch.name),
                        );
                      }).toList(),
                      onChanged: (branch) {
                        setState(() {
                          selectedBranch = branch;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a branch' : null,
                    ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<Patient>(
                    value: selectedPatient,
                    decoration: const InputDecoration(
                      labelText: "Select Patient",
                      border: OutlineInputBorder(),
                    ),
                    items: allPatients.map((patient) {
                      return DropdownMenuItem<Patient>(
                        value: patient,
                        child: Text("${patient.name}"),
                      );
                    }).toList(),
                    onChanged: (patient) {
                      setState(() {
                        selectedPatient = patient;
                      });
                    },
                  ),

                  TextField(
                    controller: mobileCtrl,
                    decoration: const InputDecoration(labelText: "Mobile"),
                  ),
                  TextField(
                    controller: reasonCtrl,
                    decoration: const InputDecoration(labelText: "Reason"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              // ElevatedButton(
              //   onPressed: () {
              //     if (selectedDentist == null) return;

              //     final finalDateTime = DateTime(
              //       selectedDate.year,
              //       selectedDate.month,
              //       selectedDate.day,
              //       selectedTime!.hour,
              //       selectedTime!.minute,
              //     );

              //     if (existing == null) {
              //       // CREATE NEW
              //       // _saveAppointment(finalDateTime, nameCtrl.text,
              //       //     reasonCtrl.text, selectedDentist!.name);
              //       _saveAppointment(
              //           patientId: selectedPatient!.userId,
              //           date: finalDateTime,
              //           // patientName: nameCtrl.text.trim(),
              //           patientName: selectedPatient?.name ?? "",

              //           // mobile: mobileCtrl.text.trim(),
              //           // reason: reasonCtrl.text.trim(),
              //           // dentist: selectedDentist!,
              //           mobile: selectedPatient?.phone ?? "",
              //           reason: reasonCtrl.text.trim(),
              //           dentist: selectedDentist!);
              //     } else {
              //       // UPDATE EXISTING
              //       _updateAppointment(existing, finalDateTime, nameCtrl.text,
              //           reasonCtrl.text, selectedDentist!.name);
              //     }

              //     Navigator.pop(context);
              //   },

              //   // child: const Text("Book"),
              //   child: Text(existing == null ? "Book" : "Save"),
              // ),
              ElevatedButton(
  onPressed: () {
    if (selectedDentist == null || selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select patient and dentist')),
      );
      return;
    }

    if (selectedBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a branch or add one from Branches menu'),
        ),
      );
      return;
    }

    final finalDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    if (existing == null) {
      _saveAppointment(
        patientId: selectedPatient!.userId,
        dentistId: selectedDentist!.id,
        reason: reasonCtrl.text.trim(),
        date: finalDateTime,
        branchId: selectedBranch?.id,
      );
    } else {
      // UPDATE EXISTING
      // _updateAppointment(existing, finalDateTime, reasonCtrl.text.trim(),
      //     selectedDentist!.id, selectedPatient!.userId);
          
    }


    Navigator.pop(context);
  },
  child: Text(existing == null ? "Book" : "Save"),
)

            ],
          );
        },
      ),
    );
  }

  // ----------------------------
  // Dentist Selection Dialog
  // ----------------------------
  Future<Dentist?> openDentistSelectionDialog(
      BuildContext context, List<Dentist> dentists) {
    TextEditingController searchCtrl = TextEditingController();
    List<Dentist> filtered = List.from(dentists);

    return showDialog<Dentist>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Select Dentist"),
              content: SizedBox(
                width: 350,
                height: 420,
                child: Column(
                  children: [
                    TextField(
                      controller: searchCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search dentist...",
                      ),
                      onChanged: (value) {
                        setState(() {
                          filtered = dentists
                              .where((d) =>
                                  d.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  d.specialization
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final d = filtered[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(d.image),
                            ),
                            title: Text(d.name),
                            subtitle: Text(d.specialization),
                            onTap: () => Navigator.pop(context, d),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
              ],
            );
          },
        );
      },
    );
  }

  final AppointmentService appointmentService = AppointmentService();

  // Future<void> _saveAppointment({
  //   required DateTime date,
  //   required String patientName,
  //   required String mobile,
  //   required String reason,
  //   required Dentist dentist,
  //   required String patientId,
  // }) async {
  //   final newStart = date;
  //   final newEnd = date.add(const Duration(hours: 1));

  //   try {
  //     final createdAppointment = await appointmentService.createAppointment({
  //       "patientName": patientName,
  //       "mobile": mobile,
  //       "reason": reason,
  //       "dentist": dentist.id,
  //       // "startTime": newStart.toIso8601String(),
  //       // "endTime": newEnd.toIso8601String(),
  //       "startTime": newStart.toUtc().toIso8601String(),
  //       "endTime": newEnd.toUtc().toIso8601String(),
  //     });

  //     final newAppointment = Appointment(
  //       startTime: createdAppointment.startTime,
  //       endTime: createdAppointment.endTime,
  //       subject: "$patientName - $reason",
  //       color: Colors.green,
  //     );

  //     await loadAppointments();

  //     setState(() {});

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Appointment created successfully")),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to save appointment: $e")),
  //     );
  //   }
  // }

  Future<void> _saveAppointment({
  required DateTime date,
  required String patientId,
  required String reason,
  required String dentistId,
  String? branchId,
}) async {
  final newStart = date;
  final newEnd = date.add(const Duration(minutes: 30));

  try {
    await appointmentService.createAppointment({
      "patientId": patientId,
      "reason": reason,
      "dentist": dentistId,
      if (branchId != null && branchId.isNotEmpty) "branch": branchId,
      "startTime": newStart.toUtc().toIso8601String(),
      "endTime": newEnd.toUtc().toIso8601String(),
    });

    await loadAppointments();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Appointment saved successfully")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to save appointment: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Icon(Icons.calendar_month, color: Colors.teal, size: 26),
            SizedBox(width: 8),
            Text(
              "Appointments",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllAppointmentsPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.view_list,
              color: Colors.teal,
              size: 20,
            ),
            label: const Text(
              "View All Appointments",
              style: TextStyle(
                color: Colors.teal,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------------------------
            // SYNCFUSION CALENDAR
            // ---------------------------
            SizedBox(
              height: 550, // Adjust based on your layout
              child: SfCalendar(
                minDate: DateTime.now(),
                view: CalendarView.week,
                dataSource: AppointmentDataSource(appointments),
                onTap: _onCalendarTap,
                timeSlotViewSettings: const TimeSlotViewSettings(
                  startHour: 8,
                  endHour: 23,
                  timeIntervalHeight: 60,
                ),
                appointmentTextStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6A11CB),
                      Color(0xFF2575FC),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      "Selected Day: ${selectedDay.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: [
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 20,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: openCustomDatePicker,
                            child: const Text("Pick Date"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------------
            // DAILY APPOINTMENTS TABLE
            // ---------------------------
            if (dayAppointments.isEmpty)
              const Text(
                "No appointments for this day",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black12,
                    )
                  ],
                ),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Time")),
                    DataColumn(label: Text("Patient")),
                    DataColumn(label: Text("Branch")),
                    DataColumn(label: Text("Mobile")),
                    DataColumn(label: Text("Dentist")),
                    DataColumn(label: Text("Reason")),
                  ],
                  rows: dayAppointments.map((a) {
                    final parts = a.subject.split(" - ");
                    final patient = parts[0];
                    final reason =
                        parts.length > 1 ? parts[1].split("(")[0].trim() : "";
                    final dentist =
                        a.subject.split("(").last.replaceAll(")", "");

                    return DataRow(cells: [
                      DataCell(Text(
                          "${a.startTime.hour.toString().padLeft(2, '0')}:${a.startTime.minute.toString().padLeft(2, '0')}")),
                      DataCell(Text(patient)),
                      DataCell(Text(a.notes ?? '—')),
                      DataCell(Text("N/A")),
                      DataCell(Text(dentist)),
                      DataCell(Text(reason)),
                    ]);
                  }).toList(),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // void _updateAppointment(
  //   Appointment old,
  //   DateTime newTime,
  //   String patient,
  //   String reason,
  //   String dentistName,
  // ) {
  //   final updated = Appointment(
  //     startTime: newTime,
  //     endTime: newTime.add(const Duration(hours: 1)),
  //     subject: "$patient - $reason ($dentistName)",
  //     color: old.color,
  //   );

  //   setState(() {
  //     // appointments.remove(old);
  //     appointments.add(updated);
  //     filterAppointmentsByDay();
  //   });

  //   // TODO: Call backend update API
  // }

  void _updateAppointment(
  AppointmentModel old,
  DateTime newTime,
  String reason,
  String dentistId,
  String patientId,
) async {
  final newEnd = newTime.add(const Duration(minutes: 30));

  try {
    await appointmentService.updateAppointment(old.id, {
      "patientId": patientId,
      "reason": reason,
      "dentist": dentistId,
      "startTime": newTime.toUtc().toIso8601String(),
      "endTime": newEnd.toUtc().toIso8601String(),
    });

    await loadAppointments();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Appointment updated successfully")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to update appointment: $e")),
    );
  }
}


  Future<TimeOfDay?> pickValidTime(
      BuildContext context, DateTime selectedDate) async {
    final now = DateTime.now();

    // For today → start at current time, otherwise fallback to 9 AM
    final initial = selectedDate.isSameDate(now)
        ? TimeOfDay(hour: now.hour, minute: now.minute)
        : const TimeOfDay(hour: 9, minute: 0);

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (picked == null) return null;

    // If selected date is today → block past time
    if (selectedDate.isSameDate(now)) {
      final selectedDateTime = DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, picked.hour, picked.minute);

      if (selectedDateTime.isBefore(now)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Past time not allowed")),
        );
        return pickValidTime(context, selectedDate); // reopen picker
      }
    }

    return picked;
  }

  void filterAppointmentsByDay() {
    setState(() {
      dayAppointments = appointments
          .where((a) =>
              a.startTime.year == selectedDay.year &&
              a.startTime.month == selectedDay.month &&
              a.startTime.day == selectedDay.day)
          .toList();
    });
  }

// Future<void> loadAppointments() async {
//   try {
//     final appts = await appointmentService.getAppointments();

//     setState(() {
//       appointments = appts.map((a) {
//         return Appointment(
//           startTime: a.startTime.toLocal(),
//           endTime: a.endTime.toLocal(),
//           // subject:
//           //      "${a.patientName} - ${a.reason}",
//           subject: "${a.patient!.name} - ${a.reason} (${a.dentist!.name??'No Dentist'})",
//           color: Colors.green,
//         );
//       }).toList();

//       filterAppointmentsByDay();
//     });
//   } catch (e) {
//     print("Error loading appointments: $e");
//   }
// }

  Future<void> loadAppointments() async {
    try {
      final appts = await appointmentService.getAppointments();

      setState(() {
        appointments = appts
            .where((a) => a.startTime != null && a.endTime != null)
            .map((a) {
          final patientName = a.patient?.name ?? "Unknown Patient";
          final dentistName = a.dentist?.name ?? "No Dentist";

          return Appointment(
            startTime: a.startTime.toLocal(),
            endTime: a.endTime.toLocal(),
            subject: "$patientName - ${a.reason} ($dentistName)",
            notes: a.branch?.name ?? '',
            color: Colors.green,
          );
        }).toList();
        print("Mapped appointments for calendar:");
        appointments.forEach((a) {
          print("${a.subject} | ${a.startTime} - ${a.endTime}");
        });

        filterAppointmentsByDay();
      });
    } catch (e) {
      print("Error loading appointments: $e");
    }
  }

  Future<void> openCustomDatePicker() async {
    DateTime tempSelectedDate = selectedDay;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Date",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // -------- Calendar UI ----------
              CalendarDatePicker(
                initialDate: selectedDay,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChanged: (value) {
                  tempSelectedDate = value;
                },
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 10),

              // -------- VIEW APPOINTMENTS Button ----------
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  setState(() {
                    selectedDay = tempSelectedDate;
                  });
                  Navigator.pop(context);
                  filterAppointmentsByDay();
                },
                child: const Text(
                  "View Appointments",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

// ----------------------------
// Calendar Data Source
// ----------------------------
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}


// import 'package:dental_admin_web/models/appointment.dart';
// import 'package:dental_admin_web/providers/appointments_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';

// class AppointmentsPage extends StatefulWidget {
//   const AppointmentsPage({super.key});

//   @override
//   State<AppointmentsPage> createState() => _AppointmentsPageState();
// }

// class _AppointmentsPageState extends State<AppointmentsPage> {
//   DateTime selectedDay = DateTime.now();
//   List<Appointment> dayAppointments = [];

//   // @override
//   // void initState() {
//   //   super.initState();
    
//   //   final provider = Provider.of<AppointmentsProvider>(context, listen: false);
//   //   provider.fetchAppointments(); // Load appointments from provider
//   // }

//   @override
// void initState() {
//   super.initState();
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     final provider = Provider.of<AppointmentsProvider>(context, listen: false);
//     provider.fetchAppointments();
//   });
// }


//   // ----------------------------
//   // Filter daily appointments for the selected day
//   // ----------------------------
//   void filterAppointmentsByDay(List<AppointmentModel> appointments) {
  
//       dayAppointments = appointments
//           .where((a) =>
//               a.startTime.year == selectedDay.year &&
//               a.startTime.month == selectedDay.month &&
//               a.startTime.day == selectedDay.day)
//           .map((a) => Appointment(
//                 startTime: a.startTime.toLocal(),
//                 endTime: a.endTime.toLocal(),
//                 subject:
//                     "${a.patientName} - ${a.reason} (${a.dentist?['name'] ?? ''})",
//                 color: Colors.green,
//               ))
//           .toList();
    
//   }

//   // ----------------------------
//   // Open custom date picker
//   // ----------------------------
//   Future<void> openCustomDatePicker() async {
//     DateTime tempSelectedDate = selectedDay;

//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "Select Date",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               CalendarDatePicker(
//                 initialDate: selectedDay,
//                 firstDate: DateTime.now(),
//                 lastDate: DateTime.now().add(const Duration(days: 365)),
//                 onDateChanged: (value) => tempSelectedDate = value,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(double.infinity, 50),
//                     backgroundColor: Colors.green),
//                 onPressed: () {
//                   setState(() => selectedDay = tempSelectedDate);
//                   Navigator.pop(context);

//                   final appointments =
//                       Provider.of<AppointmentsProvider>(context, listen: false)
//                           .appointments;
//                   filterAppointmentsByDay(appointments);
//                 },
//                 child: const Text(
//                   "View Appointments",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppointmentsProvider>(
//       builder: (context, provider, child) {
//         final appointments = provider.appointments;

//         // Initial filter for selected day
//         if (dayAppointments.isEmpty) {
//           filterAppointmentsByDay(appointments);
//         }

//         return Scaffold(
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             title: const Row(
//               children: [
//                 Icon(Icons.calendar_month, color: Colors.teal, size: 26),
//                 SizedBox(width: 8),
//                 Text(
//                   "Appointments",
//                   style: TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87),
//                 ),
//               ],
//             ),
//           ),
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 550,
//                   child: SfCalendar(
//                     minDate: DateTime.now(),
//                     view: CalendarView.week,
//                     dataSource: AppointmentDataSource(dayAppointments),
//                     timeSlotViewSettings: const TimeSlotViewSettings(
//                       startHour: 8,
//                       endHour: 23,
//                       timeIntervalHeight: 60,
//                     ),
//                     appointmentTextStyle:
//                         const TextStyle(fontSize: 14, color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                           colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight),
//                       borderRadius: BorderRadius.circular(14),
//                       boxShadow: const [
//                         BoxShadow(color: Colors.black26, blurRadius: 10)
//                       ],
//                     ),
//                     child: ExpansionTile(
//                       title: Text(
//                         "Selected Day: ${selectedDay.toLocal().toString().split(' ')[0]}",
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       iconColor: Colors.white,
//                       collapsedIconColor: Colors.white,
//                       children: [
//                         const SizedBox(height: 10),
//                         Wrap(
//                           spacing: 20,
//                           runSpacing: 12,
//                           alignment: WrapAlignment.center,
//                           children: [
//                             ElevatedButton(
//                                 onPressed: openCustomDatePicker,
//                                 child: const Text("Pick Date")),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 if (dayAppointments.isEmpty)
//                   const Text("No appointments for this day",
//                       style: TextStyle(fontSize: 16, color: Colors.grey))
//                 else
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     margin: const EdgeInsets.symmetric(horizontal: 16),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.white,
//                         boxShadow: const [
//                           BoxShadow(blurRadius: 4, color: Colors.black12)
//                         ]),
//                     child: DataTable(
//                       columns: const [
//                         DataColumn(label: Text("Time")),
//                         DataColumn(label: Text("Patient")),
//                         DataColumn(label: Text("Mobile")),
//                         DataColumn(label: Text("Dentist")),
//                         DataColumn(label: Text("Reason")),
//                       ],
//                       rows: dayAppointments.map((a) {
//                         final parts = a.subject.split(" - ");
//                         final patient = parts[0];
//                         final reason =
//                             parts.length > 1 ? parts[1].split("(")[0].trim() : "";
//                         final dentist =
//                             a.subject.split("(").last.replaceAll(")", "");
//                         return DataRow(cells: [
//                           DataCell(Text(
//                               "${a.startTime.hour.toString().padLeft(2, '0')}:${a.startTime.minute.toString().padLeft(2, '0')}")),
//                           DataCell(Text(patient)),
//                           DataCell(Text("N/A")), // Replace with provider mobile if needed
//                           DataCell(Text(dentist)),
//                           DataCell(Text(reason)),
//                         ]);
//                       }).toList(),
//                     ),
//                   ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // ----------------------------
// // Calendar Data Source
// // ----------------------------
// class AppointmentDataSource extends CalendarDataSource {
//   AppointmentDataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }



