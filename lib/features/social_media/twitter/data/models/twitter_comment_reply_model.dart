import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';

class TwitterCommentReplyModel extends TwitterCommentReplyEntity {
  TwitterCommentReplyModel({
    required super.id,
    required super.user,
    required super.content,
    required super.post,
    required super.createdAt,
    super.loveCount,
    super.repliesCount,
    super.isReact,
    required super.image,
    required super.love,
  });
  factory TwitterCommentReplyModel.fromJson(Map<String, dynamic> json) {
    return TwitterCommentReplyModel(
      id: json['_id'],
      user: json['user'] is String? json['user']:TwitterUserModel.fromJson(json['user']),
      content: json['content'] ?? '',
      post: json['post'] ?? '',
      loveCount: json['loveCount']??0,
      repliesCount: json['repliesCount']??0,
      createdAt: DateTime.parse(json['createdAt']),
      love: json['love'] != null ? List<String>.from(json['love']) : [],
      image: json['image']??'',
      isReact: json['isReact']??false,
    );
  }
}
