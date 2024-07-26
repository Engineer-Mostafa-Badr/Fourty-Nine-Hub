import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';

class TwitterCommentReplyModel extends TwitterCommentReplyEntity {
  TwitterCommentReplyModel({
    required super.id,
    required super.user,
    required super.content,
    required super.post,
    required super.createdAt,
    super.loveCount,
    super.repliesCount,
    required super.image,
    required super.love,
  });
  factory TwitterCommentReplyModel.fromJson(Map<String, dynamic> json) {
    return TwitterCommentReplyModel(
      id: json['_id'],
      user: json['user'][0]['firstName'],
      content: json['content'] ?? '',
      post: json['post'] ?? '',
      loveCount: json['loveCount']??0,
      repliesCount: json['repliesCount']??0,
      createdAt: DateTime.parse(json['createdAt']),
      love: json['love'] != null ? List<String>.from(json['love']) : [],
      image: json['image']??'',
    );
  }
}
