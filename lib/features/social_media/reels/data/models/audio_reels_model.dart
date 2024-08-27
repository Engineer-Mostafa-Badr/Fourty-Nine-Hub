class ReelsForAudioResponse {
  final bool? status;
  final String? message;
  final ReelsData? data;

  ReelsForAudioResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ReelsForAudioResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ReelsForAudioResponse();
    return ReelsForAudioResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? ReelsData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    }..removeWhere((key, value) => value == null);
  }
}

class ReelsData {
  final List<Reel>? reels;
  final Pagination? pagination;

  ReelsData({
    this.reels,
    this.pagination,
  });

  factory ReelsData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ReelsData();
    return ReelsData(
      reels: (json['reels'] as List<dynamic>?)
          ?.map((e) => Reel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reels': reels?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    }..removeWhere((key, value) => value == null);
  }
}

class Reel {
  final String? id;
  final String? videoMedia;
  final String? audioMedia;
  final String? name;
  final bool? isLiked;
  final bool? isSaved;
  final bool? isFollowing;
  final User? user;
  final Audio? audio;
  final List<dynamic>? repost;
  final String? thumbnailSignedUrl;

  Reel({
    this.id,
    this.videoMedia,
    this.audioMedia,
    this.name,
    this.isLiked,
    this.isSaved,
    this.isFollowing,
    this.user,
    this.audio,
    this.repost,
    this.thumbnailSignedUrl,
  });

  factory Reel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Reel();
    return Reel(
      id: json['_id'] as String?,
      videoMedia: json['videoMedia'] as String?,
      audioMedia: json['audioMedia'] as String?,
      name: json['name'] as String?,
      isLiked: json['isLiked'] as bool?,
      isSaved: json['isSaved'] as bool?,
      isFollowing: json['isFollowing'] as bool?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      audio: json['audio'] != null ? Audio.fromJson(json['audio']) : null,
      repost: json['repost'] as List<dynamic>?,
      thumbnailSignedUrl: json['thumbnailSignedUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'videoMedia': videoMedia,
      'audioMedia': audioMedia,
      'name': name,
      'isLiked': isLiked,
      'isSaved': isSaved,
      'isFollowing': isFollowing,
      'user': user?.toJson(),
      'audio': audio?.toJson(),
      'repost': repost,
      'thumbnailSignedUrl': thumbnailSignedUrl,
    }..removeWhere((key, value) => value == null);
  }
}

class User {
  final String? id;
  final String? firstName;
  final String? lastName;
  final bool? isFriend;
  final String? privacy;
  final bool? story;
  final bool? verified;
  final String? profilePictureSignedUrl;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.isFriend,
    this.privacy,
    this.story,
    this.verified,
    this.profilePictureSignedUrl,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) return User();
    return User(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      isFriend: json['isFriend'] as bool?,
      privacy: json['privacy'] as String?,
      story: json['story'] as bool?,
      verified: json['verified'] as bool?,
      profilePictureSignedUrl: json['profilePictureSignedUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'isFriend': isFriend,
      'privacy': privacy,
      'story': story,
      'verified': verified,
      'profilePictureSignedUrl': profilePictureSignedUrl,
    }..removeWhere((key, value) => value == null);
  }
}

class Audio {
  final String? id;
  final int? reelsCount;
  final String? audioSignedUrl;
  final String? audioPicture;
  final String? audioName;
  final String? username;

  Audio({
    this.id,
    this.reelsCount,
    this.audioSignedUrl,
    this.audioPicture,
    this.audioName,
    this.username,
  });

  factory Audio.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Audio();
    return Audio(
      id: json['_id'] as String?,
      reelsCount: json['reelsCount'] as int?,
      audioSignedUrl: json['audioSignedUrl'] as String?,
      audioPicture: json['audioPicture'] as String?,
      audioName: json['audioName'] as String?,
      username: json['username'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reelsCount': reelsCount,
      'audioSignedUrl': audioSignedUrl,
      'audioPicture': audioPicture,
      'audioName': audioName,
      'username': username,
    }..removeWhere((key, value) => value == null);
  }
}

class Pagination {
  final int? countItem;
  final int? pageCount;
  final int? currentPage;

  Pagination({
    this.countItem,
    this.pageCount,
    this.currentPage,
  });

  factory Pagination.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Pagination();
    return Pagination(
      countItem: json['countItem'] as int?,
      pageCount: json['pageCount'] as int?,
      currentPage: json['currentPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countItem': countItem,
      'pageCount': pageCount,
      'currentPage': currentPage,
    }..removeWhere((key, value) => value == null);
  }
}
