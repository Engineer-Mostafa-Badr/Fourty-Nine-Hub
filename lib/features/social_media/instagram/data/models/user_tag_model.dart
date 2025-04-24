import 'package:fourtyninehub/features/social_media/instagram/domain/entities/user_tag_entity.dart';

class UserTagModel extends UserTagEntity {
  UserTagModel({
    required super.id,
    required super.username,
    required super.imageUrl,
    required super.firstName,
    required super.lastName,
  });

  factory UserTagModel.fromJson(Map<String, dynamic> json) => UserTagModel(
        id: json['_id'] ?? '',
        username: json['username'] ?? '',
        imageUrl: json['USER_PROFILE']['profilePictureKey'] ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
      );
}
