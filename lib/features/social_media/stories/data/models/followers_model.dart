class ResponseModel {
  bool status;
  Data data;

  ResponseModel({required this.status, required this.data});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      status: json['status'],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class Data {
  List<Follower> followers;
  Pagination pagination;

  Data({required this.followers, required this.pagination});

  factory Data.fromJson(Map<String, dynamic> json) {
    var followersList = json['followers'] as List;
    List<Follower> followers =
        followersList.map((follower) => Follower.fromJson(follower)).toList();

    return Data(
      followers: followers,
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'followers': followers.map((follower) => follower.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class Follower {
  String id;
  FollowerId followerId;
  String followingId;
  int version;

  Follower({
    required this.id,
    required this.followerId,
    required this.followingId,
    required this.version,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: json['_id'],
      followerId: FollowerId.fromJson(json['followerId']),
      followingId: json['followingId'],
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'followerId': followerId.toJson(),
      'followingId': followingId,
      '__v': version,
    };
  }
}

class FollowerId {
  String id;
  String firstName;
  String lastName;
  String email;
  bool twitterDocumentation;
  UserProfile userProfile;
  String image;

  FollowerId({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.twitterDocumentation,
    required this.userProfile,
    required this.image,
  });

  factory FollowerId.fromJson(Map<String, dynamic> json) {
    return FollowerId(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      twitterDocumentation: json['twitter_documentation'],
      userProfile: UserProfile.fromJson(json['USER_PROFILE']),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'twitter_documentation': twitterDocumentation,
      'USER_PROFILE': userProfile.toJson(),
      'image': image,
    };
  }
}

class UserProfile {
  String id;
  ProfilePictureKey profilePictureKey;

  UserProfile({required this.id, required this.profilePictureKey});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'],
      profilePictureKey: ProfilePictureKey.fromJson(json['profilePictureKey']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'profilePictureKey': profilePictureKey.toJson(),
    };
  }
}

class ProfilePictureKey {
  String id;
  String user;
  String subcategoryId;
  String mimetype;
  int size;
  String mediaKey;
  bool successUpload;
  DateTime createdAt;
  DateTime updatedAt;

  ProfilePictureKey({
    required this.id,
    required this.user,
    required this.subcategoryId,
    required this.mimetype,
    required this.size,
    required this.mediaKey,
    required this.successUpload,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfilePictureKey.fromJson(Map<String, dynamic> json) {
    return ProfilePictureKey(
      id: json['_id'],
      user: json['user'],
      subcategoryId: json['subcategoryId'],
      mimetype: json['mimetype'],
      size: json['size'],
      mediaKey: json['mediaKey'],
      successUpload: json['successUpload'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'subcategoryId': subcategoryId,
      'mimetype': mimetype,
      'size': size,
      'mediaKey': mediaKey,
      'successUpload': successUpload,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Pagination {
  int page;
  int limit;

  Pagination({required this.page, required this.limit});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
    };
  }
}
