import 'package:dental_admin_web/models/enquiry.dart';
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
import 'package:dental_admin_web/providers/enquiry_provider.dart';
import 'package:dental_admin_web/services/payment_service.dart';
import 'package:dental_admin_web/theme/app_colors.dart';
import 'package:dental_admin_web/widgets/admin_card.dart';
import 'package:dental_admin_web/widgets/header.dart';
import 'package:dental_admin_web/widgets/sidebar.dart';
import 'package:dental_admin_web/widgets/stat_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const _enquiriesMenuIndex = 4;

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
  int enquiryCount = 0;
  int pendingEnquiryCount = 0;
  List<Enquiry> recentEnquiries = [];

  final _dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

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
      _loadEnquiries(),
    ]);
    if (mounted) setState(() {});
  }

  Future<void> _loadEnquiries() async {
    if (!mounted) return;
    try {
      final provider = Provider.of<EnquiryProvider>(context, listen: false);
      await provider.fetchEnquiries();
      enquiryCount = provider.enquiries.length;
      pendingEnquiryCount = provider.pendingCount;
      recentEnquiries = provider.enquiries.take(5).toList();
    } catch (_) {}
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
        const EnquiriesListPage(),
        const AllPaymentsPage(),
        const BranchesListPage(),
        const ServiceVideoPage(),
        const PackagesListPage(),
        const SettingsPage(),
      ];

  void _onMenuTap(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) {
      _refreshCounts();
    } else {
      Provider.of<EnquiryProvider>(context, listen: false).fetchEnquiries();
    }
  }

  void _openEnquiries() {
    setState(() => _selectedIndex = _enquiriesMenuIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EnquiryProvider>(
      builder: (context, enquiryProvider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Row(
            children: [
              SideBar(
                onMenuTap: _onMenuTap,
                selectedIndex: _selectedIndex,
                pendingEnquiryCount: enquiryProvider.pendingCount,
              ),
              Expanded(child: _pages[_selectedIndex]),
            ],
          ),
        );
      },
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
                        StatCard(
                          title: 'Enquiries',
                          value: '$enquiryCount',
                          icon: Icons.contact_support_rounded,
                          color: AppColors.info,
                          trend: pendingEnquiryCount > 0
                              ? '$pendingEnquiryCount pending'
                              : null,
                        ),
                      ];

                      if (isWide) {
                        return Row(
                          children: [
                            for (var i = 0; i < cards.length; i++) ...[
                              if (i > 0) const SizedBox(width: 18),
                              Expanded(
                                child: i == cards.length - 1
                                    ? InkWell(
                                        onTap: _openEnquiries,
                                        borderRadius: BorderRadius.circular(18),
                                        child: cards[i],
                                      )
                                    : cards[i],
                              ),
                            ],
                          ],
                        );
                      }

                      return Column(
                        children: [
                          for (var i = 0; i < cards.length; i++) ...[
                            if (i > 0) const SizedBox(height: 14),
                            i == cards.length - 1
                                ? InkWell(
                                    onTap: _openEnquiries,
                                    borderRadius: BorderRadius.circular(18),
                                    child: cards[i],
                                  )
                                : cards[i],
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
                  const SizedBox(height: 24),
                  _RecentEnquiriesSection(
                    enquiries: recentEnquiries,
                    dateFormat: _dateFormat,
                    onViewAll: _openEnquiries,
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

class _RecentEnquiriesSection extends StatelessWidget {
  final List<Enquiry> enquiries;
  final DateFormat dateFormat;
  final VoidCallback onViewAll;

  const _RecentEnquiriesSection({
    required this.enquiries,
    required this.dateFormat,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent enquiries',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Latest messages from patients',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: onViewAll,
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (enquiries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No enquiries yet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
            )
          else
            Column(
              children: enquiries.map((enquiry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    enquiry.subject,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                _statusChip(enquiry.isReplied),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              enquiry.patientName ?? 'Unknown patient',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            if (enquiry.patientPhone?.isNotEmpty == true) ...[
                              const SizedBox(height: 2),
                              Text(
                                enquiry.patientPhone!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                            const SizedBox(height: 6),
                            Text(
                              enquiry.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        dateFormat.format(enquiry.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _statusChip(bool isReplied) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isReplied ? AppColors.success : AppColors.warning)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isReplied ? 'Replied' : 'Pending',
        style: TextStyle(
          color: isReplied ? AppColors.success : AppColors.warning,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
