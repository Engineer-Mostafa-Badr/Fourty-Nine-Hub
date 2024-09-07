import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_followers_entity.dart';

class UserProfileEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String bio;
  final String city;
  final String country;
  final String job;
  final String phone;
  final int? totalView;
  final int? posts;
  final String? profilePicture;
  final String? profileCover;
  int? friendsCount;
  int? instagramPosts;
  final int? followersCount;
  final int? followingCount;
  bool? isFollowed;
  bool? areFriends;
  bool? isSenTRequest;
  bool? sentFriendRequest;
  bool? isDocument;
  bool? isBlock;
  List<UserProfileFollowersEntity>? followers;

  String get fullName => '$firstName $lastName';
  bool isMyAccount(String anotherId) {
    return id == anotherId;
  }

  UserProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.totalView,
    required this.profilePicture,
    required this.profileCover,
    required this.friendsCount,
    required this.followersCount,
    required this.followingCount,
    required this.posts,
    required this.instagramPosts,
    this.isFollowed = false,
    this.areFriends = false,
    this.isDocument = false,
    this.isSenTRequest = false,
    this.sentFriendRequest = false,
    this.isBlock = false,
    required this.bio,
    required this.city,
    required this.country,
    required this.job,
    required this.phone,
    this.followers,
  });
}
