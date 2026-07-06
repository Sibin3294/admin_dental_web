import 'package:dental_admin_web/models/package.dart';
import 'package:dental_admin_web/providers/package_provider.dart';
import 'package:dental_admin_web/theme/app_colors.dart';
import 'package:dental_admin_web/widgets/admin_card.dart';
import 'package:dental_admin_web/widgets/admin_page_layout.dart';
import 'package:dental_admin_web/widgets/admin_search_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PackagesListPage extends StatefulWidget {
  const PackagesListPage({super.key});

  @override
  State<PackagesListPage> createState() => _PackagesListPageState();
}

class _PackagesListPageState extends State<PackagesListPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PackageProvider>(context, listen: false).fetchPackages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PackageProvider>(
      builder: (context, provider, _) {
        final filtered = provider.packages.where((pkg) {
          final q = _searchQuery.toLowerCase();
          if (q.isEmpty) return true;
          return pkg.name.toLowerCase().contains(q) ||
              pkg.category.toLowerCase().contains(q) ||
              pkg.description.toLowerCase().contains(q);
        }).toList();

        return AdminPageLayout(
          title: 'Clinic Packages',
          subtitle: 'Create and manage treatment packages for patients',
          actions: [
            ElevatedButton.icon(
              onPressed: () => _showPackageDialog(context, provider),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Package'),
            ),
          ],
          searchField: AdminSearchField(
            hintText: 'Search packages...',
            onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
          ),
          child: _buildBody(context, provider, filtered),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    PackageProvider provider,
    List<ClinicPackage> packages,
  ) {
    if (provider.isLoading && provider.packages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.packages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(provider.error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: provider.fetchPackages,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (packages.isEmpty) {
      return const Center(child: Text('No packages found'));
    }

    return AdminTableCard(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.surfaceMuted),
          columns: const [
            DataColumn(label: Text('Package')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Duration')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: packages.map((pkg) {
            return DataRow(
              cells: [
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pkg.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      if (pkg.description.isNotEmpty)
                        Text(
                          pkg.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                DataCell(Text(pkg.category)),
                DataCell(Text('₹${pkg.price.toStringAsFixed(0)}')),
                DataCell(Text(pkg.duration.isEmpty ? '—' : pkg.duration)),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: pkg.isActive
                          ? AppColors.success.withValues(alpha: 0.12)
                          : AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      pkg.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: pkg.isActive ? AppColors.success : AppColors.error,
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
                        icon: const Icon(Icons.edit_rounded,
                            color: AppColors.primary),
                        onPressed: () =>
                            _showPackageDialog(context, provider, pkg: pkg),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_rounded,
                            color: AppColors.error),
                        onPressed: () => _confirmDelete(context, provider, pkg),
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
    PackageProvider provider,
    ClinicPackage pkg,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete package?'),
        content: Text('Remove "${pkg.name}" permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await provider.deletePackage(pkg.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Package deleted')),
        );
      }
    }
  }
}

void _showPackageDialog(
  BuildContext context,
  PackageProvider provider, {
  ClinicPackage? pkg,
}) {
  final isEdit = pkg != null;
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController(text: pkg?.name ?? '');
  final descCtrl = TextEditingController(text: pkg?.description ?? '');
  final priceCtrl =
      TextEditingController(text: pkg != null ? pkg.price.toString() : '');
  final originalPriceCtrl = TextEditingController(
    text: pkg?.originalPrice?.toString() ?? '',
  );
  final durationCtrl = TextEditingController(text: pkg?.duration ?? '');
  final imageCtrl = TextEditingController(text: pkg?.imageUrl ?? '');
  final featuresCtrl = TextEditingController(
    text: pkg?.features.join('\n') ?? '',
  );
  final sortCtrl =
      TextEditingController(text: pkg?.sortOrder.toString() ?? '0');

  String category = pkg?.category ?? 'preventive';
  bool isActive = pkg?.isActive ?? true;
  bool isFeatured = pkg?.isFeatured ?? false;
  bool notifyUsers = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Text(isEdit ? 'Edit Package' : 'Add Package'),
      content: SizedBox(
        width: 520,
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
                        labelText: 'Package Name *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: priceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Price (₹) *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Required';
                              }
                              if (double.tryParse(v) == null) {
                                return 'Invalid price';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: originalPriceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Original Price (₹)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: durationCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Duration (e.g. 6 months)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: category,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 'preventive', child: Text('Preventive')),
                              DropdownMenuItem(
                                  value: 'cosmetic', child: Text('Cosmetic')),
                              DropdownMenuItem(
                                  value: 'orthodontic',
                                  child: Text('Orthodontic')),
                              DropdownMenuItem(
                                  value: 'family', child: Text('Family')),
                              DropdownMenuItem(
                                  value: 'premium', child: Text('Premium')),
                            ],
                            onChanged: (v) => setState(() => category = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: imageCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: featuresCtrl,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Features (one per line)',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: sortCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Sort Order',
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
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Featured'),
                      value: isFeatured,
                      onChanged: (v) => setState(() => isFeatured = v),
                    ),
                    if (!isEdit)
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Notify patients'),
                        subtitle: const Text(
                          'Send a push notification when this package is added',
                        ),
                        value: notifyUsers,
                        onChanged: (v) =>
                            setState(() => notifyUsers = v ?? false),
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

            final features = featuresCtrl.text
                .split('\n')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();

            final payload = {
              'name': nameCtrl.text.trim(),
              'description': descCtrl.text.trim(),
              'price': double.parse(priceCtrl.text.trim()),
              'originalPrice': originalPriceCtrl.text.trim().isEmpty
                  ? null
                  : double.tryParse(originalPriceCtrl.text.trim()),
              'duration': durationCtrl.text.trim(),
              'features': features,
              'imageUrl': imageCtrl.text.trim(),
              'category': category,
              'isActive': isActive,
              'isFeatured': isFeatured,
              'sortOrder': int.tryParse(sortCtrl.text.trim()) ?? 0,
              if (!isEdit) 'notifyUsers': notifyUsers,
            };

            try {
              if (isEdit) {
                await provider.updatePackage(pkg!.id, payload);
              } else {
                await provider.addPackage(payload);
              }
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEdit ? 'Package updated' : 'Package added',
                    ),
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
