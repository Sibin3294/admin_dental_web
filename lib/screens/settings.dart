import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
         
        title: const Text("Settings"),
        // backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("General"),
            _settingsCard(
              children: [
                _settingTile(
                  icon: Icons.language,
                  title: "Language",
                  subtitle: "Change application language",
                  onTap: () {},
                ),
                _settingTile(
                  icon: Icons.access_time,
                  title: "Timezone",
                  subtitle: "Set default timezone",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            _sectionTitle("Profile"),
            _settingsCard(
              children: [
                _settingTile(
                  icon: Icons.person,
                  title: "Edit Profile",
                  subtitle: "Update your personal information",
                  onTap: () {},
                ),
                _settingTile(
                  icon: Icons.lock_outline,
                  title: "Change Password",
                  subtitle: "Update your login password",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            _sectionTitle("Notifications"),
            _settingsCard(
              children: [
                _switchTile(
                  icon: Icons.notifications_active,
                  title: "Push Notifications",
                  subtitle: "Receive alerts for appointments",
                  value: true,
                  onChanged: (v) {},
                ),
                _switchTile(
                  icon: Icons.email,
                  title: "Email Alerts",
                  subtitle: "Receive updates via email",
                  value: false,
                  onChanged: (v) {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            _sectionTitle("Appearance"),
            _settingsCard(
              children: [
                _switchTile(
                  icon: Icons.dark_mode,
                  title: "Dark Mode",
                  subtitle: "Enable dark theme",
                  value: false,
                  onChanged: (v) {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            _sectionTitle("Security"),
            _settingsCard(
              children: [
                _settingTile(
                  icon: Icons.shield,
                  title: "Two-Factor Authentication",
                  subtitle: "Add extra security to your account",
                  onTap: () {},
                ),
                _settingTile(
                  icon: Icons.logout,
                  title: "Logout",
                  subtitle: "Sign out of your account",
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _settingsCard({required List<Widget> children}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: children),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 28, color: Colors.teal),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
      secondary: Icon(icon, size: 28, color: Colors.teal),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}
