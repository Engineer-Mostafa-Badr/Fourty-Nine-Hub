class CommentEntity {
  final String id;
  final String username;
  final String profileImage;
  final String content;
  final String timeAgo;
  final int likes;
  final int dislikes; // Added dislikes property
  final bool isLiked;
  final bool isDisliked; // Added isDisliked property
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
    this.dislikes = 0, // Default value for dislikes
    required this.isLiked,
    this.isDisliked = false, // Default value for isDisliked
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
    int? dislikes, // Added dislikes parameter
    bool? isLiked,
    bool? isDisliked, // Added isDisliked parameter
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
      dislikes: dislikes ?? this.dislikes, // Added dislikes assignment
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked, // Added isDisliked assignment
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
        other.dislikes == dislikes && // Added dislikes comparison
        other.isLiked == isLiked &&
        other.isDisliked == isDisliked && // Added isDisliked comparison
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
        dislikes.hashCode ^ // Added dislikes hash
        isLiked.hashCode ^
        isDisliked.hashCode ^ // Added isDisliked hash
        createdAt.hashCode ^
        parentCommentId.hashCode ^
        isReply.hashCode;
  }
}
