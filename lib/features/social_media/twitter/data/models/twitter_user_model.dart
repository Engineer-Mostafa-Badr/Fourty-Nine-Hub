import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';

class TwitterUserModel extends TwitterUserEntity {
  TwitterUserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.userName,
    required super.createdAt,
    super.image,
    required super.email,
    required super.isDocumented,
  });
  factory TwitterUserModel.fromJson(Map<String, dynamic> json) {
    String? image;
    if (json['image'] != null) {
      image = json['image'];
      } else if (json['USER_PROFILE'] is Map<String, dynamic>) {
      final userProfile = json['USER_PROFILE'] as Map<String, dynamic>;
      if (userProfile['profilePictureKey'] is Map<String, dynamic>) {
        final profilePictureKey =
            userProfile['profilePictureKey'] as Map<String, dynamic>;
        image = profilePictureKey['mediaKey'] as String?;
      }
    }else{
      image = '';
    }
    // Fallback to empty string if no valid image is found
    image ??= '';
    return TwitterUserModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ??
          '',
      lastName: json['lastName']??
          '',
      userName: json['username']??'',
      image: image,
      email: json['email'] ?? '',
      isDocumented: json['twitter_documentation'] ?? false,
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
