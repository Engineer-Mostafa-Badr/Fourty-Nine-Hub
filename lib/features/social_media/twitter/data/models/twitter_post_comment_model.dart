import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';

class TwitterPostCommentModel extends TwitterPostCommentEntity {
  TwitterPostCommentModel({
    required super.id,
    required super.user,
    required super.content,
    required super.post,
    required super.createdAt,
    super.loveCount,
    super.repliesCount,
    super.showReplies,
    super.addReply,
    required super.adminIgnore,
    // required super.image,
    required super.love,
    required super.isReact,
    super.replies,
    super.edit,
  });
  factory TwitterPostCommentModel.fromJson(Map<String, dynamic> json) {
    return TwitterPostCommentModel(
      id: json['_id'],
      user: json['user'] is String
          ? json['user']
          : TwitterUserModel.fromJson(json['user']),
      content: json['content'] ?? '',
      post: json['post']!=null?json['post'] is String? json['post']: '':'',
      loveCount: json['loveCount'] ?? 0,
      repliesCount: json['repliesCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      love: json['love'] != null ? List<String>.from(json['love']) : [],
      adminIgnore: json['adminIgnore'] ?? false,
      isReact: json['isReact'] ?? false,
      // image: json['image'],
    );
  }
}
