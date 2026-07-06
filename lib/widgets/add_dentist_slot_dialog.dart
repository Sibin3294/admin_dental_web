// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/dentist_slot_provider.dart';

// class AddDentistSlotDialog extends StatefulWidget {
//   final String dentistId;

//   const AddDentistSlotDialog({super.key, required this.dentistId});

//   @override
//   State<AddDentistSlotDialog> createState() => _AddDentistSlotDialogState();
// }

// class _AddDentistSlotDialogState extends State<AddDentistSlotDialog> {
//   DateTime? selectedDate;
//   final List<String> slots = [];
//   final TextEditingController slotCtrl = TextEditingController();

//   List<String> timeOptions = [];
// String? selectedTime;

// @override
// void initState() {
//   super.initState();
//   timeOptions = _generateTimeSlots();
// }

//   @override
//   Widget build(BuildContext context) {
//     final slotProvider = Provider.of<DentistSlotProvider>(context);

//     return AlertDialog(
//       title: const Text("Add Dentist Slots"),
//       content: SizedBox(
//         width: 420,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Date picker
//             ListTile(
//               contentPadding: EdgeInsets.zero,
//               leading: const Icon(Icons.calendar_today),
//               title: Text(
//                 selectedDate == null
//                     ? "Select date"
//                     : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
//               ),
//               onTap: () async {
//                 final date = await showDatePicker(
//                   context: context,
//                   firstDate: DateTime.now(),
//                   lastDate: DateTime.now().add(const Duration(days: 365)),
//                 );
//                 if (date != null) {
//                   setState(() => selectedDate = date);
//                 }
//               },
//             ),

//             const SizedBox(height: 10),

//             // Slot input
//             Row(
//               children: [
//                Expanded(
//   child: DropdownButtonFormField<String>(
//     value: selectedTime,
//     decoration: const InputDecoration(
//       labelText: "Select Time Slot",
//       border: OutlineInputBorder(),
//     ),
//     items: timeOptions
//         .map(
//           (time) => DropdownMenuItem(
//             value: time,
//             child: Text(time),
//           ),
//         )
//         .toList(),
//     onChanged: (value) {
//       setState(() {
//         selectedTime = value;
//       });
//     },
//   ),
// ),

//              IconButton(
//   icon: const Icon(Icons.add),
//   onPressed: () {
//     if (selectedTime != null && !slots.contains(selectedTime)) {
//       setState(() {
//         slots.add(selectedTime!);
//         selectedTime = null;
//       });
//     }
//   },
// ),

//               ],
//             ),

//             const SizedBox(height: 10),

//             Wrap(
//               spacing: 8,
//               children: slots
//                   .map(
//                     (s) => Chip(
//                       label: Text(s),
//                       onDeleted: () => setState(() => slots.remove(s)),
//                     ),
//                   )
//                   .toList(),
//             )
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Cancel"),
//         ),
//         ElevatedButton(
//           onPressed: slotProvider.isLoading
//               ? null
//               : () async {
//                   if (selectedDate == null || slots.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("Date & at least one slot required"),
//                       ),
//                     );
//                     return;
//                   }

//                   try {
//                     await slotProvider.addDentistSlots(
//                       dentistId: widget.dentistId,
//                       date: selectedDate!,
//                       slots: slots,
//                     );

//                     Navigator.pop(context);

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("Slots added successfully"),
//                       ),
//                     );
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(e.toString())),
//                     );
//                   }
//                 },
//           child: slotProvider.isLoading
//               ? const SizedBox(
//                   height: 18,
//                   width: 18,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               : const Text("Save"),
//         ),
//       ],
//     );
//   }
  
//   List<String> _generateTimeSlots() {
//   final List<String> times = [];
//   DateTime start = DateTime(0, 0, 0, 9, 0); // 09:00 AM
//   DateTime end = DateTime(0, 0, 0, 19, 0);  // 07:00 PM

//   while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
//     times.add(_formatTime(start));
//     start = start.add(const Duration(minutes: 30));
//   }
//   return times;
// }

// String _formatTime(DateTime time) {
//   final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
//   final minute = time.minute.toString().padLeft(2, '0');
//   final period = time.hour >= 12 ? "PM" : "AM";
//   return "$hour:$minute $period";
// }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dentist_slot_provider.dart';

class AddDentistSlotDialog extends StatefulWidget {
  final String dentistId;

  const AddDentistSlotDialog({
    super.key,
    required this.dentistId,
  });

  @override
  State<AddDentistSlotDialog> createState() => _AddDentistSlotDialogState();
}

class _AddDentistSlotDialogState extends State<AddDentistSlotDialog> {
  DateTime? selectedDate;
  final List<String> slots = [];

  List<String> timeOptions = [];
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    timeOptions = _generateTimeSlots();
  }

  @override
  Widget build(BuildContext context) {
    final slotProvider = Provider.of<DentistSlotProvider>(context);

    return AlertDialog(
      title: const Text("Add Dentist Slots"),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 📅 Date Picker
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                selectedDate == null
                    ? "Select date"
                    : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => selectedDate = date);
                }
              },
            ),

            const SizedBox(height: 12),

            /// ⏰ Time Slot Dropdown (auto-add)
            DropdownButtonFormField<String>(
              value: selectedTime,
              decoration: const InputDecoration(
                labelText: "Select Time Slot",
                border: OutlineInputBorder(),
              ),
              items: timeOptions
                  .map(
                    (time) => DropdownMenuItem(
                      value: time,
                      child: Text(time),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;

                if (!slots.contains(value)) {
                  setState(() {
                    slots.add(value);
                    slots.sort(); // keeps order clean
                  });
                }

                // Reset dropdown for next selection
                setState(() {
                  selectedTime = null;
                });
              },
            ),

            const SizedBox(height: 12),

            /// ℹ️ Helper text
            if (slots.isEmpty)
              const Text(
                "Selected slots will appear below",
                style: TextStyle(color: Colors.grey),
              ),

            const SizedBox(height: 8),

            /// 🏷 Selected Slots
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: slots
                  .map(
                    (slot) => Chip(
                      label: Text(slot),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() => slots.remove(slot));
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),

      /// 🔘 Actions
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: slotProvider.isLoading
              ? null
              : () async {
                  if (selectedDate == null || slots.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Date & at least one slot required"),
                      ),
                    );
                    return;
                  }

                  try {
                    await slotProvider.addDentistSlots(
                      dentistId: widget.dentistId,
                      date: selectedDate!,
                      slots: slots,
                    );

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Slots added successfully"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
          child: slotProvider.isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Save"),
        ),
      ],
    );
  }

  /// 🕘 Generates slots from 09:00 AM to 07:00 PM (30 min gap)
  List<String> _generateTimeSlots() {
    final List<String> times = [];
    DateTime start = DateTime(0, 0, 0, 9, 0);
    DateTime end = DateTime(0, 0, 0, 19, 0);

    while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
      times.add(_formatTime(start));
      start = start.add(const Duration(minutes: 30));
    }
    return times;
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }
}
