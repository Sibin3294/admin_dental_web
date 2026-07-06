import 'package:flutter/material.dart';
import '../services/data_sheet_service.dart';

class DataSheetProvider extends ChangeNotifier {

  void exportPatients() {
    print("hii");
    DataSheetService.exportPatients();
  }
}
