// import 'package:flutter/material.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// class YoutubeVideoPlayerPage extends StatefulWidget {
//   final String videoUrl;
//   final String title;

//   const YoutubeVideoPlayerPage({
//     super.key,
//     required this.videoUrl,
//     required this.title,
//   });

//   @override
//   State<YoutubeVideoPlayerPage> createState() =>
//       _YoutubeVideoPlayerPageState();
// }

// class _YoutubeVideoPlayerPageState extends State<YoutubeVideoPlayerPage> {
//   late YoutubePlayerController _controller;

//   @override
//   void initState() {
//     super.initState();

//     final videoId = extractYoutubeId(widget.videoUrl);

//     _controller = YoutubePlayerController(
//       params: const YoutubePlayerParams(
//         showFullscreenButton: true,
//         // autoPlay: true,
//         mute: false,
//       ),
//     )..loadVideoById(videoId: videoId);
//   }

//   @override
//   void dispose() {
//     _controller.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       body: YoutubePlayer(
//         controller: _controller,
//         aspectRatio: 16 / 9,
//       ),
//     );
//   }
// }

// /// helper
// String extractYoutubeId(String url) {
//   final uri = Uri.parse(url);

//   if (uri.host.contains('youtu.be')) {
//     return uri.pathSegments.first;
//   }

//   if (uri.queryParameters.containsKey('v')) {
//     return uri.queryParameters['v']!;
//   }

//   return '';
// }

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeVideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String title;

  const YoutubeVideoPlayerPage({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<YoutubeVideoPlayerPage> createState() =>
      _YoutubeVideoPlayerPageState();
}

class _YoutubeVideoPlayerPageState extends State<YoutubeVideoPlayerPage> {
  late YoutubePlayerController _controller;
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializePlayer(widget.videoUrl);
  }

  void _initializePlayer(String url) {
    final videoId = extractYoutubeId(url);

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        mute: false,
      ),
    )..loadVideoById(videoId: videoId);
  }

  @override
  void dispose() {
    _controller.close();
    _urlController.dispose();
    super.dispose();
  }

  void _showAddVideoDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add YouTube Video'),
        content: TextField(
          controller: _urlController,
          decoration: const InputDecoration(
            hintText: 'Paste YouTube URL',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _urlController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = extractYoutubeId(_urlController.text.trim());
              if (id.isNotEmpty) {
                _controller.loadVideoById(videoId: id);
              }
              _urlController.clear();
              Navigator.pop(context);
            },
            child: const Text('Play'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _showAddVideoDialog,
      //   child: const Icon(Icons.add),
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎥 Video Player Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.black,
                  child: YoutubePlayer(
                    controller: _controller,
                    aspectRatio: 16 / 9,
                  ),
                ),
              ),
            ),

            // 📝 Video Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Watch the video and tap + to play another one',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔑 Helper to extract YouTube ID
String extractYoutubeId(String url) {
  try {
    final uri = Uri.parse(url);

    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.first;
    }

    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    }
  } catch (_) {}

  return '';
}
