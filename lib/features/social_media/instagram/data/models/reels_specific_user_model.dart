import '../../domain/entities/reels_specific_user_entity.dart';

class ReelsSpecificUserDataModel extends ReelsSpecificUserDataEntity {
  ReelsSpecificUserDataModel({
    required super.reels,
    required super.pagination,
  });

  factory ReelsSpecificUserDataModel.fromJson(Map<String, dynamic> json) {
    return ReelsSpecificUserDataModel(
      reels: List<ReelsSpecificUserModel>.from(
        (json['reels'] as List).map((r) => ReelsSpecificUserModel.fromJson(r)),
      ),
      pagination: PaginationSpecificUserModel.fromJson(json['pagination']),
    );
  }
}

class ReelsSpecificUserModel extends ReelsSpecificUserEntity {
  ReelsSpecificUserModel({
    required super.id,
    required super.videoMedia,
    required super.images,
    required super.audioMedia,
    required super.name,
    required super.likeCount,
    required super.commentCount,
    required super.shareCount,
    required super.saveCount,
    required super.viewCount,
    required super.isLiked,
    required super.isSaved,
    required super.audio,
    required super.thumbnailSignedUrl,
    required super.createdAt,
  });

  factory ReelsSpecificUserModel.fromJson(Map<String, dynamic> json) {
    return ReelsSpecificUserModel(
      id: json['_id'] ?? '',
      videoMedia: json['videoMedia'] ?? [],
      images: json['images'] ?? [],
      audioMedia: json['audioMedia'] ?? [],
      name: json['name'] ?? '',
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      saveCount: json['saveCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isSaved: json['isSaved'] ?? false,
      audio: AudioSpecificUserModel.fromJson(json['audio']),
      thumbnailSignedUrl: json['thumbnailSignedUrl'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class AudioSpecificUserModel extends AudioSpecificUserEntity {
  AudioSpecificUserModel({
    required super.id,
    required super.reelsCount,
    required super.audioSignedUrl,
    required super.audioPicture,
    required super.audioName,
    required super.username,
  });

  factory AudioSpecificUserModel.fromJson(Map<String, dynamic> json) {
    return AudioSpecificUserModel(
      id: json['_id'] ?? '',
      reelsCount: json['reelsCount'] ?? 0,
      audioSignedUrl: json['audioSignedUrl'] ?? '',
      audioPicture: json['audioPicture'] ?? '',
      audioName: json['audioName'] ?? '',
      username: json['username'] ?? '',
    );
  }
}

class PaginationSpecificUserModel extends PaginationSpecificUserEntity {
  PaginationSpecificUserModel({
    required super.countItem,
    required super.pageCount,
    required super.currentPage,
  });

  factory PaginationSpecificUserModel.fromJson(Map<String, dynamic> json) {
    return PaginationSpecificUserModel(
      countItem: json['countItem'] ?? 0,
      pageCount: json['pageCount'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }
}
