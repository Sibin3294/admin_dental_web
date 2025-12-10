import 'package:dental_admin_web/models/all_payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/payment_provider.dart';

class AllPaymentsPage extends StatefulWidget {
  const AllPaymentsPage({super.key});

  @override
  State<AllPaymentsPage> createState() => _AllPaymentsPageState();
}

class _AllPaymentsPageState extends State<AllPaymentsPage> {
  String searchQuery = '';
  String selectedStatus = 'All';
  String selectedPaymentMode = 'All';
  String selectedDentist = 'All';

  @override
  void initState() {
    super.initState();
    Provider.of<PaymentProvider>(context, listen: false).getAllPayments();
  }

  List<AllPaymentModel> applyFilters(List<AllPaymentModel> payments) {
    List<AllPaymentModel> filtered = payments;

    // Filter by status
    if (selectedStatus != 'All') {
      filtered = filtered
          .where((p) =>
              p.paymentStatus.toLowerCase() == selectedStatus.toLowerCase())
          .toList();
    }

    // Filter by payment mode
    // if (selectedPaymentMode != 'All') {
    //   filtered = filtered
    //       .where((p) =>
    //           p.paymentMode != null &&
    //           p.paymentMode!.toLowerCase() ==
    //               selectedPaymentMode.toLowerCase())
    //       .toList();
    // }

    // Filter by dentist
    if (selectedDentist != 'All') {
      filtered = filtered
          .where((p) =>
              p.dentist != null &&
              p.dentist!.name.toLowerCase().contains(selectedDentist.toLowerCase()))
          .toList();
    }

    // Search by patient or dentist name
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              (p.patient != null &&
                  p.patient!.name.toLowerCase().contains(searchQuery.toLowerCase())) ||
              (p.dentist != null &&
                  p.dentist!.name.toLowerCase().contains(searchQuery.toLowerCase())))
          .toList();
    }

    // Sort by latest payment date
    filtered.sort((a, b) => b.paymentDate!.compareTo(a.paymentDate!));

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentProvider>(context);
    final filteredPayments = applyFilters(provider.allPayments);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Payments"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // ---------------- Search Field ----------------
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by patient or dentist name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // ---------------- Filters ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // Expanded(
                //   child: DropdownButtonFormField<String>(
                //     value: selectedStatus,
                //     items: ['All', 'Completed', 'Pending', 'Cancelled']
                //         .map((status) => DropdownMenuItem(
                //               value: status,
                //               child: Text(status),
                //             ))
                //         .toList(),
                //     onChanged: (value) {
                //       setState(() {
                //         selectedStatus = value!;
                //       });
                //     },
                //     decoration: const InputDecoration(
                //       labelText: 'Payment Status',
                //       border: OutlineInputBorder(),
                //       contentPadding: EdgeInsets.symmetric(horizontal: 12),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 8),
                // Expanded(
                //   child: DropdownButtonFormField<String>(
                //     value: selectedPaymentMode,
                //     items: ['All', 'Cash', 'Card', 'Online']
                //         .map((mode) => DropdownMenuItem(
                //               value: mode,
                //               child: Text(mode),
                //             ))
                //         .toList(),
                //     onChanged: (value) {
                //       setState(() {
                //         selectedPaymentMode = value!;
                //       });
                //     },
                //     decoration: const InputDecoration(
                //       labelText: 'Payment Mode',
                //       border: OutlineInputBorder(),
                //       contentPadding: EdgeInsets.symmetric(horizontal: 12),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ---------------- Payments List ----------------
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredPayments.isEmpty
                    ? const Center(child: Text("No Payments Found"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredPayments.length,
                        itemBuilder: (context, index) {
                          final p = filteredPayments[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Amount and Status
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "₹ ${(double.tryParse(p.amount) ?? 0).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: p.paymentStatus
                                                      .toLowerCase() ==
                                                  "completed"
                                              ? Colors.green.withOpacity(0.2)
                                              : Colors.orange.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          p.paymentStatus.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: p.paymentStatus
                                                        .toLowerCase() ==
                                                    "completed"
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Patient Info
                                  if (p.patient != null)
                                    Text(
                                      "Patient: ${p.patient!.name} (${p.patient!.email})",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  const SizedBox(height: 4),

                                  // Dentist Info
                                  if (p.dentist != null)
                                    Text(
                                      "Dentist: ${p.dentist!.name}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  const SizedBox(height: 4),

                                  // Payment Mode
                                  // if (p.paymentMode != null)
                                  //   Text(
                                  //     "Mode: ${p.paymentMode}",
                                  //     style: const TextStyle(
                                  //         fontSize: 14, color: Colors.black54),
                                  //   ),
                                  const SizedBox(height: 4),

                                  // Payment Date
                                  Text(
                                    "Date: ${p.paymentDate != null ? p.paymentDate!.toLocal().toString().split(' ')[0] : "-"}",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  ),
                                  const SizedBox(height: 4),

                                  // Notes
                                  if (p.notes != null && p.notes!.isNotEmpty)
                                    Text(
                                      "Notes: ${p.notes}",
                                      style:
                                          const TextStyle(fontSize: 14),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
