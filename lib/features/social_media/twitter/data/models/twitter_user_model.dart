import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';


class TwitterUserModel extends TwitterUserEntity {
  TwitterUserModel(
      {
    required super.id,
    required super.firstName,
    required super.lastName,
    // required super.profilePicture,
        super.loveCount,
    required super.createdAt,

      });
  factory TwitterUserModel.fromJson(Map<String, dynamic> json) {
    return TwitterUserModel(
      id: json['_id']??'',
      firstName: json['firstName']??'',
      lastName: json['lastName']??'',
      // profilePicture: json['USER_PROFILE']['profilePictureKey'],
      loveCount: json['loveCount']??0,
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),    );
  }
}
