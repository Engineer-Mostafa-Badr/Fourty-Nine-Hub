class ProfileEntity {
  final String id;
  final String userId;
  final UserInfo? user; // Add user information
  final MediaEntity? channelPicture;
  final String channelName;
  final MediaEntity? channelCover;
  final int videosCount;
  final bool isWinner;
  final String channelDescription;
  final List<String> subscribers;
  final bool isSubscribed;
  final int subscribersCount;

  const ProfileEntity({
    required this.id,
    required this.userId,
    this.user,
    this.channelPicture,
    required this.channelName,
    this.channelCover,
    required this.videosCount,
    required this.isWinner,
    required this.channelDescription,
    this.subscribers = const [],
    this.isSubscribed = false,
    this.subscribersCount = 0,
  });

  ProfileEntity copyWith({
    String? id,
    String? userId,
    UserInfo? user,
    MediaEntity? channelPicture,
    String? channelName,
    MediaEntity? channelCover,
    int? videosCount,
    bool? isWinner,
    String? channelDescription,
    List<String>? subscribers,
    bool? isSubscribed,
    int? subscribersCount,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      channelPicture: channelPicture ?? this.channelPicture,
      channelName: channelName ?? this.channelName,
      channelCover: channelCover ?? this.channelCover,
      videosCount: videosCount ?? this.videosCount,
      isWinner: isWinner ?? this.isWinner,
      channelDescription: channelDescription ?? this.channelDescription,
      subscribers: subscribers ?? this.subscribers,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      subscribersCount: subscribersCount ?? this.subscribersCount,
    );
  }
}

// Add User Info class
class UserInfo {
  final String id;
  final String gender;
  final bool isAccountVerified;

  const UserInfo({
    required this.id,
    required this.gender,
    required this.isAccountVerified,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      gender: json['gender'] ?? '',
      isAccountVerified: json['isAccountVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'gender': gender,
      'isAccountVerified': isAccountVerified,
    };
  }
}

class MediaEntity {
  final String id;
  final String mediaKey;

  const MediaEntity({
    required this.id,
    required this.mediaKey,
  });
}

// Update Profile Parameters
class UpdateProfileParams {
  final String channelName;
  final String channelDescription;
  final String? channelCover;
  final String? channelPicture;

  const UpdateProfileParams({
    required this.channelName,
    required this.channelDescription,
    this.channelCover,
    this.channelPicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'channelName': channelName,
      'channelDescription': channelDescription,
      if (channelCover != null) 'channelCover': channelCover,
      if (channelPicture != null) 'channelPicture': channelPicture,
    };
  }
}

class SearchProfileParams {
  final String query;
  final int page;
  final int limit;

  SearchProfileParams({
    required this.query,
    required this.page,
    required this.limit,
  });
}
