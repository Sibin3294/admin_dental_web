import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AdminCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const AdminCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class AdminTableCard extends StatelessWidget {
  final Widget child;

  const AdminTableCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }
}
