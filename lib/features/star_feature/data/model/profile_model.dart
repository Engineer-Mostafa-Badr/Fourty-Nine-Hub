import '../../domain/entity/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.userId,
    super.user,
    super.channelPicture,
    required super.channelName,
    super.channelCover,
    required super.videosCount,
    required super.isWinner,
    required super.channelDescription,
    super.subscribers,
    super.isSubscribed,
    super.subscribersCount,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? '',
      userId: json['user']?['_id'] ?? json['userId'] ?? '',
      // Add user information parsing
      user: json['user'] != null ? UserInfoModel.fromJson(json['user']) : null,
      // Updated: channelPicture is now a direct URL string, not an object
      channelPicture:
          json['channelPicture'] != null && json['channelPicture'] is String
              ? MediaModel(
                  id: '',
                  mediaKey: json['channelPicture'] as String,
                )
              : json['channelPicture'] != null && json['channelPicture'] is Map
                  ? MediaModel.fromJson(json['channelPicture'])
                  : null,
      channelName: json['channelName'] ?? '',
      // Updated: channelCover is now a direct URL string, not an object
      channelCover:
          json['channelCover'] != null && json['channelCover'] is String
              ? MediaModel(
                  id: '',
                  mediaKey: json['channelCover'] as String,
                )
              : json['channelCover'] != null && json['channelCover'] is Map
                  ? MediaModel.fromJson(json['channelCover'])
                  : null,
      videosCount: json['videosCount'] ?? 0,
      isWinner: json['isWinner'] ?? false,
      channelDescription: json['channelDescription'] ?? '',
      // Updated: subscribers is now a count, not an array
      subscribersCount: json['subscribers'] is int
          ? json['subscribers']
          : (json['subscribers'] as List?)?.length ?? 0,
      subscribers: json['subscribers'] is List
          ? List<String>.from(json['subscribers'])
          : [],
      isSubscribed: json['isSubscribed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'user': user is UserInfoModel ? (user as UserInfoModel).toJson() : null,
      'channelPicture': channelPicture?.mediaKey,
      'channelName': channelName,
      'channelCover': channelCover?.mediaKey,
      'videosCount': videosCount,
      'isWinner': isWinner,
      'channelDescription': channelDescription,
      'subscribers': subscribersCount,
      'isSubscribed': isSubscribed,
    };
  }
}

class UserInfoModel extends UserInfo {
  const UserInfoModel({
    required super.id,
    required super.gender,
    required super.isAccountVerified,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['_id'] ?? '',
      gender: json['gender'] ?? '',
      isAccountVerified: json['isAccountVerified'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'gender': gender,
      'isAccountVerified': isAccountVerified,
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
