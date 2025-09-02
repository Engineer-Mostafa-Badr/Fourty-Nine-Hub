import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';

class PlaylistEntity {
  final String id;
  final String name;
  final String description;
  final List<StarEntity> videos;
  final String thumbnailUrl;
  final DateTime createdAt;
  final int videosCount;
  final Duration totalDuration;

  PlaylistEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.videos,
    required this.thumbnailUrl,
    required this.createdAt,
    int? videosCount,
    Duration? totalDuration,
  })  : videosCount = videosCount ?? videos.length,
        totalDuration = totalDuration ?? const Duration();

  PlaylistEntity copyWith({
    String? id,
    String? name,
    String? description,
    List<StarEntity>? videos,
    String? thumbnailUrl,
    DateTime? createdAt,
    int? videosCount,
    Duration? totalDuration,
  }) {
    return PlaylistEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      videos: videos ?? this.videos,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
      videosCount: videosCount ?? this.videosCount,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }
}
