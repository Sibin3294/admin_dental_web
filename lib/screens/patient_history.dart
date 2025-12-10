import 'package:dental_admin_web/models/patient_history.dart';
import 'package:dental_admin_web/models/payment.dart';
import 'package:dental_admin_web/providers/payment_provider.dart';
import 'package:dental_admin_web/screens/patient_payment_history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/patient_history_provider.dart';
import 'package:intl/intl.dart';

class PatientHistoryPage extends StatelessWidget {
  final String patientId;

  const PatientHistoryPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<PatientHistoryProvider>(context, listen: false);

    // Load patient history on page open
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   provider.loadHistory(patientId);
    // });
    provider.loadHistory(patientId);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Patient History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<PatientHistoryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.history, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No history found",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Get patient info from the first history item
          final patient = provider.history.first.patient;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar + Name + Email
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: patient.photoUrl != null &&
                                    patient.photoUrl!.isNotEmpty
                                ? NetworkImage(patient.photoUrl!)
                                : null,
                            child: (patient.photoUrl == null ||
                                    patient.photoUrl!.isEmpty)
                                ? const Icon(Icons.person,
                                    size: 30, color: Colors.teal)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patient.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                patient.email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Payment History Button
                      // ElevatedButton.icon(
                      //   onPressed: () {
                      //     // TODO: Navigate to Payment History page
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.teal,
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 12, vertical: 8),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      //   icon: const Icon(Icons.payment,
                      //       size: 18, color: Colors.white),
                      //   label: const Text(
                      //     "Payment History",
                      //     style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 13,
                      //         fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PaymentHistoryPage(patientId: patient.id),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.payment,
                            size: 18, color: Colors.white),
                        label: const Text(
                          "Payment History",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Visit history list
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider.history.length,
                    itemBuilder: (context, index) {
                      final PatientHistory item = provider.history[index];

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // DATE + PAYMENT BUTTON
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      DateFormat('dd MMM yyyy')
                                          .format(item.startTime),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),

                                  // Conditional Payment Button
                                  item.paymentStatus.toLowerCase() ==
                                          "completed"
                                      ? ElevatedButton.icon(
                                          onPressed: null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 10),
                                          ),
                                          icon: const Icon(Icons.check_circle,
                                              color: Color.fromARGB(
                                                  255, 17, 92, 14)),
                                          label: Text(
                                            "Paid", // <- show paid amount

                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 17, 92, 14),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : ElevatedButton.icon(
                                          onPressed: () {
                                            _openVisitPaymentDialog(
                                                context,
                                                patientId,
                                                item.id,
                                                item.dentist.id,
                                                visit: item);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 10),
                                          ),
                                          icon: const Icon(Icons.add_card,
                                              color: Colors.white),
                                          label: const Text(
                                            "Add Payment",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // TIME RANGE
                              Text(
                                "${DateFormat('hh:mm a').format(item.startTime)}"
                                " - "
                                "${DateFormat('hh:mm a').format(item.endTime)}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // REASON
                              Text(
                                item.reason,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // DENTIST INFO
                              Text(
                                "Dentist: ${item.dentist.name} (${item.dentist.specialization})",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              ),

                              const SizedBox(height: 8),

                              // STATUS
                              Text(
                                "Status: ${item.status}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      item.status.toLowerCase() == "scheduled"
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ──────────────────────────────────────────────
/// PAYMENT DIALOG
/// ──────────────────────────────────────────────
void _openVisitPaymentDialog(
  BuildContext context,
  String patientId,
  String appointmentId,
  String dentistId, {
  PatientHistory? visit,
}) {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  String paymentType = "Consultation";
  String paymentMode = "Cash";

  DateTime selectedDate = visit?.startTime ?? DateTime.now();
  final dateController = TextEditingController(
    text: DateFormat('dd MMM yyyy').format(selectedDate),
  );

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add Payment"),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Payment Type
                  DropdownButtonFormField<String>(
                    value: paymentType,
                    items: const [
                      DropdownMenuItem(
                          value: "Consultation", child: Text("Consultation")),
                      DropdownMenuItem(
                          value: "Treatment", child: Text("Treatment")),
                      DropdownMenuItem(
                          value: "Follow-up", child: Text("Follow-up")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (val) => setState(() => paymentType = val!),
                    decoration: const InputDecoration(
                      labelText: "Payment Type",
                      prefixIcon: Icon(Icons.category),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Payment Mode
                  DropdownButtonFormField<String>(
                    value: paymentMode,
                    items: const [
                      DropdownMenuItem(value: "Cash", child: Text("Cash")),
                      DropdownMenuItem(value: "Card", child: Text("Card")),
                      DropdownMenuItem(value: "UPI", child: Text("UPI")),
                      DropdownMenuItem(value: "Online", child: Text("Online")),
                    ],
                    onChanged: (val) => setState(() => paymentMode = val!),
                    decoration: const InputDecoration(
                      labelText: "Payment Mode",
                      prefixIcon: Icon(Icons.payment),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Amount
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Amount",
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Payment Date
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Payment Date",
                      prefixIcon: const Icon(Icons.calendar_today),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.edit_calendar),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                              dateController.text =
                                  DateFormat('dd MMM yyyy').format(picked);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Notes
                  TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Notes",
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () async {
                  double amount =
                      double.tryParse(amountController.text.trim()) ?? 0;
                  if (amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please enter a valid amount")),
                    );
                    return;
                  }

                  final paymentProvider =
                      Provider.of<PaymentProvider>(context, listen: false);

                  final newPayment = Payment(
                    patientId: patientId,
                    appointmentId: appointmentId,
                    appointmentType: paymentType,
                    paymentMode: paymentMode,
                    dentist: dentistId,
                    amount: amount.toString(),
                    notes: descriptionController.text.trim(),
                    paymentDate: selectedDate,
                    paymentStatus: "completed",
                  );

                  print("Payment Request:");
                  print(newPayment.toJson());

                  final result = await paymentProvider.addPayment(newPayment);
                  if (result["success"] == true) {
                    if (visit != null) {
                      // visit.paymentStatus = "completed";
                      visit.paidAmount =
                          amount.toString(); // <-- update the amount
                      print("amount paid..");
                      print(visit.paidAmount);
                    }

                    // Optional: reload history from API if needed
                    final historyProvider = Provider.of<PatientHistoryProvider>(
                        context,
                        listen: false);
                    await historyProvider.loadHistory(patientId);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result["message"])),
                    );
                  }
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      );
    },
  );
}
