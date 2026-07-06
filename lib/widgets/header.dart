import 'package:dental_admin_web/config/api_config.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class Header extends StatelessWidget {
  final String title;
  final String? subtitle;

  const Header({
    super.key,
    this.title = 'Dashboard',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
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
                  const SizedBox(height: 4),
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
          _EnvBadge(label: ApiConfig.environmentLabel),
          const SizedBox(width: 12),
          _IconButton(icon: Icons.notifications_none_rounded),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: const Icon(Icons.person_rounded, size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  'Admin',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EnvBadge extends StatelessWidget {
  final String label;

  const _EnvBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final isLocal = label == 'Local';
    final color = isLocal ? AppColors.warning : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;

  const _IconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: AppColors.textSecondary, size: 22),
      ),
    );
  }
}
