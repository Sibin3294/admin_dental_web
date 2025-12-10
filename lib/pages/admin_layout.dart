import 'package:dental_admin_web/screens/all_payments_page.dart';
import 'package:dental_admin_web/screens/appointments_list_page.dart';
import 'package:dental_admin_web/screens/dentists_list_page.dart';
import 'package:dental_admin_web/screens/patients_list_page.dart';
import 'package:dental_admin_web/screens/settings.dart';
import 'package:dental_admin_web/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("Dashboard Page"));
}

// class AppointmentsPage extends StatelessWidget {
//   const AppointmentsPage({super.key});
//   @override
//   Widget build(BuildContext context) =>
//       const Center(child: Text("Appointments Page"));
// }

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    AppointmentsPage(),
    DentistsListPage(),
    PatientsListPage(),
    AllPaymentsPage(),
    SettingsPage()
  ];

  void _onMenuTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBar(
            onMenuTap: _onMenuTap,
            selectedIndex: _selectedIndex,   // ✅ FIX
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
  
 
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminLayout(),
  ));
}
