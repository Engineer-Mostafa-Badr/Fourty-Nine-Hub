
import '../../domain/entities/get_all_tube_videos_entity.dart';

class GetAllTubeVideosModel extends GetAllTubeVideosEntity {
  const GetAllTubeVideosModel({
    super.id,
    super.userId,
    super.owner,
    super.title,
    super.description,
    super.videoUrl,
    super.thumbnail,
    super.duration,
    super.category,
    super.views,
    super.likes,
    super.dislikes,
    super.isRate,
    super.averageRating,
    super.isLike,
    super.isDislike,
    super.isSubscribed,
    super.createdAt,
    super.updatedAt,
    super.isFavorite,
  });

  factory GetAllTubeVideosModel.fromJson(Map<String, dynamic> json) {
    return GetAllTubeVideosModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      owner: json['owner'] != null
          ? OwnerModel.fromJson(json['owner'] as Map<String, dynamic>)
          : null,
      title: json['title'] as String?,
      description: json['description'] as String?,
      videoUrl: json['videoUrl'] as String?,
      thumbnail: json['thumbnail'] as String?,
      duration: json['duration'] as int?,
      category: json['category'] as String?,
      views: json['views'] as int?,
      likes: json['likes'] as int?,
      dislikes: json['dislikes'] as int?,
      isRate: json['isRate'] as bool?,
      averageRating: (json['averageRating'] is int)
          ? (json['averageRating'] as int).toDouble()
          : json['averageRating'] as double?,
      isLike: json['isLike'] as bool?,
      isDislike: json['isDislike'] as bool?,
      isSubscribed: json['isSubscribed'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isFavorite: json['isFavorite'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'owner': (owner as OwnerModel?)?.toJson(),
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnail': thumbnail,
      'duration': duration,
      'category': category,
      'views': views,
      'likes': likes,
      'dislikes': dislikes,
      'isRate': isRate,
      'averageRating': averageRating,
      'isLike': isLike,
      'isDislike': isDislike,
      'isSubscribed': isSubscribed,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isFavorite': isFavorite,
    };
  }
}

class OwnerModel extends OwnerEntity {
  const OwnerModel({
    super.id,
    super.channelName,
    super.channelPicture,
    super.gender,
    super.isAccountVerified,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'] as String?,
      channelName: json['channelName'] as String?,
      channelPicture: json['channelPicture'] as String?,
      gender: json['gender'] as String?,
      isAccountVerified: json['isAccountVerified'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channelName': channelName,
      'channelPicture': channelPicture,
      'gender': gender,
      'isAccountVerified': isAccountVerified,
    };
  }
}
