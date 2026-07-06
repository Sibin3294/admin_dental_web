import 'dart:html' as html;
import 'package:dental_admin_web/config/api_config.dart';

class DataSheetService {
  static String get apiBaseUrl => ApiConfig.exportData;

  /// ⬇ Export patients CSV
  static void exportPatients() {
    print("hittt");
    final url = "$apiBaseUrl/patients";
    print("url");
    print(url);
    html.window.open(url, "_blank"); // GET happens here
  }
}
