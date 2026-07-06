import 'package:dental_admin_web/models/enquiry.dart';
import 'package:dental_admin_web/services/enquiry_service.dart';
import 'package:flutter/material.dart';

class EnquiryProvider extends ChangeNotifier {
  final EnquiryService _service = EnquiryService();

  List<Enquiry> enquiries = [];
  bool isLoading = false;
  String? error;

  int get pendingCount => enquiries.where((e) => !e.isReplied).length;

  Future<void> fetchEnquiries() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      enquiries = await _service.fetchAll();
      error = null;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> replyToEnquiry(String id, String adminReply) async {
    try {
      final updated = await _service.replyToEnquiry(id, adminReply);
      final index = enquiries.indexWhere((e) => e.id == id);
      if (index != -1) {
        enquiries[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
