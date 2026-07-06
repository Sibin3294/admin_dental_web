import 'package:dental_admin_web/models/dentist.dart';
import 'package:dental_admin_web/services/dentist_service.dart';
import 'package:flutter/material.dart';

class ConsultingTimingsDialog extends StatefulWidget {
  final Dentist dentist;

  const ConsultingTimingsDialog({super.key, required this.dentist});

  @override
  State<ConsultingTimingsDialog> createState() =>
      _ConsultingTimingsDialogState();
}

class _ConsultingTimingsDialogState extends State<ConsultingTimingsDialog> {
  final DentistService _service = DentistService();
  bool isSaving = false;

  static const _allDays = [
    ('monday', 'Mon'),
    ('tuesday', 'Tue'),
    ('wednesday', 'Wed'),
    ('thursday', 'Thu'),
    ('friday', 'Fri'),
    ('saturday', 'Sat'),
    ('sunday', 'Sun'),
  ];

  late Set<String> selectedDays;
  late String startTime;
  late String endTime;
  int slotDuration = 30;

  List<String> timeOptions = [];

  @override
  void initState() {
    super.initState();
    timeOptions = _generateTimeSlots();

    final schedule = widget.dentist.consultingSchedule;
    if (schedule != null && schedule['days'] is List) {
      selectedDays = (schedule['days'] as List)
          .map((d) => d.toString().toLowerCase())
          .toSet();
      startTime = schedule['startTime']?.toString() ?? '9:00 AM';
      endTime = schedule['endTime']?.toString() ?? '7:00 PM';
      slotDuration = schedule['slotDurationMinutes'] is int
          ? schedule['slotDurationMinutes'] as int
          : 30;
    } else {
      selectedDays = {'monday', 'tuesday', 'wednesday', 'thursday', 'friday'};
      startTime = '9:00 AM';
      endTime = '7:00 PM';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Consulting Timings — ${widget.dentist.name}'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Working days',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _allDays.map((day) {
                  final selected = selectedDays.contains(day.$1);
                  return FilterChip(
                    label: Text(day.$2),
                    selected: selected,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          selectedDays.add(day.$1);
                        } else {
                          selectedDays.remove(day.$1);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: timeOptions.contains(startTime)
                          ? startTime
                          : timeOptions.first,
                      decoration: const InputDecoration(
                        labelText: 'Start time',
                        border: OutlineInputBorder(),
                      ),
                      items: timeOptions
                          .map((t) =>
                              DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (v) => setState(() => startTime = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: timeOptions.contains(endTime)
                          ? endTime
                          : timeOptions.last,
                      decoration: const InputDecoration(
                        labelText: 'End time',
                        border: OutlineInputBorder(),
                      ),
                      items: timeOptions
                          .map((t) =>
                              DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (v) => setState(() => endTime = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: slotDuration,
                decoration: const InputDecoration(
                  labelText: 'Slot duration',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 30, child: Text('30 minutes')),
                  DropdownMenuItem(value: 45, child: Text('45 minutes')),
                  DropdownMenuItem(value: 60, child: Text('60 minutes')),
                ],
                onChanged: (v) => setState(() => slotDuration = v ?? 30),
              ),
              const SizedBox(height: 12),
              Text(
                'Saving will auto-generate bookable slots for the next 30 days on selected days.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isSaving ? null : _save,
          child: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save & Generate Slots'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one working day')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final result = await _service.setConsultingSchedule(
        dentistId: widget.dentist.id,
        days: selectedDays.toList(),
        startTime: startTime,
        endTime: endTime,
        slotDurationMinutes: slotDuration,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Schedule saved')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  List<String> _generateTimeSlots() {
    final List<String> times = [];
    DateTime start = DateTime(0, 0, 0, 8, 0);
    DateTime end = DateTime(0, 0, 0, 20, 0);

    while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
      times.add(_formatTime(start));
      start = start.add(const Duration(minutes: 30));
    }
    return times;
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
