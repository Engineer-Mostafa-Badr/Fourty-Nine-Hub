import '../../domain/entities/search_users_entity.dart';

class SearchUsersModel extends SearchUsersEntity {
  SearchUsersModel({
    super.id,
    super.firstName,
    super.lastName,
    super.email,
    super.twitterDocumentation,
    super.userProfile,
    super.image,
    super.coverPictureKey,
  });

  factory SearchUsersModel.fromJson(Map<String, dynamic> json) {
    return SearchUsersModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      twitterDocumentation: json['twitter_documentation'],
      userProfile: json['USER_PROFILE'] != null
          ? UserProfileModel.fromJson(json['USER_PROFILE'])
          : null,
      image: json['image'],
      coverPictureKey: json['coverPictureKey'],
    );
  }
}

class UserProfileModel extends UserProfileEntity {
  UserProfileModel({
    super.id,
    super.userId,
    super.blocked,
    super.isOnline,
    super.country,
    super.city,
    super.totalLike,
    super.totalView,
    super.totalShare,
    super.createdAt,
    super.updatedAt,
    super.profilePictureKey,
    super.coverPictureKey,
    super.usersView,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'],
      userId: json['userId'],
      blocked: json['blocked'] != null ? List<String>.from(json['blocked']) : null,
      isOnline: json['isOnline'],
      country: json['country'],
      city: json['city'],
      totalLike: json['totalLike'],
      totalView: json['totalView'],
      totalShare: json['totalShare'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      profilePictureKey: json['profilePictureKey'] != null
          ? MediaKeyModel.fromJson(json['profilePictureKey'])
          : null,
      coverPictureKey: json['coverPictureKey'] != null
          ? MediaKeyModel.fromJson(json['coverPictureKey'])
          : null,
      usersView: json['usersView'] != null ? List<String>.from(json['usersView']) : null,
    );
  }
}

class MediaKeyModel extends MediaKeyEntity {
  MediaKeyModel({
    super.id,
    super.user,
    super.subcategoryId,
    super.mimetype,
    super.size,
    super.fileName,
    super.mediaKey,
    super.successUpload,
    super.createdAt,
    super.updatedAt,
  });

  factory MediaKeyModel.fromJson(Map<String, dynamic> json) {
    return MediaKeyModel(
      id: json['_id'],
      user: json['user'],
      subcategoryId: json['subcategoryId'],
      mimetype: json['mimetype'],
      size: json['size'],
      fileName: json['fileName'],
      mediaKey: json['mediaKey'],
      successUpload: json['successUpload'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}