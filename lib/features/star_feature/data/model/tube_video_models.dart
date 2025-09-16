import '../../domain/entity/star_entity.dart';
import '../../domain/entity/user_star_entity.dart';

class TubeVideoModel extends StarEntity {
  final String? userId;
  final int duration;
  final String? videoUrl;
  final String? thumbnail;
  final bool isLike;
  final bool isDislike;

  TubeVideoModel({
    required super.id,
    required super.user,
    required super.mediaUrl,
    required super.title,
    required super.description,
    required super.isApproved,
    required super.totalViews,
    required super.averageRating,
    required super.haveStories,
    required super.storyCount,
    required super.likes, // Pass to parent class
    required super.dislikes, // Pass to parent class
    super.createdAt,
    super.createAt,
    this.userId,
    required this.duration,
    this.videoUrl,
    this.thumbnail,
    this.isLike = false,
    this.isDislike = false,
  });

  factory TubeVideoModel.fromJson(Map<String, dynamic> json) {
    return TubeVideoModel(
      id: json['id'] ?? '',
      userId: json['userId'],
      mediaUrl: [
        MediaUrlModel(
          id: json['id'] ?? '',
          mediaKey: json['videoUrl'] ?? '',
          duration: Duration(seconds: json['duration'] ?? 0),
          mediaType: 'video',
        )
      ],
      user: TubeOwnerModel.fromJson(json['owner'] ?? {}),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isApproved: true, // Assuming all fetched videos are approved
      totalViews: json['views'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      duration: json['duration'] ?? 0,
      videoUrl: json['videoUrl'],
      thumbnail: json['thumbnail'],
      isLike: json['isLike'] ?? false,
      isDislike: json['isDislike'] ?? false,
      haveStories: false, // Not available in new API
      storyCount: 0, // Not available in new API
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  @override
  TubeVideoModel copyWith({
    String? id,
    UserStarEntity? user,
    List? mediaUrl,
    String? title,
    String? description,
    bool? isApproved,
    num? totalViews,
    num? averageRating,
    bool? haveStories,
    int? storyCount,
    int? likes,
    int? dislikes,
    DateTime? createdAt,
    String? createAt,
    String? userId,
    int? duration,
    String? videoUrl,
    String? thumbnail,
    bool? isLike,
    bool? isDislike,
  }) =>
      TubeVideoModel(
        id: id ?? this.id,
        user: user ?? this.user,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        title: title ?? this.title,
        description: description ?? this.description,
        isApproved: isApproved ?? this.isApproved,
        totalViews: totalViews ?? this.totalViews,
        averageRating: averageRating ?? this.averageRating,
        haveStories: haveStories ?? this.haveStories,
        storyCount: storyCount ?? this.storyCount,
        likes: likes ?? this.likes,
        dislikes: dislikes ?? this.dislikes,
        createdAt: createdAt ?? this.createdAt,
        createAt: createAt ?? this.createAt,
        userId: userId ?? this.userId,
        duration: duration ?? this.duration,
        videoUrl: videoUrl ?? this.videoUrl,
        thumbnail: thumbnail ?? this.thumbnail,
        isLike: isLike ?? this.isLike,
        isDislike: isDislike ?? this.isDislike,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'owner': (user as TubeOwnerModel).toJson(),
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnail': thumbnail,
      'duration': duration,
      'views': totalViews,
      'likes': likes,
      'dislikes': dislikes,
      'averageRating': averageRating,
      'isLike': isLike,
      'isDislike': isDislike,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': createdAt?.toIso8601String(),
    };
  }
}

class TubeOwnerModel extends UserStarEntity {
  final String channelName;
  final String channelPicture;

  TubeOwnerModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.image,
    required super.viewNumber,
    required super.averageRating,
    required this.channelName,
    required this.channelPicture,
  });

  factory TubeOwnerModel.fromJson(Map<String, dynamic> json) {
    return TubeOwnerModel(
      id: json['id'] ?? '',
      channelName: json['channelName'] ?? '',
      channelPicture: json['channelPicture'] ?? '',
      // Map channel data to user fields for compatibility
      firstName: json['channelName'] ?? '',
      lastName: '',
      email: '',
      image: json['channelPicture'] ?? '',
      viewNumber: 0,
      averageRating: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channelName': channelName,
      'channelPicture': channelPicture,
    };
  }
}

class MediaUrlModel extends MediaUrlEntity {
  MediaUrlModel({
    required super.id,
    required super.mediaKey,
    super.duration,
    super.mediaType,
  });

  factory MediaUrlModel.fromJson(Map<String, dynamic> json) {
    return MediaUrlModel(
      id: json['_id'] ?? json['id'] ?? '',
      mediaKey: json['mediaKey'] ?? json['videoUrl'] ?? '',
      duration:
          json['duration'] != null ? Duration(seconds: json['duration']) : null,
      mediaType: json['mediaType'] ?? 'video',
    );
  }
}

// Response model for video lists - Enhanced version
class TubeVideoListResponse {
  final List<TubeVideoModel> videos;
  final TubeVideoPaginationModel pagination;

  TubeVideoListResponse({
    required this.videos,
    required this.pagination,
  });

  factory TubeVideoListResponse.fromJson(Map<String, dynamic> json) {
    try {
      print(
          "🔍 TubeVideoListResponse parsing - Full JSON keys: ${json.keys.toList()}");

      // Handle different response structures
      Map<String, dynamic>? dataMap;
      if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
        dataMap = json['data'] as Map<String, dynamic>;
      } else {
        dataMap = json; // Fallback if data is at root level
      }

      print("🔍 Data map keys: ${dataMap.keys.toList()}");

      final videosData = dataMap['videos'] as List? ?? [];
      final paginationData =
          dataMap['pagination'] as Map<String, dynamic>? ?? {};

      print("🔍 Videos data length: ${videosData.length}");
      print("🔍 Pagination data: $paginationData");

      // Parse videos with individual error handling
      final List<TubeVideoModel> parsedVideos = [];
      for (int i = 0; i < videosData.length; i++) {
        try {
          final videoData = videosData[i] as Map<String, dynamic>;
          final video = TubeVideoModel.fromJson(videoData);
          parsedVideos.add(video);
        } catch (e) {
          print("⚠️ Failed to parse video at index $i: $e");
          // Continue parsing other videos instead of failing completely
          continue;
        }
      }

      return TubeVideoListResponse(
        videos: parsedVideos,
        pagination: TubeVideoPaginationModel.fromJson(paginationData),
      );
    } catch (e, stackTrace) {
      print('❌ Error parsing TubeVideoListResponse: $e');
      print('❌ Stack trace: $stackTrace');
      print('🔍 JSON structure: $json');

      // Return empty response instead of throwing
      return TubeVideoListResponse(
        videos: [],
        pagination: TubeVideoPaginationModel(
          page: 1,
          limit: 10,
          total: 0,
          pages: 0,
        ),
      );
    }
  }

  @override
  String toString() {
    return 'TubeVideoListResponse(videos: ${videos.length}, pagination: $pagination)';
  }
}

// Enhanced TubeVideoPaginationModel with better error handling
class TubeVideoPaginationModel {
  final int page;
  final int limit;
  final int total;
  final int pages;

  TubeVideoPaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory TubeVideoPaginationModel.fromJson(Map<String, dynamic> json) {
    try {
      final page = _parseIntSafely(json['page'], 1);
      final limit = _parseIntSafely(json['limit'], 10);
      final total = _parseIntSafely(json['total'], 0);
      final pages = _parseIntSafely(json['pages'], 0);

      print("🔍 Pagination parsed - page: $page, limit: $limit, total: $total, pages: $pages");

      return TubeVideoPaginationModel(
        page: page,
        limit: limit,
        total: total,
        pages: pages,
      );
    } catch (e) {
      print("⚠️ Failed to parse pagination, using defaults: $e");
      return TubeVideoPaginationModel(
        page: 1,
        limit: 10,
        total: 0,
        pages: 1, // Changed from 0 to 1 to ensure hasMore works correctly
      );
    }
  }

  static int _parseIntSafely(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
    return defaultValue;
  }

  @override
  String toString() {
    return 'TubeVideoPaginationModel(page: $page, limit: $limit, total: $total, pages: $pages)';
  }
}
