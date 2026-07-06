class ServiceVideo {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final int duration;

  ServiceVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
  });

  factory ServiceVideo.fromJson(Map<String, dynamic> json) {
    return ServiceVideo(
      id: json['_id'],
      title: json['title'],
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      duration: json['duration'] ?? 0,
    );
  }
}
