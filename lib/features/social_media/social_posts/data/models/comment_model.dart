import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';

import '../../domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel(
      {required super.id,
      required super.content,
      required super.post,
      required super.createdAt,
      super.angryCount,
      super.likesCount,
      super.loveCount,
      super.repliesCount,
      super.totalCount,
      super.sadCount,
      required super.user,
      super.isLove,
      super.isLikes,
      super.isWow,
      super.isSad,
      super.isAngry,
      super.wowCount});
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'],
      content: json['content'],
      post: json['post'],
      isLove: json['isLove'] ?? false,
      isLikes: json['isLikes'] ?? false,
      user: json['user'] is String
          ? json['user']
          : TwitterUserModel.fromJson(json['user']),
      isWow: json['isWow'] ?? false,
      isSad: json['isSad'] ?? false,
      isAngry: json['isAngry'] ?? false,
      likesCount: json['likesCount'] ?? 0,
      loveCount: json['loveCount'] ?? 0,
      wowCount: json['wowCount'] ?? 0,
      sadCount: json['sadCount'] ?? 0,
      angryCount: json['angryCount'] ?? 0,
      repliesCount: json['repliesCount'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
