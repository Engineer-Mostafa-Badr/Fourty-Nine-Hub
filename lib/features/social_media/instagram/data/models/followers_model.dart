import 'package:fourtyninehub/features/social_media/instagram/domain/entities/followers_entity.dart';

class FollowersModel extends FollowersEntity {
  const FollowersModel(
      {required super.firstName,
      required super.lastname,
      required super.username,
      required super.profilePictureUrl,
      required super.userId,
      });

  factory FollowersModel.fromJson(Map<String, dynamic> json) {
    return FollowersModel(
      firstName: json['firstName'],
      lastname: json['lastName'],
      username: json['username'],
      profilePictureUrl: json['profilePictureUrl']??'',
      userId: json['userId'],
    );
  }
}
