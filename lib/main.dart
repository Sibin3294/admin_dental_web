import 'package:dental_admin_web/config/api_config.dart';
import 'package:dental_admin_web/providers/appointments_provider.dart';
import 'package:dental_admin_web/providers/data_sheet_provider.dart';
import 'package:dental_admin_web/providers/dentist_attendance_provider.dart';
import 'package:dental_admin_web/providers/dentist_provider.dart';
import 'package:dental_admin_web/providers/dentist_slot_provider.dart';
import 'package:dental_admin_web/providers/patient_history_provider.dart';
import 'package:dental_admin_web/providers/patient_provider.dart';
import 'package:dental_admin_web/providers/enquiry_provider.dart';
import 'package:dental_admin_web/providers/branch_provider.dart';
import 'package:dental_admin_web/providers/package_provider.dart';
import 'package:dental_admin_web/providers/payment_provider.dart';
import 'package:dental_admin_web/providers/service_video_provider.dart';
import 'package:dental_admin_web/services/dentist_attendance_service.dart';
import 'package:dental_admin_web/theme/app_theme.dart';
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
        ChangeNotifierProvider(create: (_) => ServiceVideoProvider()),
        ChangeNotifierProvider(create: (_) => PackageProvider()),
        ChangeNotifierProvider(create: (_) => BranchProvider()),
        ChangeNotifierProvider(create: (_) => EnquiryProvider()),
        ChangeNotifierProvider(create: (_) => DentistSlotProvider()),
         ChangeNotifierProvider(create: (_) => DataSheetProvider()),
        // ChangeNotifierProvider(create: (_) => DentistAttendanceProvider()),
          ChangeNotifierProvider(
      create: (_) => DentistAttendanceProvider(
        DentistAttendanceService(ApiConfig.attendance),

        
      ),
    ),
        
        
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
      title: 'Dental Admin Panel',
      theme: AppTheme.light,
      routes: {
        "/": (context) => const AdminLoginPage(),
        "/dashboard": (context) => const DashboardPage(),
      },
      initialRoute: "/",
    );
  }
}
