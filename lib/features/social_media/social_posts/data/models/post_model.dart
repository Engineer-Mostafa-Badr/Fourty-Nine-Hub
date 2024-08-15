import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  PostModel(
      {required super.id,
      required super.content,
      required super.createdAt,
      super.angryCount,
      super.commentsCount,
      super.images,
      super.isShared,
      super.likesCount,
      super.loveCount,
      super.sadCount,
      super.commentPrivacy,
      super.privacy,
      super.sharesCount,
      required super.user,
      super.wowCount});
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'],
      content: json['content'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      isShared: json['isShared'] ?? false,
      user: UserModel.fromJson(json['user']),
      privacy: json['privacy'],
      commentPrivacy: json['commentPrivacy'],
      sharesCount: json['sharesCount'] ?? 0,
      likesCount: json['likesCount'] ?? 0,
      loveCount: json['loveCount'] ?? 0,
      wowCount: json['wowCount'] ?? 0,
      sadCount: json['sadCount'] ?? 0,
      angryCount: json['angryCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      commentsCount: json['commentsCount'] ?? 0,
    );
  }
}
