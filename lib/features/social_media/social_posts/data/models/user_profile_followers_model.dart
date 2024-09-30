import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_followers_entity.dart';

class UserProfileFollowersModel extends UserProfileFollowersEntity {
  UserProfileFollowersModel(
      {required super.id, required super.firstName, required super.lastName});
  factory UserProfileFollowersModel.fromJson(Map<String, dynamic> json) {
    return UserProfileFollowersModel(
      id: json['followingId']['_id'] ?? '',
      firstName: json['followingId']['firstName'] ?? '',
      lastName: json['followingId']['lastName'] ?? '',
    );
  }
}
