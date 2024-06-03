import 'package:fourtyninehub/features/authentication/data/models/base_user_model.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/entities/reel_entity.dart';

class ReelModel extends ReelEntity {
  const ReelModel({
    required super.id,
    required super.name,
    required super.description,
    required super.videoUrl,
    required super.thumbnailUrl,
    super.user,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['_id'],
      user: json['user_id'] != null
          ? BaseUserModel.fromJson(json['user_id'])
          : null,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['reelSignedUrl'] ?? '',
      thumbnailUrl: json['thumbnailKey'] ?? '',
    );
  }
}
