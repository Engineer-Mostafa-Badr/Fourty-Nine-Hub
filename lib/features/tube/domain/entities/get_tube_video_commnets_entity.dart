class TubeVideoCommentsEntity {
  final bool status;
  final TubeVideoCommentsDataEntity? data;

  const TubeVideoCommentsEntity({
    required this.status,
    this.data,
  });
}

class TubeVideoCommentsDataEntity {
  final List<TubeCommentEntity> comments;
  final TubeCommentsPaginationEntity? pagination;

  const TubeVideoCommentsDataEntity({
    required this.comments,
    this.pagination,
  });
}

class TubeCommentsPaginationEntity {
  final int page;
  final int limit;
  final int total;
  final int pages;

  const TubeCommentsPaginationEntity({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });
}

class TubeCommentEntity {
  final String id;
  final String content;
  final String userId;
  final TubeCommentOwnerEntity? owner;
  final String video;
  final int likes;
  final int dislikes;
  final List<TubeReplyEntity> replies;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TubeCommentEntity({
    required this.id,
    required this.content,
    required this.userId,
    this.owner,
    required this.video,
    required this.likes,
    required this.dislikes,
    required this.replies,
    required this.createdAt,
    required this.updatedAt,
  });
}

class TubeReplyEntity {
  final String id;
  final String content;
  final String userId;
  final TubeCommentOwnerEntity? owner;
  final String video;
  final List<dynamic> likes;
  final List<dynamic> dislikes;
  final String? parentComment;
  final List<dynamic> replies;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TubeReplyEntity({
    required this.id,
    required this.content,
    required this.userId,
    this.owner,
    required this.video,
    required this.likes,
    required this.dislikes,
    this.parentComment,
    required this.replies,
    required this.createdAt,
    required this.updatedAt,
  });
}

class TubeCommentOwnerEntity {
  final String id;
  final TubeOwnerPictureEntity? channelPicture;
  final String channelName;

  const TubeCommentOwnerEntity({
    required this.id,
    this.channelPicture,
    required this.channelName,
  });
}

class TubeOwnerPictureEntity {
  final String id;
  final String mediaKey;

  const TubeOwnerPictureEntity({
    required this.id,
    required this.mediaKey,
  });
}
