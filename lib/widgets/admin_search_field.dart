import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AdminSearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const AdminSearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
        suffixIcon: Icon(Icons.tune_rounded, color: AppColors.textMuted.withValues(alpha: 0.7)),
      ),
    );
  }
}
