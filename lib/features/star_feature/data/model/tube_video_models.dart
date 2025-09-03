import '../../domain/entity/star_entity.dart';
import '../../domain/entity/user_star_entity.dart';

class TubeVideoModel extends StarEntity {
  final String? userId;
  final int likes;
  final int dislikes;
  final int duration;
  final String? videoUrl;
  final String? thumbnail;

  TubeVideoModel({
    required super.id,
    required super.user,
    required super.mediaUrl,
    required super.title,
    required super.description,
    required super.isApproved,
    required super.totalViews,
    required super.averageRating,
    super.createdAt,
    super.createAt,
    required super.haveStories,
    required super.storyCount,
    this.userId,
    required this.likes,
    required this.dislikes,
    required this.duration,
    this.videoUrl,
    this.thumbnail,
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
      haveStories: false, // Not available in new API
      storyCount: 0, // Not available in new API
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

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

// Pagination model for the new API
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
    return TubeVideoPaginationModel(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 0,
    );
  }
}

// Response model for video lists
class TubeVideoListResponse {
  final List<TubeVideoModel> videos;
  final TubeVideoPaginationModel pagination;

  TubeVideoListResponse({
    required this.videos,
    required this.pagination,
  });

  factory TubeVideoListResponse.fromJson(Map<String, dynamic> json) {
    return TubeVideoListResponse(
      videos: (json['data']['videos'] as List)
          .map((video) => TubeVideoModel.fromJson(video))
          .toList(),
      pagination: TubeVideoPaginationModel.fromJson(json['data']['pagination']),
    );
  }
}
