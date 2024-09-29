import '../../domain/entity/user_auction_entity.dart';

class UserAuctionModel extends UserAuctionEntity {
  UserAuctionModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.email,
      required super.twitterDocumentation,
      required super.profile});

  factory UserAuctionModel.fromJson(Map<String, dynamic> json) {
    return UserAuctionModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      twitterDocumentation: json['twitter_documentation'],
      profile: UserAuctionProfileModel.fromJson(json['USER_PROFILE']),
    );
  }
}

class UserAuctionProfileModel extends UserAuctionProfile {
  UserAuctionProfileModel(
      {required super.id, required super.profilePictureKey});

  factory UserAuctionProfileModel.fromJson(Map<String, dynamic> json) {
    return UserAuctionProfileModel(
      id: json['_id'],
      profilePictureKey: ProfilePictureKeyModel.fromJson(json['profilePictureKey']),
    );
  }
}

class ProfilePictureKeyModel extends ProfilePictureKey {
  ProfilePictureKeyModel(
      {required super.id,
      required super.user,
      required super.subcategoryId,
      required super.mimetype,
      required super.size,
      required super.mediaKey,
      required super.successUpload,
      required super.createdAt,
      required super.updatedAt});

  factory ProfilePictureKeyModel.fromJson(Map<String, dynamic> json) {
    return ProfilePictureKeyModel(
      id: json['_id'],
      user: json['user'],
      subcategoryId: json['subcategoryId'],
      mimetype: json['mimetype'],
      size: json['size'],
      mediaKey: json['mediaKey'],
      successUpload: json['successUpload'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
