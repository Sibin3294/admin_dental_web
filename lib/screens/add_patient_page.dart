import 'package:dental_admin_web/models/dentist.dart';
import 'package:dental_admin_web/models/patient.dart';
import 'package:dental_admin_web/providers/patient_provider.dart';
import 'package:dental_admin_web/services/dentist_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dentist_provider.dart';

class AddPatientPage extends StatefulWidget {
  // const AddDentistPage({super.key});
  final Patient? patient;
  final bool isEdit;

  const AddPatientPage({
    super.key,
    this.patient,
    this.isEdit = false,
  });

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormState>();

   final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController pwdCtrl = TextEditingController();
  

  final String backgroundUrl =
      "https://static.vecteezy.com/system/resources/thumbnails/036/595/008/small/ai-generated-dental-clinic-advertisment-background-with-copy-space-free-photo.jpg"; // <-- add your URL here

  @override
  void initState() {
    super.initState();

    // ✔ Pre-fill fields when editing
    if (widget.isEdit && widget.patient != null) {
      nameCtrl.text = widget.patient!.name;
      emailCtrl.text = widget.patient!.email;
      pwdCtrl.text = widget.patient!.password ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ⭐ Network Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.4, // soft transparent overlay
              child: Image.network(
                backgroundUrl,
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // ⭐ Main Page UI
          Column(
            children: [
              AppBar(
                elevation: 0,
                backgroundColor: Colors.white.withOpacity(0.85),
                title: const Text(
                  "Add Patient",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                iconTheme: const IconThemeData(color: Colors.black87),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      padding: const EdgeInsets.all(20),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Add New Patient",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2c3e50),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Enter patient details to add to the directory",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                _input("Patient Name", nameCtrl),
                                _input("Email", emailCtrl),
                                _input("Password", pwdCtrl),
                                // _input("Image URL (optional)", imageCtrl),

                                const SizedBox(height: 22),

                                // SizedBox(
                                //   width: double.infinity,
                                //   child: ElevatedButton(
                                //     onPressed: () async {
                                //       if (_formKey.currentState!.validate()) {
                                //         bool success =
                                //             await Provider.of<DentistsProvider>(
                                //           context,
                                //           listen: false,
                                //         ).addDentist(
                                //           nameCtrl.text,
                                //           specializationCtrl.text,
                                //           experienceCtrl.text,
                                //           qualificationCtrl.text,
                                //           imageCtrl.text,
                                //         );

                                //         if (success) Navigator.pop(context);
                                //       }
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.blue,
                                //       foregroundColor: Colors.white,
                                //       padding: const EdgeInsets.symmetric(
                                //           vertical: 16),
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(10),
                                //       ),
                                //     ),
                                //     child: const Text(
                                //       "Save Dentist",
                                //       style: TextStyle(
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        bool success = false;

                                        final provider =
                                            Provider.of<PatientsProvider>(
                                          context,
                                          listen: false,
                                        );

                                        if (widget.isEdit &&
                                            widget.patient != null) {
                                          // 🔵 EDIT dentist
                                          success =
                                              await provider.updatePatient(
                                            widget.patient!.userId,
                                            nameCtrl.text,
                                            emailCtrl.text,
                                            pwdCtrl.text
                                            // imageCtrl.text,
                                          );
                                        } else {
                                          // 🟢 ADD dentist
                                          success = await provider.addPatient(
                                            nameCtrl.text,
                                            emailCtrl.text,
                                            pwdCtrl.text
                                          );
                                        }

                                        if (success) {
                                          Navigator.pop(context);
                                          provider
                                              .fetchAllPatients(); // refresh list
                                                DentistService.getDentistCount();

                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      widget.isEdit
                                          ? "Update Patient"
                                          : "Save Patient",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // Modern rounded textfield
  Widget _input(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (v) =>
            (v == null || v.isEmpty) ? "$label is required" : null,
      ),
    );
  }
}
