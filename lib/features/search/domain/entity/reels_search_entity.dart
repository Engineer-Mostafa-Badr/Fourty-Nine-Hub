class ReelsSearchEntity {
  final String id;
  final String UserId;
  final String firstName;
  final String lastName;
  final String image;
  final VideoMediaEntity videoMedia;
  final bool isActive;
  final bool adminIgnore;
  final List<dynamic> sharedWith;
  final String name;
  final bool reelHide;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final int viewCount;
  final int saveCount;
  final bool isDeleted;
  final String? deletedAt;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? audioMedia;

  ReelsSearchEntity(
      {required this.id,
      required this.UserId,
      required this.firstName,
      required this.lastName,
      required this.image,
      required this.videoMedia,
      required this.isActive,
      required this.adminIgnore,
      required this.sharedWith,
      required this.name,
      required this.reelHide,
      required this.likeCount,
      required this.commentCount,
      required this.shareCount,
      required this.viewCount,
      required this.saveCount,
      required this.isDeleted,
      required this.deletedAt,
      required this.type,
      required this.createdAt,
      required this.updatedAt,
      required this.audioMedia});
}

class VideoMediaEntity {
  final String id;
  final String mediaKey;

  VideoMediaEntity({
    required this.id,
    required this.mediaKey,
  });
}
