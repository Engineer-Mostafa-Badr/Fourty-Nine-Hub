import 'package:fourtyninehub/features/social_media/instagram/domain/entities/followers_entity.dart';

class FollowersModel extends FollowersEntity {
  FollowersModel(
      {required super.id,
      required super.followerId,
      required super.firstName,
      required super.lastname,
      required super.email,
      required super.image,
      required super.userId,
      required super.followingId});

  factory FollowersModel.fromJson(Map<String, dynamic> json) {
    return FollowersModel(
        id: json['_id'] ?? '',
        followerId: json['followerId']['_id'] ?? '',
        firstName: json['followerId']['firstName'] ?? '',
        lastname: json['followerId']['lastName'] ?? '',
        email: json['followerId']['email'] ?? '',
        image: json['followerId']['image'] ?? '',
        userId: json['followerId']['USER_PROFILE']['_id'] ?? '',
        followingId: json['followingId'] ?? '');
  }
}
