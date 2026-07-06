import 'package:dental_admin_web/screens/enquiries_list_page.dart';
import 'package:dental_admin_web/screens/branches_list_page.dart';
import 'package:dental_admin_web/screens/all_payments_page.dart';
import 'package:dental_admin_web/screens/appointments_list_page.dart';
import 'package:dental_admin_web/screens/dentists_list_page.dart';
import 'package:dental_admin_web/screens/packages_list_page.dart';
import 'package:dental_admin_web/screens/patients_list_page.dart';
import 'package:dental_admin_web/screens/service_video_page.dart';
import 'package:dental_admin_web/screens/settings.dart';
import 'package:dental_admin_web/services/appointment_service.dart';
import 'package:dental_admin_web/services/dentist_service.dart';
import 'package:dental_admin_web/services/patient_service.dart';
import 'package:dental_admin_web/services/payment_service.dart';
import 'package:dental_admin_web/theme/app_colors.dart';
import 'package:dental_admin_web/widgets/admin_card.dart';
import 'package:dental_admin_web/widgets/header.dart';
import 'package:dental_admin_web/widgets/sidebar.dart';
import 'package:dental_admin_web/widgets/stat_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
  int paymentsCount = 0;

  @override
  void initState() {
    super.initState();
    _refreshCounts();
  }

  Future<void> _refreshCounts() async {
    await Future.wait([
      _loadCount(DentistService.getDentistCount(), (v) => dentistCount = v),
      _loadCount(PatientService.getPatientCount(), (v) => patientCount = v),
      _loadCount(AppointmentService.getAppointmentCount(), (v) => appointmentCount = v),
      _loadCount(PaymentService.getPaymentCount(), (v) => paymentsCount = v),
    ]);
    if (mounted) setState(() {});
  }

  Future<void> _loadCount(Future<int> future, void Function(int) setter) async {
    try {
      setter(await future);
    } catch (_) {}
  }

  List<Widget> get _pages => [
        _dashboardContent(),
        const AppointmentsPage(),
        const DentistsListPage(),
        const PatientsListPage(),
        const AllPaymentsPage(),
        const BranchesListPage(),
        const ServiceVideoPage(),
        const PackagesListPage(),
        const EnquiriesListPage(),
        const SettingsPage(),
      ];

  void _onMenuTap(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) _refreshCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SideBar(onMenuTap: _onMenuTap, selectedIndex: _selectedIndex),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _dashboardContent() {
    final maxBar = [
      appointmentCount.toDouble(),
      patientCount.toDouble(),
      dentistCount.toDouble(),
    ].fold<double>(0, (a, b) => a > b ? a : b);

    return ColoredBox(
      color: AppColors.background,
      child: Column(
        children: [
          const Header(
            title: 'Dashboard',
            subtitle: 'Overview of clinic activity and performance',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 980;
                      final cards = [
                        StatCard(
                          title: 'Appointments',
                          value: '$appointmentCount',
                          icon: Icons.calendar_month_rounded,
                          color: AppColors.appointments,
                        ),
                        StatCard(
                          title: 'Patients',
                          value: '$patientCount',
                          icon: Icons.people_alt_rounded,
                          color: AppColors.patients,
                        ),
                        StatCard(
                          title: 'Dentists',
                          value: '$dentistCount',
                          icon: Icons.medical_services_rounded,
                          color: AppColors.dentists,
                        ),
                        StatCard(
                          title: 'Payments',
                          value: '$paymentsCount',
                          icon: Icons.payments_rounded,
                          color: AppColors.payments,
                        ),
                      ];

                      if (isWide) {
                        return Row(
                          children: [
                            for (var i = 0; i < cards.length; i++) ...[
                              if (i > 0) const SizedBox(width: 18),
                              Expanded(child: cards[i]),
                            ],
                          ],
                        );
                      }

                      return Column(
                        children: [
                          for (var i = 0; i < cards.length; i++) ...[
                            if (i > 0) const SizedBox(height: 14),
                            cards[i],
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 980;
                      final charts = [
                        _OverviewChart(
                          appointmentCount: appointmentCount,
                          patientCount: patientCount,
                          dentistCount: dentistCount,
                          maxY: maxBar * 1.2 + 1,
                        ),
                        _PaymentsChart(paymentsCount: paymentsCount),
                      ];

                      if (isWide) {
                        return SizedBox(
                          height: 340,
                          child: Row(
                            children: [
                              Expanded(child: charts[0]),
                              const SizedBox(width: 18),
                              Expanded(child: charts[1]),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: [
                          SizedBox(height: 320, child: charts[0]),
                          const SizedBox(height: 18),
                          SizedBox(height: 280, child: charts[1]),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewChart extends StatelessWidget {
  final int appointmentCount;
  final int patientCount;
  final int dentistCount;
  final double maxY;

  const _OverviewChart({
    required this.appointmentCount,
    required this.patientCount,
    required this.dentistCount,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clinic overview',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Appointments, patients, and dentists at a glance',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: maxY,
                alignment: BarChartAlignment.spaceAround,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.border,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      getTitlesWidget: (value, _) {
                        switch (value.toInt()) {
                          case 0:
                            return _chartLabel('Appts');
                          case 1:
                            return _chartLabel('Patients');
                          case 2:
                            return _chartLabel('Dentists');
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                barGroups: [
                  _bar(0, appointmentCount.toDouble(), AppColors.appointments),
                  _bar(1, patientCount.toDouble(), AppColors.patients),
                  _bar(2, dentistCount.toDouble(), AppColors.dentists),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 28,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        ),
      ],
    );
  }
}

class _PaymentsChart extends StatelessWidget {
  final int paymentsCount;

  const _PaymentsChart({required this.paymentsCount});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payments summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Total recorded payment entries',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 52,
                sections: [
                  PieChartSectionData(
                    value: paymentsCount.toDouble().clamp(1, double.infinity),
                    color: AppColors.payments,
                    title: '$paymentsCount',
                    radius: 58,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _chartLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
    ),
  );
}
