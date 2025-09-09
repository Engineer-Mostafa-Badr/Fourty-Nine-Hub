import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';

class PlaylistEntity {
  final String id;
  final String name;
  final String description;
  final String thumbnail;
  final List<StarEntity> videos;
  final DateTime createdAt;
  final int videosCount;
  final Duration totalDuration;
  final String ownerId;
  final DateTime? updatedAt;

  PlaylistEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.videos,
    required this.createdAt,
    int? videosCount,
    Duration? totalDuration,
    required this.ownerId,
    this.updatedAt,
  })  : videosCount = videosCount ?? videos.length,
        totalDuration = totalDuration ?? const Duration();

  PlaylistEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? thumbnail,
    List<StarEntity>? videos,
    DateTime? createdAt,
    int? videosCount,
    Duration? totalDuration,
    String? ownerId,
    DateTime? updatedAt,
  }) {
    return PlaylistEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      videos: videos ?? this.videos,
      createdAt: createdAt ?? this.createdAt,
      videosCount: videosCount ?? this.videosCount,
      totalDuration: totalDuration ?? this.totalDuration,
      ownerId: ownerId ?? this.ownerId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlaylistEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Parameters for creating playlist
class CreatePlaylistParams {
  final String name;
  final String description;
  final String thumbnailMediaId;

  CreatePlaylistParams({
    required this.name,
    required this.description,
    required this.thumbnailMediaId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'thumbnail': thumbnailMediaId,
    };
  }
}

// Parameters for getting playlists with pagination
class GetPlaylistsParams {
  final String ownerId;
  final int page;
  final int limit;

  GetPlaylistsParams({
    required this.ownerId,
    this.page = 1,
    this.limit = 10,
  });
}

// Parameters for adding/removing video to/from playlist
class PlaylistVideoParams {
  final String playlistId;
  final String videoId;

  PlaylistVideoParams({
    required this.playlistId,
    required this.videoId,
  });

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
    };
  }
}

// Parameters for updating playlist
class PlaylistParams {
  final String playlistId;
  final String? name;
  final String? description;
  final String? thumbnailMediaId;

  PlaylistParams({
    required this.playlistId,
    this.name,
    this.description,
    this.thumbnailMediaId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (thumbnailMediaId != null) data['thumbnail'] = thumbnailMediaId;
    
    return data;
  }
}