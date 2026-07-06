import 'package:dental_admin_web/models/enquiry.dart';
import 'package:dental_admin_web/providers/enquiry_provider.dart';
import 'package:dental_admin_web/theme/app_colors.dart';
import 'package:dental_admin_web/widgets/admin_card.dart';
import 'package:dental_admin_web/widgets/admin_page_layout.dart';
import 'package:dental_admin_web/widgets/admin_search_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EnquiriesListPage extends StatefulWidget {
  const EnquiriesListPage({super.key});

  @override
  State<EnquiriesListPage> createState() => _EnquiriesListPageState();
}

class _EnquiriesListPageState extends State<EnquiriesListPage> {
  String _searchQuery = '';
  final _dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EnquiryProvider>(context, listen: false).fetchEnquiries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EnquiryProvider>(
      builder: (context, provider, _) {
        final filtered = provider.enquiries.where((enquiry) {
          final q = _searchQuery.toLowerCase();
          if (q.isEmpty) return true;
          return (enquiry.patientName ?? '').toLowerCase().contains(q) ||
              enquiry.subject.toLowerCase().contains(q) ||
              enquiry.message.toLowerCase().contains(q) ||
              enquiry.status.toLowerCase().contains(q);
        }).toList();

        return AdminPageLayout(
          title: 'Patient Enquiries',
          subtitle: 'View enquiries and reply to patients',
          actions: [
            OutlinedButton.icon(
              onPressed: provider.fetchEnquiries,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh'),
            ),
          ],
          searchField: AdminSearchField(
            hintText: 'Search by patient, subject, or status...',
            onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
          ),
          child: _buildBody(context, provider, filtered),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    EnquiryProvider provider,
    List<Enquiry> enquiries,
  ) {
    if (provider.isLoading && provider.enquiries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.enquiries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(provider.error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: provider.fetchEnquiries,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (enquiries.isEmpty) {
      return const Center(child: Text('No enquiries found.'));
    }

    return AdminTableCard(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.surfaceMuted),
          columns: const [
            DataColumn(label: Text('Patient')),
            DataColumn(label: Text('Subject')),
            DataColumn(label: Text('Message')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Submitted')),
            DataColumn(label: Text('Actions')),
          ],
          rows: enquiries.map((enquiry) {
            return DataRow(
              cells: [
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        enquiry.patientName ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      if (enquiry.patientEmail != null)
                        Text(
                          enquiry.patientEmail!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                DataCell(Text(enquiry.subject)),
                DataCell(
                  SizedBox(
                    width: 220,
                    child: Text(
                      enquiry.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(_statusChip(enquiry.status)),
                DataCell(Text(_dateFormat.format(enquiry.createdAt))),
                DataCell(
                  TextButton.icon(
                    onPressed: () => _showReplyDialog(context, provider, enquiry),
                    icon: Icon(
                      enquiry.isReplied
                          ? Icons.visibility_rounded
                          : Icons.reply_rounded,
                    ),
                    label: Text(enquiry.isReplied ? 'View' : 'Reply'),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final isReplied = status == 'replied';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isReplied ? AppColors.success : AppColors.warning)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isReplied ? 'Replied' : 'Pending',
        style: TextStyle(
          color: isReplied ? AppColors.success : AppColors.warning,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Future<void> _showReplyDialog(
    BuildContext context,
    EnquiryProvider provider,
    Enquiry enquiry,
  ) async {
    final replyCtrl = TextEditingController(text: enquiry.adminReply ?? '');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(enquiry.isReplied ? 'Enquiry details' : 'Reply to enquiry'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _detailRow('Patient', enquiry.patientName ?? 'Unknown'),
                  _detailRow('Email', enquiry.patientEmail ?? '-'),
                  _detailRow('Subject', enquiry.subject),
                  _detailRow('Message', enquiry.message),
                  const SizedBox(height: 12),
                  TextField(
                    controller: replyCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Your reply',
                      hintText: 'Type your response to the patient...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (enquiry.isReplied && enquiry.repliedAt != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Last replied: ${_dateFormat.format(enquiry.repliedAt!)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () async {
                if (replyCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a reply')),
                  );
                  return;
                }

                final success = await provider.replyToEnquiry(
                  enquiry.id,
                  replyCtrl.text.trim(),
                );

                if (!context.mounted) return;

                if (success) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Reply sent. Patient will receive a push notification.',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(provider.error ?? 'Failed to send reply'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.send_rounded),
              label: const Text('Send Reply'),
            ),
          ],
        );
      },
    );

    replyCtrl.dispose();
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
