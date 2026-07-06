// import 'package:dental_admin_web/config/youtube_video_player_page.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/service_video_provider.dart';

// class ServiceVideoPage extends StatelessWidget {
//   const ServiceVideoPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ServiceVideoProvider()..getServiceVideos(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Dental Treatment Videos"),
//           centerTitle: true,
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 12),
//               child: ElevatedButton.icon(
//                 onPressed: () => _showAddVideoDialog(context),
//                 icon: const Icon(Icons.add),
//                 label: const Text(
//                   "Add Video",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),

//         body: Consumer<ServiceVideoProvider>(
//           builder: (context, provider, _) {
//             if (provider.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (provider.error != null) {
//               return Center(child: Text(provider.error!));
//             }

//             if (provider.videos.isEmpty) {
//               return const Center(child: Text("No videos available"));
//             }

//             return GridView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: provider.videos.length,
//               gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                 maxCrossAxisExtent: 360,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//               ),
//               itemBuilder: (context, index) {
//                 return _VideoCard(video: provider.videos[index]);
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// /// ─────────────────────────────────────────
// /// ADD VIDEO DIALOG (ADMIN ONLY)
// /// ─────────────────────────────────────────
// void _showAddVideoDialog(BuildContext context) {
//   final formKey = GlobalKey<FormState>();

//   final titleController = TextEditingController();
//   final urlController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final languageController = TextEditingController();

//   String category = "treatment";
//   bool notifyUsers = false;

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => AlertDialog(
//       title: const Text("Add New Video"),
//       content: SizedBox(
//         width: 460,
//         child: StatefulBuilder(
//           builder: (context, setState) {
//             return Form(
//               key: formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     /// TITLE
//                     TextFormField(
//                       controller: titleController,
//                       decoration: const InputDecoration(
//                         labelText: "Video Title *",
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (v) =>
//                           v == null || v.trim().isEmpty
//                               ? "Title is required"
//                               : null,
//                     ),

//                     const SizedBox(height: 12),

//                     /// YOUTUBE URL
//                     TextFormField(
//                       controller: urlController,
//                       decoration: const InputDecoration(
//                         labelText: "YouTube URL *",
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (v) {
//                         if (v == null || v.trim().isEmpty) {
//                           return "Video URL required";
//                         }
//                         final uri = Uri.tryParse(v);
//                         if (uri == null ||
//                             (!uri.host.contains("youtube.com") &&
//                                 !uri.host.contains("youtu.be"))) {
//                           return "Enter valid YouTube URL";
//                         }
//                         return null;
//                       },
//                     ),

//                     const SizedBox(height: 12),

//                     /// DESCRIPTION (OPTIONAL)
//                     TextFormField(
//                       controller: descriptionController,
//                       maxLines: 3,
//                       decoration: const InputDecoration(
//                         labelText: "Description",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),

//                     const SizedBox(height: 12),

//                     /// CATEGORY
//                     DropdownButtonFormField<String>(
//                       value: category,
//                       decoration: const InputDecoration(
//                         labelText: "Category *",
//                         border: OutlineInputBorder(),
//                       ),
//                       items: const [
//                         DropdownMenuItem(
//                             value: "education", child: Text("education")),
//                         DropdownMenuItem(
//                             value: "treatment", child: Text("treatment")),
//                         DropdownMenuItem(
//                             value: "awareness", child: Text("awareness")),
//                             DropdownMenuItem(
//                             value: "promo", child: Text("promo")),
//                       ],
//                       onChanged: (v) => setState(() => category = v!),
//                     ),
//                     const SizedBox(height: 12),

//                     /// LANGUAGE
//                     TextFormField(
//                       controller: languageController,
//                       decoration: const InputDecoration(
//                         labelText: "Language",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     /// NOTIFY USERS
//                     CheckboxListTile(
//                       contentPadding: EdgeInsets.zero,
//                       title: const Text("Notify users"),
//                       value: notifyUsers,
//                       onChanged: (v) =>
//                           setState(() => notifyUsers = v ?? false),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),

//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Cancel"),
//         ),

//         /// SAVE → BACKEND API
//         ElevatedButton.icon(
//           icon: const Icon(Icons.save),
//           label: const Text("Save"),
//           onPressed: () async {
//             if (!formKey.currentState!.validate()) return;

//             final videoId = extractYoutubeId(urlController.text);

//             try {
//               await Provider.of<ServiceVideoProvider>(
//                 context,
//                 listen: false,
//               ).addServiceVideo(
//                 serviceId: "SERVICE_ID", // 🔴 inject dynamically
//                 clinicId: "CLINIC_ID",   // 🔴 inject dynamically
//                 title: titleController.text.trim(),
//                 description: descriptionController.text.trim(),
//                 videoUrl: urlController.text.trim(),
//                 thumbnailUrl:
//                     "https://img.youtube.com/vi/$videoId/0.jpg",
//                 category: category,
//                 language: languageController.text.trim(),
//                 notifyUsers: notifyUsers,
//               );

//               Navigator.pop(context);

//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("✅ Service video added"),
//                 ),
//               );
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(e.toString())),
//               );
//             }
//           },
//         ),
//       ],
//     ),
//   );
// }


// /// ─────────────────────────────────────────
// /// VIDEO CARD
// /// ─────────────────────────────────────────
// class _VideoCard extends StatelessWidget {
//   final dynamic video;

//   const _VideoCard({required this.video});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(14),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => YoutubeVideoPlayerPage(
//               videoUrl: video.videoUrl,
//               title: video.title,
//             ),
//           ),
//         );
//       },
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           /// THUMBNAIL
//           ClipRRect(
//             borderRadius: BorderRadius.circular(14),
//             child: AspectRatio(
//               aspectRatio: 16 / 9,
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.network(
//                     video.thumbnailUrl,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       color: Colors.black12,
//                     ),
//                   ),
//                   const Center(
//                     child: Icon(
//                       Icons.play_circle_fill,
//                       size: 56,
//                       color: Colors.white70,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 8),

//           /// TITLE
//           Text(
//             video.title,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// ─────────────────────────────────────────
// /// YOUTUBE ID EXTRACTOR
// /// ─────────────────────────────────────────
// String extractYoutubeId(String url) {
//   final uri = Uri.tryParse(url);
//   if (uri == null) return "";

//   if (uri.host.contains("youtu.be")) {
//     return uri.pathSegments.first;
//   }

//   if (uri.queryParameters.containsKey("v")) {
//     return uri.queryParameters["v"]!;
//   }

//   return "";
// }

import 'package:dental_admin_web/config/youtube_video_player_page.dart';
import 'package:dental_admin_web/providers/service_video_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceVideoPage extends StatefulWidget {
  const ServiceVideoPage({super.key});

  @override
  State<ServiceVideoPage> createState() => _ServiceVideoPageState();
}

class _ServiceVideoPageState extends State<ServiceVideoPage> {
  late final ServiceVideoProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ServiceVideoProvider();
    provider.getServiceVideos(); // fetch on init
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ServiceVideoProvider>.value(
      value: provider, // keep the same instance
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dental Treatment Videos"),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ElevatedButton.icon(
                onPressed: () => _showAddVideoDialog(context, provider),
                icon: const Icon(Icons.add),
                label: const Text(
                  "Add Video",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),

        body: Consumer<ServiceVideoProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(child: Text(provider.error!));
            }

            if (provider.videos.isEmpty) {
              return const Center(child: Text("No videos available"));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.videos.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 360,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                return _VideoCard(video: provider.videos[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

void _showAddVideoDialog(BuildContext context, ServiceVideoProvider provider) {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final urlController = TextEditingController();
  final descriptionController = TextEditingController();
  final languageController = TextEditingController();

  String category = "treatment";
  bool notifyUsers = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text("Add New Video"),
      content: SizedBox(
        width: 460,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Video Title *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? "Title is required"
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        labelText: "YouTube URL *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Video URL required";
                        }
                        final uri = Uri.tryParse(v);
                        if (uri == null ||
                            (!uri.host.contains("youtube.com") &&
                                !uri.host.contains("youtu.be"))) {
                          return "Enter valid YouTube URL";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(
                        labelText: "Category *",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: "education", child: Text("education")),
                        DropdownMenuItem(
                            value: "treatment", child: Text("treatment")),
                        DropdownMenuItem(
                            value: "awareness", child: Text("awareness")),
                        DropdownMenuItem(
                            value: "promo", child: Text("promo")),
                      ],
                      onChanged: (v) => setState(() => category = v!),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: languageController,
                      decoration: const InputDecoration(
                        labelText: "Language",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Notify users"),
                      value: notifyUsers,
                      onChanged: (v) =>
                          setState(() => notifyUsers = v ?? false),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: const Text("Save"),
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            final videoId = extractYoutubeId(urlController.text);

            await provider.addServiceVideo(
              serviceId: "SERVICE_ID",
              clinicId: "CLINIC_ID",
              title: titleController.text.trim(),
              description: descriptionController.text.trim(),
              videoUrl: urlController.text.trim(),
              thumbnailUrl: "https://img.youtube.com/vi/$videoId/0.jpg",
              category: category,
              language: languageController.text.trim(),
              notifyUsers: notifyUsers,
            );

            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Service video added")),
            );
          },
        ),
      ],
    ),
  );
}

class _VideoCard extends StatelessWidget {
  final dynamic video;

  const _VideoCard({required this.video, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => YoutubeVideoPlayerPage(
              videoUrl: video.videoUrl,
              title: video.title,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.black12,
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 56,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            video.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
            Text(
            video.description,
      
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          
        ],
      ),
    );
  }
}
