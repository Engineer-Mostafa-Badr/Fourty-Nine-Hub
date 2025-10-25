import '../../domain/entities/get_tube_video_commnets_entity.dart';

class TubeVideoCommentsModel extends TubeVideoCommentsEntity {
  const TubeVideoCommentsModel({
    required super.status,
    super.data,
  });

  factory TubeVideoCommentsModel.fromJson(Map<String, dynamic> json) {
    return TubeVideoCommentsModel(
      status: json['status'] ?? false,
      data: json['data'] != null
          ? TubeVideoCommentsDataModel.fromJson(json['data'])
          : null,
    );
  }
}

class TubeVideoCommentsDataModel extends TubeVideoCommentsDataEntity {
  const TubeVideoCommentsDataModel({
    required super.comments,
    super.pagination,
  });

  factory TubeVideoCommentsDataModel.fromJson(Map<String, dynamic> json) {
    final commentsJson = json['comments'] as List<dynamic>? ?? [];
    return TubeVideoCommentsDataModel(
      comments:
      commentsJson.map((e) => TubeCommentModel.fromJson(e)).toList(),
      pagination: json['pagination'] != null
          ? TubeCommentsPaginationModel.fromJson(json['pagination'])
          : null,
    );
  }
}

class TubeCommentsPaginationModel extends TubeCommentsPaginationEntity {
  const TubeCommentsPaginationModel({
    required super.page,
    required super.limit,
    required super.total,
    required super.pages,
  });

  factory TubeCommentsPaginationModel.fromJson(Map<String, dynamic> json) {
    return TubeCommentsPaginationModel(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 1,
    );
  }
}

class TubeCommentModel extends TubeCommentEntity {
  const TubeCommentModel({
    required super.id,
    required super.content,
    required super.userId,
    super.owner,
    required super.video,
    required super.likes,
    required super.dislikes,
    required super.replies,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TubeCommentModel.fromJson(Map<String, dynamic> json) {
    return TubeCommentModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      userId: json['userId'] ?? '',
      owner: json['owner'] != null
          ? TubeCommentOwnerModel.fromJson(json['owner'])
          : null,
      video: json['video'] ?? '',
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      replies: (json['replies'] as List<dynamic>? ?? [])
          .map((e) => TubeReplyModel.fromJson(e))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class TubeReplyModel extends TubeReplyEntity {
  const TubeReplyModel({
    required super.id,
    required super.content,
    required super.userId,
    super.owner,
    required super.video,
    required super.likes,
    required super.dislikes,
    super.parentComment,
    required super.replies,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TubeReplyModel.fromJson(Map<String, dynamic> json) {
    return TubeReplyModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      userId: json['userId'] ?? '',
      owner: json['owner'] != null
          ? TubeCommentOwnerModel.fromJson(json['owner'])
          : null,
      video: json['video'] ?? '',
      likes: (json['likes'] ?? []) as List<dynamic>,
      dislikes: (json['dislikes'] ?? []) as List<dynamic>,
      parentComment: json['parentComment'],
      replies: (json['replies'] ?? []) as List<dynamic>,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class TubeCommentOwnerModel extends TubeCommentOwnerEntity {
  const TubeCommentOwnerModel({
    required super.id,
    super.channelPicture,
    required super.channelName,
  });

  factory TubeCommentOwnerModel.fromJson(Map<String, dynamic> json) {
    return TubeCommentOwnerModel(
      id: json['_id'] ?? '',
      channelPicture: json['channelPicture'] != null
          ? TubeOwnerPictureModel.fromJson(json['channelPicture'])
          : null,
      channelName: json['channelName'] ?? '',
    );
  }
}

class TubeOwnerPictureModel extends TubeOwnerPictureEntity {
  const TubeOwnerPictureModel({
    required super.id,
    required super.mediaKey,
  });

  factory TubeOwnerPictureModel.fromJson(Map<String, dynamic> json) {
    return TubeOwnerPictureModel(
      id: json['_id'] ?? '',
      mediaKey: json['mediaKey'] ?? '',
    );
  }
}
