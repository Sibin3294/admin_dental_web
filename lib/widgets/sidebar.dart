import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // const Center(
          //   child: Text(
          //     "Dr. Smile Admin",
          //     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          //   ),
          // ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.local_hospital, // professional medical icon
                  color: Colors.teal,
                  size: 28,
                ),
                SizedBox(width: 8),
                Text(
                  "Dr. Smile Admin",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          _menuItem(Icons.dashboard, "Dashboard", 0),
          _menuItem(Icons.calendar_month, "Appointments", 1),
          _menuItem(Icons.person, "Dentists", 2),
          _menuItem(Icons.people, "Patients", 3),
          _menuItem(Icons.payment, "Payments", 4),
          _menuItem(Icons.settings, "Settings", 5),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, int index) {
    bool isSelected = widget.selectedIndex == index;
    bool isHovering = _hoverIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoverIndex = index),
      onExit: (_) => setState(() => _hoverIndex = -1),
      child: InkWell(
        onTap: () => widget.onMenuTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue.shade50
                : isHovering
                    ? Colors.grey.shade200
                    : Colors.white,
            border: isSelected
                ? Border(
                    left: BorderSide(color: Colors.blue.shade700, width: 4),
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? Colors.blue.shade700 : Colors.black87,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.blue.shade700 : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
