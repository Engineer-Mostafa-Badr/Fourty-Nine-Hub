import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  UserProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    super.profilePicture,
    super.profileCover,
    super.friendsCount,
    super.followersCount,
    super.followingCount,
    required super.totalView,
    super.isFollowed,
    super.areFriends,
    super.isDocument,
    super.sentFriendRequest,
    super.isBlock,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['userId']['_id'],
      firstName: json['userId']['firstName'] ?? '',
      lastName: json['userId']['lastName'] ?? '',
      email: json['userId']['email'] ?? '',
      isDocument: json['userId']['twitter_documentation'] ?? false,
      totalView: json['totalView'] ?? 0,
      profilePicture: json['profilePictureKey'] ?? '',
      profileCover: json['coverPictureKey'] ?? '',
      friendsCount: json['friendsCount'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      isFollowed: json['isFollowed'] ?? false,
      areFriends: json['areFriends'] ?? false,
      sentFriendRequest: json['sentFriendRequest'] ?? false,
      isBlock: json['isBlock'] ?? false,
    );
  }
}
