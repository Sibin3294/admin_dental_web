import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/payment_provider.dart';
import '../models/patient_paymentHistory.dart';

class PaymentHistoryPage extends StatefulWidget {
  final String patientId;

  const PaymentHistoryPage({super.key, required this.patientId});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  @override
  void initState() {
    super.initState();
    // Fetch payments for the patient
    Provider.of<PaymentProvider>(context, listen: false)
        .getPaymentsByPatient(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment History"),
        backgroundColor: Colors.teal,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.patientPayments.isEmpty
              ? const Center(child: Text("No Payments Found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.patientPayments.length,
                  itemBuilder: (context, index) {
                    final PatientPaymentHistory p =
                        provider.patientPayments[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Amount and Payment Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "₹ ${(double.tryParse(p.amount) ?? 0).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: p.paymentStatus.toLowerCase() ==
                                            "completed"
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    p.paymentStatus.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: p.paymentStatus.toLowerCase() ==
                                              "completed"
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Dentist
                            if (p.dentist != null)
                              Text(
                                "Dentist: ${p.dentist.name} (${p.dentist.specialization})",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              ),

                            const SizedBox(height: 4),

                            // Patient
                            if (p.patient != null)
                              Text(
                                "Patient: ${p.patient.name} (${p.patient.email})",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),

                            const SizedBox(height: 4),

                            // Payment Date
                            if (p.paymentDate != null)
                              Text(
                                "Date: ${p.paymentDate.toLocal().toString().split(' ')[0]}",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),

                            const SizedBox(height: 8),

                            // Notes
                            if (p.notes.isNotEmpty)
                              Text(
                                "Notes: ${p.notes}",
                                style: const TextStyle(fontSize: 14),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
