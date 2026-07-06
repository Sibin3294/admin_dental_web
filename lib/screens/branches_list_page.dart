import 'package:dental_admin_web/models/branch.dart';
import 'package:dental_admin_web/providers/branch_provider.dart';
import 'package:dental_admin_web/theme/app_colors.dart';
import 'package:dental_admin_web/widgets/admin_card.dart';
import 'package:dental_admin_web/widgets/admin_page_layout.dart';
import 'package:dental_admin_web/widgets/admin_search_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BranchesListPage extends StatefulWidget {
  const BranchesListPage({super.key});

  @override
  State<BranchesListPage> createState() => _BranchesListPageState();
}

class _BranchesListPageState extends State<BranchesListPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BranchProvider>(context, listen: false).fetchBranches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BranchProvider>(
      builder: (context, provider, _) {
        final filtered = provider.branches.where((branch) {
          final q = _searchQuery.toLowerCase();
          if (q.isEmpty) return true;
          return branch.name.toLowerCase().contains(q) ||
              branch.address.toLowerCase().contains(q) ||
              (branch.city ?? '').toLowerCase().contains(q);
        }).toList();

        return AdminPageLayout(
          title: 'Clinic Branches',
          subtitle: 'Manage Dr. Smile locations used for appointment booking',
          actions: [
            ElevatedButton.icon(
              onPressed: () => _showBranchDialog(context, provider),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Branch'),
            ),
          ],
          searchField: AdminSearchField(
            hintText: 'Search branches...',
            onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
          ),
          child: _buildBody(context, provider, filtered),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    BranchProvider provider,
    List<Branch> branches,
  ) {
    if (provider.isLoading && provider.branches.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.branches.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(provider.error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: provider.fetchBranches,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (branches.isEmpty) {
      return const Center(child: Text('No branches found. Add your first branch.'));
    }

    return AdminTableCard(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.surfaceMuted),
          columns: const [
            DataColumn(label: Text('Branch')),
            DataColumn(label: Text('Address')),
            DataColumn(label: Text('City')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: branches.map((branch) {
            return DataRow(
              cells: [
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        branch.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      if (branch.code != null && branch.code!.isNotEmpty)
                        Text(
                          branch.code!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                DataCell(SizedBox(width: 220, child: Text(branch.address))),
                DataCell(Text(branch.city?.isNotEmpty == true ? branch.city! : '—')),
                DataCell(Text(branch.phone?.isNotEmpty == true ? branch.phone! : '—')),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: branch.isActive
                          ? AppColors.success.withValues(alpha: 0.12)
                          : AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      branch.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: branch.isActive ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
                        onPressed: () =>
                            _showBranchDialog(context, provider, branch: branch),
                      ),
                      if (branch.isActive)
                        IconButton(
                          icon: const Icon(Icons.delete_rounded, color: AppColors.error),
                          onPressed: () => _confirmDelete(context, provider, branch),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    BranchProvider provider,
    Branch branch,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Deactivate branch?'),
        content: Text(
          'Deactivate "${branch.name}"? It will no longer appear for new bookings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await provider.deleteBranch(branch.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Branch deactivated')),
        );
      }
    }
  }
}

void _showBranchDialog(
  BuildContext context,
  BranchProvider provider, {
  Branch? branch,
}) {
  final isEdit = branch != null;
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController(text: branch?.name ?? '');
  final addressCtrl = TextEditingController(text: branch?.address ?? '');
  final cityCtrl = TextEditingController(text: branch?.city ?? '');
  final phoneCtrl = TextEditingController(text: branch?.phone ?? '');
  final codeCtrl = TextEditingController(text: branch?.code ?? '');
  bool isActive = branch?.isActive ?? true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Text(isEdit ? 'Edit Branch' : 'Add Branch'),
      content: SizedBox(
        width: 480,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Branch Name *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: addressCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Address *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: cityCtrl,
                            decoration: const InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: phoneCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: codeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Code (optional)',
                        hintText: 'e.g. eloor-road',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Active'),
                      value: isActive,
                      onChanged: (v) => setState(() => isActive = v),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.save_rounded),
          label: Text(isEdit ? 'Update' : 'Save'),
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;

            final payload = {
              'name': nameCtrl.text.trim(),
              'address': addressCtrl.text.trim(),
              'city': cityCtrl.text.trim(),
              'phone': phoneCtrl.text.trim(),
              if (codeCtrl.text.trim().isNotEmpty) 'code': codeCtrl.text.trim(),
              'isActive': isActive,
            };

            try {
              if (isEdit) {
                await provider.updateBranch(branch!.id, payload);
              } else {
                await provider.addBranch(payload);
              }
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEdit ? 'Branch updated' : 'Branch added'),
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            }
          },
        ),
      ],
    ),
  );
}
