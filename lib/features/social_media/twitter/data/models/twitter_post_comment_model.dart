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
    super.replies,
  });
  factory TwitterPostCommentModel.fromJson(Map<String, dynamic> json) {
    return TwitterPostCommentModel(
      id: json['_id'],
      user: json['user'][0]['firstName'],
      content: json['content'] ?? '',
      post: json['post'] ?? '',
      loveCount: json['loveCount']??0,
      repliesCount: json['repliesCount']??0,
      createdAt: DateTime.parse(json['createdAt']),
      love: json['love'] != null ? List<String>.from(json['love']) : [],
      adminIgnore: json['adminIgnore']??false,
      // image: json['image'],
    );
  }
}
