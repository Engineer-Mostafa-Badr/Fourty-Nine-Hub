import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';

class PostUserModel extends PostUserEntity {
  PostUserModel(
      {
        required super.id,
        required super.firstName,
        required super.lastName,
        required super.profilePicture,
        super.isSelected
      });
  factory PostUserModel.fromJson(Map<String, dynamic> json) {
    return PostUserModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePicture: json['USER_PROFILE']['profilePictureKey']['mediaKey'] ?? '',
    );
  }
}
