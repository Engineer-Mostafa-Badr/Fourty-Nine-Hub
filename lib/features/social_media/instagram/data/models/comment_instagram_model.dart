import 'package:fourtyninehub/features/social_media/instagram/domain/entities/comment_instagram_entity.dart';

class CommentInstagramModel extends CommentInstagramEntity {
  CommentInstagramModel({
    required super.id,
    required super.content,
    required super.likesCounter,
    required super.createdAt,
    required super.userId,
    required super.username,
    required super.replies,
    required super.repliesCount,
  });

  factory CommentInstagramModel.fromJson(Map<String, dynamic> json) {
    return CommentInstagramModel(
      id: json['commentId'] ?? '',
      content: json['content'] ?? '',
      userId: json['owner']?['userId'] ?? '',
      username: json['owner']?['username'] ?? '',
      likesCounter: json['likesCounter'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      repliesCount: json['repliesCount'] ?? 0,
      replies: json['replies'] != null
          ? List<CommentInstagramEntity>.from(
              json['replies']
                  .map((x) => CommentInstagramModel.fromJson(x))
                  .toList(),
            )
          : [],
    );
  }
}
