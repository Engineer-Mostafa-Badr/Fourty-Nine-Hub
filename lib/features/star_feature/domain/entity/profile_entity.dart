class ProfileEntity {
  final String id;
  final String userId;
  final MediaEntity? channelPicture;
  final String channelName;
  final MediaEntity? channelCover;
  final int videosCount;
  final bool isWinner;
  final String channelDescription;

  const ProfileEntity({
    required this.id,
    required this.userId,
    this.channelPicture,
    required this.channelName,
    this.channelCover,
    required this.videosCount,
    required this.isWinner,
    required this.channelDescription,
  });

  ProfileEntity copyWith({
    String? id,
    String? userId,
    MediaEntity? channelPicture,
    String? channelName,
    MediaEntity? channelCover,
    int? videosCount,
    bool? isWinner,
    String? channelDescription,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      channelPicture: channelPicture ?? this.channelPicture,
      channelName: channelName ?? this.channelName,
      channelCover: channelCover ?? this.channelCover,
      videosCount: videosCount ?? this.videosCount,
      isWinner: isWinner ?? this.isWinner,
      channelDescription: channelDescription ?? this.channelDescription,
    );
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