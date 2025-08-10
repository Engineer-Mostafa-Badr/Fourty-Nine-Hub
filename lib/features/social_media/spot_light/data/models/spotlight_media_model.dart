import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/spotlight_media_entity.dart';

class SpotlightMediaModel extends SpotlightMediaEntity {
  const SpotlightMediaModel({
    required super.id,
    required super.userId,
    required super.type,
    super.thumbnailUrl,
    super.mediaUrl,
    super.caption,
    required super.status,
    required super.likesCount,
    required super.commentsCount,
    required super.isLiked,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SpotlightMediaModel.fromJson(Map<String, dynamic> json) {
    return SpotlightMediaModel(
      id: json['id'] ?? json['_id'] ?? '',
      userId: json['userId'] ?? '',
      type: _parseMediaType(json['type']),
      thumbnailUrl: json['thumbnailUrl'],
      mediaUrl: json['mediaUrl'],
      caption: json['caption'],
      status: parseMediaStatus(json['status']),
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString().split('.').last,
      'thumbnailUrl': thumbnailUrl,
      'mediaUrl': mediaUrl,
      'caption': caption,
      'status': status.toString().split('.').last,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static MediaType _parseMediaType(String? type) {
    switch (type?.toLowerCase()) {
      case 'image':
        return MediaType.image;
      case 'video':
        return MediaType.video;
      case 'story':
        return MediaType.story;
      default:
        return MediaType.image;
    }
  }

  static MediaStatus parseMediaStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return MediaStatus.pending;
      case 'uploading':
        return MediaStatus.uploading;
      case 'completed':
        return MediaStatus.completed;
      case 'failed':
        return MediaStatus.failed;
      default:
        return MediaStatus.pending;
    }
  }
}