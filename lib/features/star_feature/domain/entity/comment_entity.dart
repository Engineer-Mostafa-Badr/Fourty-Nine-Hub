// lib/features/star_feature/domain/entities/comment_entity.dart
class CommentEntity {
  final String id;
  final String username;
  final String profileImage;
  final String content;
  final String timeAgo;
  final int likes;
  final bool isLiked;
  final DateTime createdAt;
  final String? parentCommentId;
  final bool isReply;

  CommentEntity({
    required this.id,
    required this.username,
    required this.profileImage,
    required this.content,
    required this.timeAgo,
    required this.likes,
    required this.isLiked,
    required this.createdAt,
    this.parentCommentId,
    this.isReply = false,
  });

  CommentEntity copyWith({
    String? id,
    String? username,
    String? profileImage,
    String? content,
    String? timeAgo,
    int? likes,
    bool? isLiked,
    DateTime? createdAt,
    String? parentCommentId,
    bool? isReply,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      content: content ?? this.content,
      timeAgo: timeAgo ?? this.timeAgo,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      isReply: isReply ?? this.isReply,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CommentEntity &&
        other.id == id &&
        other.username == username &&
        other.profileImage == profileImage &&
        other.content == content &&
        other.timeAgo == timeAgo &&
        other.likes == likes &&
        other.isLiked == isLiked &&
        other.createdAt == createdAt &&
        other.parentCommentId == parentCommentId &&
        other.isReply == isReply;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        profileImage.hashCode ^
        content.hashCode ^
        timeAgo.hashCode ^
        likes.hashCode ^
        isLiked.hashCode ^
        createdAt.hashCode ^
        parentCommentId.hashCode ^
        isReply.hashCode;
  }
}
