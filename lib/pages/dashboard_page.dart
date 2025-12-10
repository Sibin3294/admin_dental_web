
import 'dart:ui';
import 'package:dental_admin_web/screens/all_payments_page.dart';
import 'package:dental_admin_web/screens/appointments_list_page.dart';
import 'package:dental_admin_web/screens/dentists_list_page.dart';
import 'package:dental_admin_web/screens/patients_list_page.dart';
import 'package:dental_admin_web/screens/settings.dart';
import 'package:dental_admin_web/services/appointment_service.dart';
import 'package:dental_admin_web/services/dentist_service.dart';
import 'package:dental_admin_web/services/patient_service.dart';
import 'package:dental_admin_web/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/sidebar.dart';
import '../widgets/header.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  int dentistCount = 0;
  int patientCount = 0;
  int appointmentCount = 0;
  int paymentsCount=0;

  @override
  void initState() {
    super.initState();
    fetchAppointmentCount();
    fetchDentistCount();
    fetchPatientCount();
    fetchPaymentsCount();
  }

  Future<void> fetchDentistCount() async {
    try {
      final count = await DentistService.getDentistCount();
      setState(() => dentistCount = count);
    } catch (e) {
      print("Error loading dentist count: $e");
    }
  }

  Future<void> fetchPatientCount() async {
    try {
      final count = await PatientService.getPatientCount();
      setState(() => patientCount = count);
    } catch (e) {
      print("Error loading patient count: $e");
    }
  }

  Future<void> fetchAppointmentCount() async {
    try {
      final count = await AppointmentService.getAppointmentCount();
      setState(() => appointmentCount = count);
    } catch (e) {
      print("Error loading appointment count: $e");
    }
  }


  Future<void> fetchPaymentsCount() async {
    try {
      final count = await PaymentService.getPaymentCount();
      setState(() => paymentsCount = count);
    } catch (e) {
      print("Error loading payments count: $e");
    }
  }

  List<Widget> get _pages => [
        _dashboardContent(appointmentCount, dentistCount, patientCount,paymentsCount),
        const AppointmentsPage(),
        const DentistsListPage(),
        const PatientsListPage(),
        const AllPaymentsPage(),
        const SettingsPage(),
      ];

  void _onMenuTap(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      fetchAppointmentCount();
      fetchDentistCount();
      fetchPatientCount();
      fetchPaymentsCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBar(onMenuTap: _onMenuTap, selectedIndex: _selectedIndex),
          Expanded(
            child: _selectedIndex == 0
                ? _dashboardContent(
                    appointmentCount, dentistCount, patientCount,paymentsCount)
                : _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

// Widget _dashboardContent(
//     int appointmentCount, int dentistCount, int patientCount) {
//   return Container(
//     decoration: const BoxDecoration(
//       gradient: LinearGradient(
//         colors: [Color(0xffeef2f3), Color(0xffdfe9f3)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//     ),
//     child: Column(
//       children: [
//         const Header(),

//         // ------------ STAT CARDS + CHART CONTAINER ------------
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(28),
//             child: Column(
//               children: [
//                 // --------------------- STAT CARDS ROW ---------------------
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: _statCard(
//                         "Total Appointments",
//                         "$appointmentCount",
//                         Icons.calendar_month,
//                         Colors.deepPurple,
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Expanded(
//                       child: _statCard(
//                         "Patients",
//                         "$patientCount",
//                         Icons.people,
//                         Colors.teal,
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Expanded(
//                       child: _statCard(
//                         "Dentists",
//                         "$dentistCount",
//                         Icons.medical_information,
//                         Colors.blue,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 35),

//                 // ---------------------- CHART CARD -----------------------
//             Expanded(
//   child: Padding(
//     padding: const EdgeInsets.only(bottom: 20), // Extra safe spacing
//     child: BarChart(
//   BarChartData(
//     alignment: BarChartAlignment.spaceAround,
//     borderData: FlBorderData(show: false),
//     gridData: FlGridData(show: false),
//     titlesData: FlTitlesData(
//        topTitles: AxisTitles(
//         sideTitles: SideTitles(showTitles: false), // 👈 disable top titles
//       ),
//       bottomTitles: AxisTitles(
        
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 40, // 👈 Important: gives space for labels
//           getTitlesWidget: (value, _) {
//             switch (value.toInt()) {
//               case 0:
//                 return _chartLabel("Appointments");
//               case 1:
//                 return _chartLabel("Patients");
//               case 2:
//                 return _chartLabel("Dentists");
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//     ),
//     barGroups: [
//       BarChartGroupData(
//         x: 0,
//         barRods: [
//           BarChartRodData(
//             toY: appointmentCount.toDouble(),
//             color: Colors.deepPurple,
//             width: 28,
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ],
//       ),
//       BarChartGroupData(
//         x: 1,
//         barRods: [
//           BarChartRodData(
//             toY: patientCount.toDouble(),
//             color: Colors.teal,
//             width: 28,
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ],
//       ),
//       BarChartGroupData(
//         x: 2,
//         barRods: [
//           BarChartRodData(
//             toY: dentistCount.toDouble(),
//             color: Colors.blue,
//             width: 28,
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ],
//       ),
//     ],
   
//     barTouchData: BarTouchData(enabled: false),
//     maxY: [
//       appointmentCount.toDouble(),
//       patientCount.toDouble(),
//       dentistCount.toDouble()
//     ].reduce((a, b) => a > b ? a : b) *
//         1.2, // give top margin as well
//   ),
// )
// ,
//     // child: BarChart(
//     //   BarChartData(
//     //     alignment: BarChartAlignment.spaceAround,
//     //     borderData: FlBorderData(show: false),
//     //     gridData: FlGridData(show: false),
//     //     titlesData: FlTitlesData(
//     //       bottomTitles: AxisTitles(
//     //         sideTitles: SideTitles(
//     //           showTitles: true,
//     //           getTitlesWidget: (value, _) {
//     //             switch (value.toInt()) {
//     //               case 0:
//     //                 return _chartLabel("Appointments");
//     //               case 1:
//     //                 return _chartLabel("Patients");
//     //               case 2:
//     //                 return _chartLabel("Dentists");
//     //             }
//     //             return const SizedBox.shrink();
//     //           },
//     //         ),
//     //       ),
//     //       leftTitles: AxisTitles(
//     //         sideTitles: SideTitles(showTitles: false),
//     //       ),
//     //     ),

//     //     barGroups: [
//     //       BarChartGroupData(
//     //         x: 0,
//     //         barRods: [
//     //           BarChartRodData(
//     //             toY: appointmentCount.toDouble(),
//     //             color: Colors.deepPurple,
//     //             width: 28,
//     //             borderRadius: BorderRadius.circular(8),
//     //           ),
//     //         ],
//     //       ),
//     //       BarChartGroupData(
//     //         x: 1,
//     //         barRods: [
//     //           BarChartRodData(
//     //             toY: patientCount.toDouble(),
//     //             color: Colors.teal,
//     //             width: 28,
//     //             borderRadius: BorderRadius.circular(8),
//     //           ),
//     //         ],
//     //       ),
//     //       BarChartGroupData(
//     //         x: 2,
//     //         barRods: [
//     //           BarChartRodData(
//     //             toY: dentistCount.toDouble(),
//     //             color: Colors.blue,
//     //             width: 28,
//     //             borderRadius: BorderRadius.circular(8),
//     //           ),
//     //         ],
//     //       ),
//     //     ],
//     //   ),
//     // ),
//   ),
// )

//               ],
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }

Widget _dashboardContent(
    int appointmentCount, int dentistCount, int patientCount, int paymentsCount) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xffeef2f3), Color(0xffdfe9f3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Column(
      children: [
        const Header(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                // --------------------- STAT CARDS ROW ---------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _statCard(
                        "Appointments",
                        "$appointmentCount",
                        Icons.calendar_month,
                        Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _statCard(
                        "Patients",
                        "$patientCount",
                        Icons.people,
                        Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _statCard(
                        "Dentists",
                        "$dentistCount",
                        Icons.medical_information,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _statCard(
                        "Payments",
                        "$paymentsCount",
                        Icons.payment,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // ---------------------- CHARTS ROW -----------------------
                Expanded(
                  child: Row(
                    children: [
                      // ---------------------- Appointments/Patients/Dentists Chart -----------------
                      Expanded(
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Overview",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceAround,
                                      borderData: FlBorderData(show: false),
                                      gridData: FlGridData(show: false),
                                      titlesData: FlTitlesData(
                                        topTitles:
                                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 40,
                                            getTitlesWidget: (value, _) {
                                              switch (value.toInt()) {
                                                case 0:
                                                  return _chartLabel("Appointments");
                                                case 1:
                                                  return _chartLabel("Patients");
                                                case 2:
                                                  return _chartLabel("Dentists");
                                              }
                                              return const SizedBox.shrink();
                                            },
                                          ),
                                        ),
                                        leftTitles:
                                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      ),
                                      barGroups: [
                                        BarChartGroupData(
                                          x: 0,
                                          barRods: [
                                            BarChartRodData(
                                              toY: appointmentCount.toDouble(),
                                              color: Colors.deepPurple,
                                              width: 28,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 1,
                                          barRods: [
                                            BarChartRodData(
                                              toY: patientCount.toDouble(),
                                              color: Colors.teal,
                                              width: 28,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 2,
                                          barRods: [
                                            BarChartRodData(
                                              toY: dentistCount.toDouble(),
                                              color: Colors.blue,
                                              width: 28,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ],
                                        ),
                                      ],
                                      maxY: [
                                        appointmentCount.toDouble(),
                                        patientCount.toDouble(),
                                        dentistCount.toDouble()
                                      ].reduce((a, b) => a > b ? a : b) *
                                          1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // ---------------------- Payments Chart -----------------
                      Expanded(
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Payments Overview",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: PieChart(
                                    PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                          value: paymentsCount.toDouble(),
                                          color: Colors.orange,
                                          title: 'Total',
                                          titleStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        PieChartSectionData(
                                          value: (appointmentCount + patientCount).toDouble(),
                                          color: Colors.grey.shade300,
                                          title: '',
                                        ),
                                      ],
                                      sectionsSpace: 2,
                                      centerSpaceRadius: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Total Payments: $paymentsCount",
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}


Widget _chartLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600),
    ),
  );
}

Widget _statCard(String title, String value, IconData icon, Color color) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.45),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xff2c3e50),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
