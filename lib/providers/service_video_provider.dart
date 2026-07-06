// import 'package:dental_admin_web/models/service_video.dart';
// import 'package:flutter/material.dart';
// import '../services/service_video_service.dart';

// class ServiceVideoProvider extends ChangeNotifier {
//   final ServiceVideoService _service = ServiceVideoService();

//   List<ServiceVideo> videos = [];
//   bool isLoading = false;
//   String? error;

//   Future<void> getServiceVideos() async {
//     isLoading = true;
//     error = null;
//     notifyListeners();

//     try {
//       videos = await _service.fetchAllVideos();
//     } catch (e) {
//       error = e.toString();
//     }

//     isLoading = false;
//     notifyListeners();
//   }

//   // 👇 ADD VIDEO (same exact pattern)
//   Future<void> addServiceVideo({
//     required String serviceId,
//     required String title,
//     String? description,
//     required String videoUrl,
//     required String thumbnailUrl,
//     required String category,
//     String? language,
//     String? duration,
//     required String clinicId,
//     bool notifyUsers = false,
//   }) async {
//     isLoading = true;
//     notifyListeners();

//     try {
//       await _service.addServiceVideo(
//         serviceId: serviceId,
//         title: title,
//         description: description,
//         videoUrl: videoUrl,
//         thumbnailUrl: thumbnailUrl,
//         category: category,
//         language: language,
//         duration: duration,
//         clinicId: clinicId,
//         notifyUsers: notifyUsers,
//       );

//       error = null;

//       // 🔄 Refresh list after add
//       await getServiceVideos();
//     } catch (e) {
//       error = e.toString();
//     }

//     isLoading = false;
//     notifyListeners();
//   }
// }

import 'package:dental_admin_web/models/service_video.dart';
import 'package:flutter/material.dart';
import '../services/service_video_service.dart';

class ServiceVideoProvider extends ChangeNotifier {
  final ServiceVideoService _service = ServiceVideoService();

  List<ServiceVideo> videos = [];
  bool isLoading = false;
  String? error;

  // 🔹 Fetch all videos
  Future<void> getServiceVideos() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final fetchedVideos = await _service.fetchAllVideos();
      videos = List.from(fetchedVideos); // ✅ create a new list reference
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Add a new video and refresh list
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
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Add video
      await _service.addServiceVideo(
        serviceId: serviceId,
        title: title,
        description: description,
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
        category: category,
        language: language,
        duration: duration,
        clinicId: clinicId,
        notifyUsers: notifyUsers,
      );

      // 🔄 Refresh list after add
      final fetchedVideos = await _service.fetchAllVideos();
      videos = List.from(fetchedVideos); // ✅ new list object
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners(); // ensures UI updates
    }
  }
}
