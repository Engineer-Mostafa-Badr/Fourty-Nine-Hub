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
  final UserReel user;
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
      id: json['_id']??'',
      videoMedia: json['videoMedia']??'',
      audioMedia: json['audioMedia']??'',
      name: json['name']??'',
      likeCount: json['likeCount']??0,
      commentCount: json['commentCount']??0,
      shareCount: json['shareCount']??0,
      saveCount: json['saveCount']??0,
      viewCount: json['viewCount']??0,
      isLiked: json['isLiked']??false,
      isSaved: json['isSaved']??false,
      user: UserReel.fromJson(json['user']),
      audio: Audio.fromJson(json['audio']),
      repost: repostList,
      thumbnailSignedUrl: json['thumbnailSignedUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class UserReel {
  final String id;
  final String firstName;
  final String lastName;
  final bool isFriend;
  final String privacy;
  final bool story;
  final bool verified;
  final String? profilePictureSignedUrl;
  final String? coverPictureSignedUrl;
  final String? bio;
  final String? birthday;
  final String? country;
  final String? countryPrivacy;
  final String? job;
  final String? jobPrivacy;
  final String? city;
  final String? cityPrivacy;
  final String? gender;
  final String? phone;
  final String? phonePrivacy;
  final bool isLoading;
  final bool isRider;
  final bool isDoctor;
  final bool isRestaurant;
  bool isFollowed;
  final bool areFriends;
  final bool isSentRequest;

  UserReel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.isFriend,
    required this.privacy,
    required this.story,
    required this.verified,
    this.profilePictureSignedUrl,
    this.coverPictureSignedUrl,
    this.bio,
    this.birthday,
    this.country,
    this.countryPrivacy,
    this.job,
    this.jobPrivacy,
    this.city,
    this.cityPrivacy,
    this.gender,
    this.phone,
    this.phonePrivacy,
    this.isLoading = false,
    this.isRider = false,
    this.isDoctor = false,
    this.isRestaurant = false,
    required this.isFollowed,
    required this.areFriends,
    required this.isSentRequest,
  });

  factory UserReel.fromJson(Map<String, dynamic> json) {
    return UserReel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      isFriend: json['isFriend'] ?? false,
      privacy: json['privacy'] ?? 'public',
      story: json['story'] ?? false,
      verified: json['verified'] ?? false,
      profilePictureSignedUrl: json['profilePictureSignedUrl']??"",
      coverPictureSignedUrl: json['coverPictureSignedUrl'],
      bio: json['bio'],
      birthday: json['birthday'],
      country: json['country'],
      countryPrivacy: json['countryPrivacy'],
      job: json['job'],
      jobPrivacy: json['jobPrivacy'],
      city: json['city'],
      cityPrivacy: json['cityPrivacy'],
      gender: json['gender'],
      phone: json['phone'],
      phonePrivacy: json['phonePrivacy'],
      isLoading: json['isLoading'] ?? false,
      isRider: json['isRider'] ?? false,
      isDoctor: json['isDoctor'] ?? false,
      isRestaurant: json['isRestaurant'] ?? false,
      isFollowed: json['isFollowed'] ?? false,
      areFriends: json['areFriends'] ?? false,
      isSentRequest: json['isSenTRequest'] ?? false,
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
