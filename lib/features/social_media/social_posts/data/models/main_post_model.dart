import 'package:fourtyninehub/features/social_media/create_post/data/models/activity_model.dart';
import 'package:fourtyninehub/features/social_media/create_post/data/models/feeling_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/main_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';

class MainPostModel extends MainPostEntity {
  MainPostModel({
    required super.id,
    super.content,
    super.createdAt,
    required super.type,
    super.images,
    super.isShared,
    super.activity,
    super.feeling,
    super.backgroundColor,
    super.isDocumentation,
    required super.user,
  });
  factory MainPostModel.fromJson(Map<String, dynamic> json) {
    return MainPostModel(
        id: json['_id'],
        content: json['content'] ?? '',
        type: json['type'] ?? '',
        images: json['media'] != null
            ? List<String>.from(
                json['media'].map((mediaItem) => mediaItem['photo']))
            : null,
        isShared: json['isShared'] ?? false,
        isDocumentation: json['twitter_documentation'] ?? false,
        activity: json['activity'] != null
            ? ActivityModel.fromJson(json['activity'])
            : null,
        feeling: json['feeling'] != null
            ? FeelingModel.fromJson(json['feeling'])
            : null,
        user: json['user'] == null
            ? null
            : json['user'] is String
                ? json['user']
                : TwitterUserModel.fromJson(json['user']),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        backgroundColor: json['background_color']);
  }
}
