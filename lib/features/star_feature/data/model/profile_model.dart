import '../../domain/entity/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.userId,
    super.channelPicture,
    required super.channelName,
    super.channelCover,
    required super.videosCount,
    required super.isWinner,
    required super.channelDescription,
    super.subscribers,
    super.isSubscribed,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      channelPicture: json['channelPicture'] != null
          ? MediaModel.fromJson(json['channelPicture'])
          : null,
      channelName: json['channelName'] ?? '',
      channelCover: json['channelCover'] != null
          ? MediaModel.fromJson(json['channelCover'])
          : null,
      videosCount: json['videosCount'] ?? 0,
      isWinner: json['isWinner'] ?? false,
      channelDescription: json['channelDescription'] ?? '',
      subscribers: json['subscribers'] != null
          ? List<String>.from(json['subscribers'])
          : [],
      isSubscribed: json['isSubscribed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'channelPicture': channelPicture != null
          ? (channelPicture as MediaModel).toJson()
          : null,
      'channelName': channelName,
      'channelCover':
          channelCover != null ? (channelCover as MediaModel).toJson() : null,
      'videosCount': videosCount,
      'isWinner': isWinner,
      'channelDescription': channelDescription,
      'subscribers': subscribers,
      'isSubscribed': isSubscribed,
    };
  }
}

class MediaModel extends MediaEntity {
  const MediaModel({
    required super.id,
    required super.mediaKey,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['_id'] ?? '',
      mediaKey: json['mediaKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mediaKey': mediaKey,
    };
  }
}
