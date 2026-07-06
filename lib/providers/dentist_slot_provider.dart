import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/dentist_slot_service.dart';

class DentistSlotProvider with ChangeNotifier {
  final DentistSlotService _service = DentistSlotService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> addDentistSlots({
    required String dentistId,
    required DateTime date,
    required List<String> slots,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.addDentistSlots(
        dentistId: dentistId,
        date: date,
        slots: slots,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
}
