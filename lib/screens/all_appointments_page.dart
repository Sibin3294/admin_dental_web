import 'package:dental_admin_web/models/appointment.dart';
import 'package:dental_admin_web/screens/patient_history.dart';
import 'package:dental_admin_web/services/appointment_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllAppointmentsPage extends StatefulWidget {
  const AllAppointmentsPage({super.key});

  @override
  State<AllAppointmentsPage> createState() => _AllAppointmentsPageState();
}

class _AllAppointmentsPageState extends State<AllAppointmentsPage> {
  late Future<List<AppointmentModel>> futureAppointments;
  final AppointmentService service = AppointmentService();

  // --- FILTER CONTROLLERS ---
  String? selectedDentist;
  String? selectedStatus;
  String selectedSort = 'Latest'; // Latest / Oldest
  DateTime? selectedDate;
  bool filterByWeek = false;

  List<AppointmentModel> allAppointments = [];
  List<AppointmentModel> filteredAppointments = [];

  @override
  void initState() {
    super.initState();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    futureAppointments = service.getAppointments();
    final data = await futureAppointments;
    setState(() {
      allAppointments = data;
      filteredAppointments = List.from(allAppointments);
    });
  }

  void applyFilters() {
    List<AppointmentModel> temp = List.from(allAppointments);

    // Filter by dentist
    if (selectedDentist != null && selectedDentist!.isNotEmpty) {
      temp = temp
          .where((a) => a.dentist != null && a.dentist!.name == selectedDentist)
          .toList();
    }

    // Filter by status
    if (selectedStatus != null && selectedStatus!.isNotEmpty) {
      temp = temp.where((a) => a.status == selectedStatus).toList();
    }

    // Filter by specific date
    if (selectedDate != null) {
      temp = temp
          .where((a) =>
              a.startTime.year == selectedDate!.year &&
              a.startTime.month == selectedDate!.month &&
              a.startTime.day == selectedDate!.day)
          .toList();
    }

    // Filter by week
    if (filterByWeek) {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));
      temp = temp
          .where((a) =>
              a.startTime
                  .isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
              a.startTime.isBefore(weekEnd.add(const Duration(days: 1))))
          .toList();
    }

    // Sort by date
    temp.sort((a, b) => selectedSort == 'Latest'
        ? b.startTime.compareTo(a.startTime)
        : a.startTime.compareTo(b.startTime));

    setState(() {
      filteredAppointments = temp;
    });
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      applyFilters();
    }
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // LEFT: LOGO
                  SizedBox(
                    height: 100, // desired height

                    child: Image.network(
                        "https://t4.ftcdn.net/jpg/03/02/68/11/360_F_302681154_9HOWdvGLtCKpfwO5B85yESszG7MfmlUl.jpg",
                        fit: BoxFit.contain),
                  ),

                  // CENTER: TITLE + SUBTITLE
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      const Text(
                        "All Appointments",
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Manage your patients efficiently",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  // RIGHT: ADD APPOINTMENT BUTTON
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onPressed: () {
                      // Navigate to create appointment page or open modal
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text(
                      "Add Appointment",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<AppointmentModel>>(
        future: futureAppointments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No appointments found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Save data locally for filter
          if (allAppointments.isEmpty) {
            allAppointments = snapshot.data!;
            filteredAppointments = List.from(allAppointments);
          }

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Dentist filter
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person, color: Colors.teal),
                            const SizedBox(width: 6),
                            DropdownButton<String>(
                              hint: const Text("Dentist"),
                              value: selectedDentist,
                              items: allAppointments
                                  .map((a) => a.dentist?.name ?? 'No Dentist')
                                  .toSet()
                                  .map((name) => DropdownMenuItem(
                                      value: name, child: Text(name)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() => selectedDentist = value);
                                applyFilters();
                              },
                            ),
                          ],
                        ),

                        // Status filter
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.info_outline, color: Colors.teal),
                            const SizedBox(width: 6),
                            DropdownButton<String>(
                              hint: const Text("Status"),
                              value: selectedStatus,
                              items: const [
                                DropdownMenuItem(
                                    value: "scheduled",
                                    child: Text("Scheduled")),
                                DropdownMenuItem(
                                    value: "completed",
                                    child: Text("Completed")),
                                DropdownMenuItem(
                                    value: "cancelled",
                                    child: Text("Cancelled")),
                                DropdownMenuItem(
                                    value: "missed", child: Text("Missed")),
                              ],
                              onChanged: (value) {
                                setState(() => selectedStatus = value);
                                applyFilters();
                              },
                            ),
                          ],
                        ),

                        // Date picker
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => pickDate(context),
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: Text(selectedDate == null
                              ? "Select Date"
                              : DateFormat('dd MMM yyyy')
                                  .format(selectedDate!)),
                        ),

                        // Week filter toggle
                        FilterChip(
                          avatar: const Icon(Icons.calendar_view_week,
                              color: Colors.white, size: 18),
                          label: const Text("This Week",
                              style: TextStyle(color: Colors.white)),
                          selected: filterByWeek,
                          onSelected: (v) {
                            setState(() => filterByWeek = v);
                            applyFilters();
                          },
                          backgroundColor: Colors.teal.withOpacity(0.3),
                          selectedColor: Colors.teal,
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        // Sort filter
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.sort, color: Colors.teal),
                            const SizedBox(width: 6),
                            DropdownButton<String>(
                              value: selectedSort,
                              items: const [
                                DropdownMenuItem(
                                    value: "Latest", child: Text("Latest")),
                                DropdownMenuItem(
                                    value: "Oldest", child: Text("Oldest")),
                              ],
                              onChanged: (v) {
                                setState(() => selectedSort = v!);
                                applyFilters();
                              },
                            ),
                          ],
                        ),

                        // Reset Filter Button
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedDentist = null;
                              selectedStatus = null;
                              selectedDate = null;
                              filterByWeek = false;
                              selectedSort = "Latest";
                            });
                            applyFilters();
                          },
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text("Reset Filters"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ---------------- APPOINTMENT LIST ----------------
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: filteredAppointments.length,
                  itemBuilder: (context, index) {
                    final appt = filteredAppointments[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// PATIENT NAME + HISTORY BUTTON
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  appt.patient!.name,
                                 
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientHistoryPage(
          patientId: appt.patient!.id, // pass patientId if needed
        ),
      ),
    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.medical_information,
                                            size: 16, color: Colors.teal),
                                        SizedBox(width: 6),
                                        Text(
                                          "Patient History",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(height: 14),

                            Text(
                              appt.dentist!.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 14),

                            /// DATE
                            Row(
                              children: [
                                const Icon(Icons.calendar_month,
                                    size: 20, color: Colors.teal),
                                const SizedBox(width: 10),
                                Text(
                                  DateFormat('dd MMM yyyy')
                                      .format(appt.startTime),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            /// TIME RANGE
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 20, color: Colors.teal),
                                const SizedBox(width: 10),
                                Text(
                                  "${DateFormat('hh:mm a').format(appt.startTime)}  –  "
                                  "${DateFormat('hh:mm a').format(appt.endTime)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.description_outlined,
                                    size: 20, color: Colors.teal),
                                const SizedBox(width: 10),

                                /// REASON TEXT
                                Expanded(
                                  child: Text(
                                    appt.reason,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.4,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 20),

                                /// STATUS LABEL + DROPDOWN IN SAME ROW
                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 8, vertical: 6),
                                //   decoration: BoxDecoration(
                                //     color: Colors.teal.withOpacity(0.07),
                                //     borderRadius: BorderRadius.circular(10),
                                //     border: Border.all(
                                //         color: Colors.teal.withOpacity(0.2)),
                                //   ),
                                //   child: Row(
                                //     children: [
                                //       const Text(
                                //         "Update Status:",
                                //         style: TextStyle(
                                //           fontSize: 13,
                                //           fontWeight: FontWeight.w600,
                                //           color: Colors.teal,
                                //         ),
                                //       ),
                                //       const SizedBox(width: 10),
                                //       DropdownButton<String>(
                                //         value: appt.status,
                                //         underline: const SizedBox(),
                                //         icon: const Icon(Icons.arrow_drop_down,
                                //             color: Colors.teal),
                                //         dropdownColor: Colors.white,
                                //         items: const [
                                //           DropdownMenuItem(
                                //               value: "scheduled",
                                //               child: Text("Scheduled")),
                                //           DropdownMenuItem(
                                //               value: "completed",
                                //               child: Text("Completed")),
                                //           DropdownMenuItem(
                                //               value: "cancelled",
                                //               child: Text("Cancelled")),
                                //           DropdownMenuItem(
                                //               value: "missed",
                                //               child: Text("Missed")),
                                //         ],
                                //         onChanged: (value) async {
                                //           if (value != null) {
                                //             final success = await service
                                //                 .updateAppointmentStatus(
                                //                     appt.id, value);

                                //             if (success) loadAppointments();

                                //             if (context.mounted) {
                                //               ScaffoldMessenger.of(context)
                                //                   .showSnackBar(
                                //                 SnackBar(
                                //                   content: Text(
                                //                     success
                                //                         ? "Status updated to $value"
                                //                         : "Failed to update status",
                                //                   ),
                                //                   backgroundColor: success
                                //                       ? Colors.green
                                //                       : Colors.red,
                                //                 ),
                                //               );
                                //             }
                                //           }
                                //         },
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
