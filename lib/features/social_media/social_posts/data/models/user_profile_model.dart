import 'package:fourtyninehub/features/social_media/social_posts/data/models/user_profile_followers_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  UserProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.maritalStatus,
    required super.email,
    super.profilePicture,
    super.profileCover,
    super.friendsCount,
    super.followersCount,
    super.instagramPosts,
    super.followingCount,
    required super.bio,
    required super.city,
    required super.country,
    required super.job,
    required super.phone,
    required super.totalView,
    super.isFollowed,
    super.areFriends,
    super.isDocument,
    super.isSenTRequest,
    super.sentFriendRequest,
    super.followers,
    super.isBlock,
    super.posts,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['userId']['_id'],
      firstName: json['userId']['firstName'][0].toUpperCase() +
              json['userId']['firstName'].substring(1).toLowerCase() ??
          '',
      lastName: json['userId']['lastName'][0].toUpperCase() +
              json['userId']['lastName'].substring(1).toLowerCase() ??
          '',
      bio: json['userId']['bio'] ?? '',
      city: json['userId']['city'] ?? '',
      phone: json['userId']['phone'] ?? '',
      country: json['userId']['country'] ?? '',
      maritalStatus: json['userId']['maritalStatus'] ?? '',
      job: json['userId']['job'] ?? '',
      email: json['userId']['email'] ?? '',
      isDocument: json['userId']['twitter_documentation'] ?? false,
      totalView: json['usersView'] ?? 0,
      posts: json['posts'] ?? 0,
      instagramPosts: json['instagramPosts'] ?? 0,
      profilePicture: json['profilePictureKey']['mediaKey'] ??'',
      profileCover: json['coverPictureKey']['mediaKey']??'',
      friendsCount: json['friendsCount'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      isFollowed: json['isFollowed'] ?? false,
      areFriends: json['areFriends'] ?? false,
      sentFriendRequest: json['sentFriendRequest'] ?? false,
      isBlock: json['isBlock'] ?? false,
      isSenTRequest: json['isSenTRequest'] ?? false,
      followers: json['followedByUser'] == null
          ? null
          : (json['followedByUser'] as List)
              .map((e) => UserProfileFollowersModel.fromJson(e))
              .toList(),
    );
  }
}
