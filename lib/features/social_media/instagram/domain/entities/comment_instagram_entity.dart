class CommentInstagramEntity {
  final String id;
  final String content;
  final int likesCounter;
  final String createdAt;
  final String userId;
  final String username;
  final List<RepliesEntity> replies;
  final int repliesCount;

  CommentInstagramEntity({
    required this.id,
    required this.content,
    required this.likesCounter,
    required this.createdAt,
    required this.userId,
    required this.username,
    required this.replies,
    required this.repliesCount,
  });
}

class RepliesEntity {}
