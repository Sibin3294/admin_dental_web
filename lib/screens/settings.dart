import 'package:dental_admin_web/config/api_config.dart';
import 'package:dental_admin_web/services/auth_service.dart';
import 'package:dental_admin_web/theme/app_colors.dart';
import 'package:dental_admin_web/widgets/admin_card.dart';
import 'package:dental_admin_web/widgets/admin_page_layout.dart';
import 'package:dental_admin_web/widgets/admin_users_section.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminPageLayout(
      title: 'Settings',
      subtitle: 'Configure admin preferences and account options',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(context, 'Environment'),
            AdminCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.cloud_outlined, color: AppColors.primary),
                    title: const Text('API environment'),
                    subtitle: Text('Currently using ${ApiConfig.environmentLabel} backend'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        ApiConfig.environmentLabel,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle(context, 'Admin Users'),
            const AdminUsersSection(),
            const SizedBox(height: 20),
            _sectionTitle(context, 'General'),
            _settingsCard(
              children: [
                _settingTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: 'Change application language',
                  onTap: () {},
                ),
                _settingTile(
                  icon: Icons.access_time_rounded,
                  title: 'Timezone',
                  subtitle: 'Set default timezone',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            _sectionTitle(context, 'Profile'),
            _settingsCard(
              children: [
                _settingTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {},
                ),
                _settingTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  subtitle: 'Update your login password',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            _sectionTitle(context, 'Notifications'),
            _settingsCard(
              children: [
                _switchTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Receive alerts for appointments',
                  value: true,
                  onChanged: (v) {},
                ),
                _switchTile(
                  icon: Icons.mail_outline_rounded,
                  title: 'Email Alerts',
                  subtitle: 'Receive updates via email',
                  value: false,
                  onChanged: (v) {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            _sectionTitle(context, 'Security'),
            _settingsCard(
              children: [
                _settingTile(
                  icon: Icons.shield_outlined,
                  title: 'Two-Factor Authentication',
                  subtitle: 'Add extra security to your account',
                  onTap: () {},
                ),
                _settingTile(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  onTap: () async {
                    await AuthService.logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
      ),
    );
  }

  Widget _settingsCard({required List<Widget> children}) {
    return AdminCard(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(children: children),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      onTap: onTap,
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      value: value,
      activeThumbColor: AppColors.primary,
      onChanged: onChanged,
    );
  }
}
