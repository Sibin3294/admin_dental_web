import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AdminPageLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? searchField;
  final Widget child;

  const AdminPageLayout({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.searchField,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            subtitle!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (actions.isNotEmpty)
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: actions,
                    ),
                ],
              ),
              if (searchField != null) ...[
                const SizedBox(height: 20),
                searchField!,
              ],
              const SizedBox(height: 20),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
