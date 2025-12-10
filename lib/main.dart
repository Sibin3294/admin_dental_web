import 'package:dental_admin_web/providers/appointments_provider.dart';
import 'package:dental_admin_web/providers/dentist_provider.dart';
import 'package:dental_admin_web/providers/patient_history_provider.dart';
import 'package:dental_admin_web/providers/patient_provider.dart';
import 'package:dental_admin_web/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';

// void main() {
//   runApp(const AdminApp());
// }
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppointmentsProvider()),
        ChangeNotifierProvider(create: (_) => DentistsProvider()),
        ChangeNotifierProvider(create: (_) => PatientsProvider()),
        ChangeNotifierProvider(create: (_) => PatientHistoryProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: const AdminApp(),
    ),
  );
}


class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dental Admin Panel",
      routes: {
        "/": (context) => const AdminLoginPage(),
        "/dashboard": (context) => const DashboardPage(),
      },
      initialRoute: "/",
    );
  }
}
