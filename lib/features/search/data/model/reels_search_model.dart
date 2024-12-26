import 'package:fourtyninehub/features/search/domain/entity/reels_search_entity.dart';

class ReelsSearchModel extends ReelsSearchEntity {
  ReelsSearchModel(
      {required super.id,
      required super.UserId,
      required super.firstName,
      required super.lastName,
      required super.image,
      required super.videoMedia,
      required super.isActive,
      required super.adminIgnore,
      required super.sharedWith,
      required super.name,
      required super.reelHide,
      required super.likeCount,
      required super.commentCount,
      required super.shareCount,
      required super.viewCount,
      required super.saveCount,
      required super.isDeleted,
      required super.deletedAt,
      required super.type,
      required super.createdAt,
      required super.updatedAt,
      required super.audioMedia});

  factory ReelsSearchModel.fromJson(Map<String, dynamic> json) {
    return ReelsSearchModel(
      id: json['_id'] ?? '',
      UserId: json['user']['_id'] ?? '',
      firstName: json['user']['firstName'] ?? '',
      lastName: json['user']['lastName'] ?? '',
      image:
          json['user']['USER_PROFILE']['profilePictureKey']['mediaKey'] ?? '',
      videoMedia: VideoMediaModel.fromJson(json['videoMedia']),
      isActive: json['isActive'] ?? false,
      adminIgnore: json['adminIgnore'] ?? false,
      sharedWith: json['sharedWith'] ?? [],
      name: json['name'] ?? '',
      reelHide: json['reel_hide'] ?? false,
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      saveCount: json['saveCount'] ?? 0,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
      type: json['type'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      audioMedia: json['audioMedia'] ?? '',
    );
  }
}

class VideoMediaModel extends VideoMediaEntity {
  VideoMediaModel({required super.id, required super.mediaKey});

  factory VideoMediaModel.fromJson(Map<String, dynamic> json) {
    return VideoMediaModel(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }
}
