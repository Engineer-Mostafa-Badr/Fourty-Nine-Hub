import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_entity.dart';

class TwitterCommentModel extends TwitterCommentEntity {
  TwitterCommentModel(
      {required super.id,
      required super.user,
      required super.content,
      required super.post,
      required super.createdAt,
      super.angryCount,
      super.likesCount,
      super.loveCount,
      super.repliesCount,
      super.sadCount,
      super.wowCount});
  factory TwitterCommentModel.fromJson(Map<String, dynamic> json) {
    return TwitterCommentModel(
      id: json['_id'],
      user: TwitterUserModel.fromJson(json['user']),
      content: json['content'] ?? '',
      post: json['post'] ?? '',
      likesCount: json['likesCount'],
      loveCount: json['loveCount'],
      wowCount: json['wowCount'],
      sadCount: json['sadCount'],
      angryCount: json['angryCount'],
      repliesCount: json['repliesCount'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
