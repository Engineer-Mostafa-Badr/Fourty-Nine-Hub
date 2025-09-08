import '../../domain/entity/playlist_entity.dart';
import '../../domain/entity/star_entity.dart';
import '../../../star_feature/data/model/tube_video_models.dart';
import '../../domain/repository/playlist_repository.dart';

class PlaylistModel extends PlaylistEntity {
  PlaylistModel({
    required super.id,
    required super.name,
    required super.description,
    required super.thumbnail,
    required super.videos,
    required super.createdAt,
    super.videosCount,
    super.totalDuration,
    required super.ownerId,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      videos: (json['videos'] as List?)
              ?.map((video) => TubeVideoModel.fromJson(video))
              .cast<StarEntity>()
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      videosCount: json['videosCount'],
      ownerId: json['ownerId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnail': thumbnail,
      'videos': videos.map((video) {
        if (video is TubeVideoModel) {
          return video.toJson();
        }
        return {}; // fallback
      }).toList(),
      'createdAt': createdAt.toIso8601String(),
      'videosCount': videosCount,
      'ownerId': ownerId,
    };
  }

  @override
  PlaylistModel copyWith({
    String? id,
    String? name,
    String? description,
    String? thumbnail,
    List<StarEntity>? videos,
    DateTime? createdAt,
    int? videosCount,
    Duration? totalDuration,
    String? ownerId,
  }) {
    return PlaylistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      videos: videos ?? this.videos,
      createdAt: createdAt ?? this.createdAt,
      videosCount: videosCount ?? this.videosCount,
      totalDuration: totalDuration ?? this.totalDuration,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}

// Response model for playlist list with pagination
class PlaylistListResponseModel extends PlaylistListResponse {
  PlaylistListResponseModel({
    required super.playlists,
    required super.pagination,
  });

  factory PlaylistListResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      final dataMap = json['data'] as Map<String, dynamic>? ?? {};
      final playlistsData =
          dataMap['formattedPlaylist'] as List? ?? [];
      final paginationData =
          dataMap['pagination'] as Map<String, dynamic>? ?? {};

      return PlaylistListResponseModel(
        playlists: playlistsData
            .map((playlist) => PlaylistModel.fromJson(playlist))
            .toList(),
        pagination: PlaylistPaginationModelImpl.fromJson(paginationData),
      );
    } catch (e) {
      print('Error parsing PlaylistListResponseModel: $e');
      return PlaylistListResponseModel(
        playlists: [],
        pagination: PlaylistPaginationModelImpl(
          page: 1,
          limit: 10,
          total: 0,
          pages: 0,
        ),
      );
    }
  }
}

// Pagination model implementation
class PlaylistPaginationModelImpl extends PlaylistPaginationModel {
  PlaylistPaginationModelImpl({
    required super.page,
    required super.limit,
    required super.total,
    required super.pages,
  });

  factory PlaylistPaginationModelImpl.fromJson(Map<String, dynamic> json) {
    return PlaylistPaginationModelImpl(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'pages': pages,
    };
  }
}