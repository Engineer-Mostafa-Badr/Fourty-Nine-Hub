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
    super.updatedAt,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    try {
      print('🎵 Parsing PlaylistModel from JSON');
      print('📊 JSON keys: ${json.keys.toList()}');

      // Parse videos array
      List<StarEntity> videosList = [];
      if (json['videos'] != null) {
        final videosJson = json['videos'] as List;
        print('📹 Found ${videosJson.length} videos in JSON');

        for (int i = 0; i < videosJson.length; i++) {
          try {
            final videoJson = videosJson[i] as Map<String, dynamic>;
            final video = TubeVideoModel.fromJson(videoJson);
            videosList.add(video);
            print('✅ Parsed video $i: ${video.title}');
          } catch (e) {
            print('❌ Failed to parse video $i: $e');
            // Continue parsing other videos instead of failing completely
            continue;
          }
        }
      }

      final playlist = PlaylistModel(
        id: json['_id'] ?? json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        thumbnail: json['thumbnail'] ?? '',
        videos: videosList,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
            : DateTime.now(),
        videosCount: json['videosCount'] ?? videosList.length,
        ownerId: json['ownerId'] ?? json['owner'] ?? '',
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'])
            : null,
      );

      print(
          '✅ Successfully parsed playlist: ${playlist.name} with ${playlist.videos.length} videos');
      return playlist;
    } catch (e, stackTrace) {
      print('❌ Error parsing PlaylistModel: $e');
      print('❌ Stack trace: $stackTrace');
      print('📊 JSON data: $json');

      // Return a basic playlist with empty videos list instead of crashing
      return PlaylistModel(
        id: json['_id'] ?? json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        thumbnail: json['thumbnail'] ?? '',
        videos: [],
        createdAt: DateTime.now(),
        videosCount: 0,
        ownerId: json['ownerId'] ?? json['owner'] ?? '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
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
      'updatedAt': updatedAt?.toIso8601String(),
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
    DateTime? updatedAt,
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
      updatedAt: updatedAt ?? this.updatedAt,
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
      final playlistsData = dataMap['formattedPlaylist'] as List? ??
          dataMap['playlists'] as List? ??
          json['playlists'] as List? ??
          [];
      final paginationData = dataMap['pagination'] as Map<String, dynamic>? ??
          json['pagination'] as Map<String, dynamic>? ??
          {};

      print('🎵 Parsing ${playlistsData.length} playlists from response');

      return PlaylistListResponseModel(
        playlists: playlistsData
            .map((playlist) => PlaylistModel.fromJson(playlist))
            .toList(),
        pagination: PlaylistPaginationModelImpl.fromJson(paginationData),
      );
    } catch (e) {
      print('❌ Error parsing PlaylistListResponseModel: $e');
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
