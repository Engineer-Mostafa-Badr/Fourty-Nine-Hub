
class GetAllTubeVideosEntity {
  final String? id;
  final String? userId;
  final OwnerEntity? owner;
  final String? title;
  final String? description;
  final String? videoUrl;
  final String? thumbnail;
  final int? duration;
  final String? category;
  final int? views;
  final int? likes;
  final int? dislikes;
  final bool? isRate;
  final double? averageRating;
  final bool? isLike;
  final bool? isDislike;
  final bool? isSubscribed;
  final int? subscriberCount;
  final String? createdAt;
  final String? updatedAt;
  final bool? isFavorite;
  final String? localThumbnailPath;
  final int? userRating;        // <-- NEW: user's own rating (1-5)
  // NEW: client-side only
  final bool isWatchLater;

  const GetAllTubeVideosEntity({
    this.id,
    this.userId,
    this.owner,
    this.title,
    this.description,
    this.videoUrl,
    this.thumbnail,
    this.duration,
    this.category,
    this.views,
    this.likes,
    this.dislikes,
    this.isRate,
    this.averageRating,
    this.isLike,
    this.isDislike,
    this.isSubscribed,
    this.subscriberCount,
    this.createdAt,
    this.updatedAt,
    this.isFavorite,
    this.localThumbnailPath,
    this.isWatchLater = false, // default: not in watch later
    this.userRating,            // <-- NEW
  });

  GetAllTubeVideosEntity copyWith({
    String? id,
    String? userId,
    OwnerEntity? owner,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnail,
    int? duration,
    String? category,
    int? views,
    int? likes,
    int? dislikes,
    bool? isRate,
    double? averageRating,
    bool? isLike,
    bool? isDislike,
    bool? isSubscribed,
    int? subscriberCount,
    String? createdAt,
    String? updatedAt,
    bool? isFavorite,
    String? localThumbnailPath,
    bool? isWatchLater,
    int? userRating,            // <-- NEW
  }) {
    return GetAllTubeVideosEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      owner: owner ?? this.owner,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnail: thumbnail ?? this.thumbnail,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      isRate: isRate ?? this.isRate,
      averageRating: averageRating ?? this.averageRating,
      isLike: isLike ?? this.isLike,
      isDislike: isDislike ?? this.isDislike,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      subscriberCount: subscriberCount ?? this.subscriberCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      localThumbnailPath: localThumbnailPath ?? this.localThumbnailPath,
      isWatchLater: isWatchLater ?? this.isWatchLater,
      userRating: userRating ?? this.userRating, // <-- NEW
    );
  }
}
class OwnerEntity {
  final String? id;
  final String? channelName;
  final String? channelPicture;
  final String? gender;
  final bool? isAccountVerified;

  const OwnerEntity({
    this.id,
    this.channelName,
    this.channelPicture,
    this.gender,
    this.isAccountVerified,
  });
}