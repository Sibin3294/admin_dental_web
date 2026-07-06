import 'dart:convert';
import 'package:dental_admin_web/config/api_config.dart';
import 'package:dental_admin_web/models/service_video.dart';
import 'package:http/http.dart' as http;

class ServiceVideoService {
  static String get baseUrl => '${ApiConfig.ourServices}/getAllServiceVideos';
  static String get addbaseUrl => '${ApiConfig.ourServices}/addServiceVideo';

  Future<List<ServiceVideo>> fetchAllVideos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List list = body['data'];

      return list.map((e) => ServiceVideo.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load videos");
    }
  }

    Future<void> addServiceVideo({
    required String serviceId,
    required String title,
    String? description,
    required String videoUrl,
    required String thumbnailUrl,
    required String category,
    String? language,
    String? duration,
    required String clinicId,
    bool notifyUsers = false,
  }) async {
    print("serviceId");
    print(serviceId);
    print(title);
    final res = await http.post(
      Uri.parse(addbaseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "serviceId": serviceId,
        "title": title,
        "description": description,
        "videoUrl": videoUrl,
        "thumbnailUrl": thumbnailUrl,
        "category": category,
        "language": language,
        "duration": duration,
        "clinicId": clinicId,
        "notifyUsers": notifyUsers,
      }),
    );

    final decoded = jsonDecode(res.body);

    if (res.statusCode != 201 || decoded["success"] != true) {
      throw Exception(decoded["message"] ?? "Failed to add video");
    }
  }

}
