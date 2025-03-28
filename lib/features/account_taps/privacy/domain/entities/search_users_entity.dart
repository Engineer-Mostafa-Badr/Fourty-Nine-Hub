class SearchUsersEntity {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final bool? twitterDocumentation;
  final UserProfileEntity? userProfile;
  final String? image;
  final String? coverPictureKey;

  SearchUsersEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.twitterDocumentation,
    this.userProfile,
    this.image,
    this.coverPictureKey,
  });
}

class UserProfileEntity {
  final String? id;
  final String? userId;
  final List<String>? blocked;
  final bool? isOnline;
  final String? country;
  final String? city;
  final int? totalLike;
  final int? totalView;
  final int? totalShare;
  final String? createdAt;
  final String? updatedAt;
  final MediaKeyEntity? profilePictureKey;
  final MediaKeyEntity? coverPictureKey;
  final List<String>? usersView;

  UserProfileEntity({
    this.id,
    this.userId,
    this.blocked,
    this.isOnline,
    this.country,
    this.city,
    this.totalLike,
    this.totalView,
    this.totalShare,
    this.createdAt,
    this.updatedAt,
    this.profilePictureKey,
    this.coverPictureKey,
    this.usersView,
  });
}

class MediaKeyEntity {
  final String? id;
  final String? user;
  final String? subcategoryId;
  final String? mimetype;
  final int? size;
  final String? fileName;
  final String? mediaKey;
  final bool? successUpload;
  final String? createdAt;
  final String? updatedAt;

  MediaKeyEntity({
    this.id,
    this.user,
    this.subcategoryId,
    this.mimetype,
    this.size,
    this.fileName,
    this.mediaKey,
    this.successUpload,
    this.createdAt,
    this.updatedAt,
  });
}