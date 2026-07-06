import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SideBar extends StatefulWidget {
  final Function(int) onMenuTap;
  final int selectedIndex;

  const SideBar({
    super.key,
    required this.onMenuTap,
    required this.selectedIndex,
  });

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int _hoverIndex = -1;

  static const _items = [
    _NavItem(Icons.space_dashboard_rounded, 'Dashboard', 0),
    _NavItem(Icons.calendar_month_rounded, 'Appointments', 1),
    _NavItem(Icons.medical_services_rounded, 'Dentists', 2),
    _NavItem(Icons.people_alt_rounded, 'Patients', 3),
    _NavItem(Icons.contact_support_rounded, 'Enquiries', 4),
    _NavItem(Icons.payments_rounded, 'Payments', 5),
    _NavItem(Icons.store_mall_directory_rounded, 'Branches', 6),
    _NavItem(Icons.play_circle_outline_rounded, 'Videos', 7),
    _NavItem(Icons.inventory_2_rounded, 'Packages', 8),
    _NavItem(Icons.settings_rounded, 'Settings', 9),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppColors.sidebar,
        border: Border(right: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.local_hospital_rounded, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. Smile',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(
                        'Admin Console',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _items.map((item) => _menuItem(item)).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.sidebarHover,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.health_and_safety_rounded, color: AppColors.primaryLight, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Dental care management',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
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

  Widget _menuItem(_NavItem item) {
    final isSelected = widget.selectedIndex == item.index;
    final isHovering = _hoverIndex == item.index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoverIndex = item.index),
        onExit: (_) => setState(() => _hoverIndex = -1),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => widget.onMenuTap(item.index),
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.sidebarActive
                    : isHovering
                        ? AppColors.sidebarHover
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: AppColors.primary.withValues(alpha: 0.35))
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 20,
                    color: isSelected ? AppColors.primaryLight : AppColors.textMuted,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isSelected ? Colors.white : AppColors.textMuted,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final int index;

  const _NavItem(this.icon, this.label, this.index);
}
