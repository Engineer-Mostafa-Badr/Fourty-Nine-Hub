class ReelEntity {
  final String id;
  final String videoUrl; // Direct video URL (m3u8)
  final String? thumbnailUrl;
  final String? title;
  final String? description;
  final String? authorName;
  final String? authorAvatar;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isFollowing;
  final Duration duration;
  final DateTime createdAt;

  ReelEntity({
    required this.id,
    required this.videoUrl,
    this.thumbnailUrl,
    this.title,
    this.description,
    this.authorName,
    this.authorAvatar,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
    this.isFollowing = false,
    required this.duration,
    required this.createdAt,
  });

  ReelEntity copyWith({
    String? id,
    String? videoUrl,
    String? thumbnailUrl,
    String? title,
    String? description,
    String? authorName,
    String? authorAvatar,
    int? likes,
    int? comments,
    int? shares,
    bool? isLiked,
    bool? isFollowing,
    Duration? duration,
    DateTime? createdAt,
  }) {
    return ReelEntity(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
      isFollowing: isFollowing ?? this.isFollowing,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
