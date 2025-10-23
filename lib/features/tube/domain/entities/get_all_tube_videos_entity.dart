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
  final String? createdAt;
  final String? updatedAt;
  final bool? isFavorite;

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
    this.createdAt,
    this.updatedAt,
    this.isFavorite,
  });
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
