import 'package:fourtyninehub/features/social_media/reels/domain/entities/reel_entity.dart';

class ReelModel extends ReelEntity {
  const ReelModel({
    required super.id,
    required super.name,
    required super.description,
    required super.videoUrl,
    required super.thumbnailUrl,
    super.user,
    required super.userId,
    required super.userFirstName,
    required super.userLastName,
    required super.userProfilePictureUrl,
    required super.likeCount,
    required super.commentCount,
    required super.viewCount,
    required super.saveCount,
    required super.type,
    // required super.imageUrls,
    required super.audioUrl,
    required super.createdAt,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['reel']['id'],
      user:
          null, // json['user'] != null ? BaseUserModel.fromJson(json['user']) : null,
      userId: json['user']['id'] ?? '',
      userFirstName: json['user']['firstName'] ?? '',
      userLastName: json['user']['lastName'] ?? '',
      userProfilePictureUrl: json['user']['profilePictureUrl'] ?? '',
      name: json['reel']['name'] ?? '',
      description: json['reel']['description'] ?? '',
      likeCount: json['reel']['likeCount'] ?? 0,
      commentCount: json['reel']['commentCount'] ?? 0,
      viewCount: json['reel']['viewCount'] ?? 0,
      saveCount: json['reel']['saveCount'] ?? 0,
      type: json['reel']['type'] ?? '',
      thumbnailUrl: json['reel']['thumbnailMediaUrl'] ?? '',
      // imageUrls: json['reel']['imageUrls'] ?? [],
      videoUrl: json['reel']['videoUrl'] ?? '',
      audioUrl: json['reel']['audioUrl'] ?? '',
      createdAt: json['reel']['createdAt'] ?? '',
    );
  }
}
