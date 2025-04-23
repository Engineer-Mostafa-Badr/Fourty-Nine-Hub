class ReelsSpecificUserDataEntity {
  final List<ReelsSpecificUserEntity> reels;
  final PaginationSpecificUserEntity pagination;

  const ReelsSpecificUserDataEntity({
    required this.reels,
    required this.pagination,
  });
}

class ReelsSpecificUserEntity {
  final String id;
  final String videoMedia;
  final List<String> images;
  final String audioMedia;
  final String name;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final int saveCount;
  final int viewCount;
  final bool isLiked;
  final bool isSaved;
  final AudioSpecificUserEntity audio;
  final String thumbnailSignedUrl;
  final String createdAt;

  const ReelsSpecificUserEntity({
    required this.id,
    required this.videoMedia,
    required this.images,
    required this.audioMedia,
    required this.name,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.saveCount,
    required this.viewCount,
    required this.isLiked,
    required this.isSaved,
    required this.audio,
    required this.thumbnailSignedUrl,
    required this.createdAt,
  });
}

class AudioSpecificUserEntity {
  final String id;
  final int reelsCount;
  final String audioSignedUrl;
  final String audioPicture;
  final String audioName;
  final String username;

  const AudioSpecificUserEntity({
    required this.id,
    required this.reelsCount,
    required this.audioSignedUrl,
    required this.audioPicture,
    required this.audioName,
    required this.username,
  });
}

class PaginationSpecificUserEntity {
  final int countItem;
  final int pageCount;
  final int currentPage;

  PaginationSpecificUserEntity({
    required this.countItem,
    required this.pageCount,
    required this.currentPage,
  });
}
