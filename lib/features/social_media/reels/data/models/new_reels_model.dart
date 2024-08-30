class ReelsResponse {
  final bool status;
  final String message;
  final ReelsData data;

  ReelsResponse(
      {required this.status, required this.message, required this.data});

  factory ReelsResponse.fromJson(Map<String, dynamic> json) {
    return ReelsResponse(
      status: json['status'],
      message: json['message'],
      data: ReelsData.fromJson(json['data']),
    );
  }
}

class ReelsData {
  final List<Reel> reels;
  final Pagination pagination;

  ReelsData({required this.reels, required this.pagination});

  factory ReelsData.fromJson(Map<String, dynamic> json) {
    var list = json['reels'] as List;
    List<Reel> reelsList = list.map((i) => Reel.fromJson(i)).toList();

    return ReelsData(
      reels: reelsList,
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Reel {
  final String id;
  final String videoMedia;
  final String audioMedia;
  final String name;
  int likeCount;
  int commentCount;
  int shareCount;
  int saveCount;
  final int viewCount;
  final bool isLiked;
  bool isSaved;
  final bool isFollowing;
  final User user;
  final Audio audio;
  final List<String> repost;
  final String thumbnailSignedUrl;
  final DateTime createdAt;

  Reel({
    required this.id,
    required this.videoMedia,
    required this.audioMedia,
    required this.name,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.saveCount,
    required this.viewCount,
    required this.isLiked,
    required this.isSaved,
    required this.isFollowing,
    required this.user,
    required this.audio,
    required this.repost,
    required this.thumbnailSignedUrl,
    required this.createdAt,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    var repostFromJson = json['repost'] as List;
    List<String> repostList = repostFromJson.map((i) => i.toString()).toList();

    return Reel(
      id: json['_id'],
      videoMedia: json['videoMedia'],
      audioMedia: json['audioMedia'],
      name: json['name'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      shareCount: json['shareCount'],
      saveCount: json['saveCount'],
      viewCount: json['viewCount'],
      isLiked: json['isLiked'],
      isSaved: json['isSaved'],
      isFollowing: json['isFollowing'],
      user: User.fromJson(json['user']),
      audio: Audio.fromJson(json['audio']),
      repost: repostList,
      thumbnailSignedUrl: json['thumbnailSignedUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final bool isFriend;
  final String privacy;
  final bool story;
  final bool verified;
  final String profilePictureSignedUrl;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.isFriend,
    required this.privacy,
    required this.story,
    required this.verified,
    required this.profilePictureSignedUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      isFriend: json['isFriend'],
      privacy: json['privacy'],
      story: json['story'],
      verified: json['verified'],
      profilePictureSignedUrl: json['profilePictureSignedUrl'],
    );
  }
}

class Audio {
  final String id;
  final int reelsCount;
  final String audioSignedUrl;
  final String audioPicture;
  final String audioName;
  final String username;

  Audio({
    required this.id,
    required this.reelsCount,
    required this.audioSignedUrl,
    required this.audioPicture,
    required this.audioName,
    required this.username,
  });

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      id: json['_id'],
      reelsCount: json['reelsCount'],
      audioSignedUrl: json['audioSignedUrl'],
      audioPicture: json['audioPicture'],
      audioName: json['audioName'],
      username: json['username'],
    );
  }
}

class Pagination {
  final int countItem;
  final int pageCount;
  final int currentPage;

  Pagination({
    required this.countItem,
    required this.pageCount,
    required this.currentPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      countItem: json['countItem'],
      pageCount: json['pageCount'],
      currentPage: json['currentPage'],
    );
  }
}
