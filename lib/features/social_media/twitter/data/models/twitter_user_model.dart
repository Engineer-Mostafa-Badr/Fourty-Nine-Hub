import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';

class TwitterUserModel extends TwitterUserEntity {
  TwitterUserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.createdAt,
    super.image,
    required super.email,
    required super.isDocumented,
  });
  factory TwitterUserModel.fromJson(Map<String, dynamic> json) {
    return TwitterUserModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'][0].toUpperCase() +
              json['firstName'].substring(1).toLowerCase() ??
          '',
      lastName: json['lastName'][0].toUpperCase() +
              json['lastName'].substring(1).toLowerCase() ??
          '',
      image: json['image'] != null
          ? json['image']
          : json['profilePictureSignedUrl'] != null
              ? json['profilePictureSignedUrl']
              : json['USER_PROFILE'] != null
                  ? json['USER_PROFILE']['image']
                  : '',
      email: json['email'] ?? '',
      isDocumented: json['twitter_documentation'] ?? false,
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
