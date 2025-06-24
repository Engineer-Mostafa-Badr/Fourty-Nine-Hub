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
    required super.hasStory,
  });

  factory TwitterUserModel.fromJson(dynamic json) {
    print('JSON: $json');
    // Handle case where json is just a user ID string
    if (json is String) {
      return TwitterUserModel(
        id: json,
        firstName: '',
        lastName: '',
        email: '',
        isDocumented: false,
        hasStory: false,
        createdAt: DateTime.now(),
      );
    }

    // Handle case where json is a Map
    if (json is Map<String, dynamic>) {
      String? image;

      // Check for direct image URL first
      if (json['image'] is String) {
        image = json['image'];
      }
      // Fallback to nested USER_PROFILE
      else if (json['USER_PROFILE'] is Map<String, dynamic>) {
        final userProfile = json['USER_PROFILE'] as Map<String, dynamic>;
        if (userProfile['profilePictureKey'] is Map<String, dynamic>) {
          final profilePictureKey = userProfile['profilePictureKey'] as Map<String, dynamic>;
          image = profilePictureKey['mediaKey']?.toString();
        }
      }

      final rawFirstName = json['firstName']?.toString() ?? '';
      final rawLastName = json['lastName']?.toString() ?? '';

      return TwitterUserModel(
        id: json['_id']?.toString() ?? '',
        firstName: rawFirstName.isNotEmpty
            ? rawFirstName[0].toUpperCase() + rawFirstName.substring(1).toLowerCase()
            : '',
        lastName: rawLastName.isNotEmpty
            ? rawLastName[0].toUpperCase() + rawLastName.substring(1).toLowerCase()
            : '',
        userName: json['username']?.toString() ?? '',
        image: image ?? '',
        email: json['email']?.toString() ?? '',
        hasStory: json['hasStory'] ?? false,
        isDocumented: json['verifiedBadge'] ?? json['twitter_documentation'] ?? false,
        createdAt: json['createdAt'] is String
            ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
            : DateTime.now(),
      );
    }

    // Fallback for invalid data
    return TwitterUserModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      isDocumented: false,
      hasStory: false,
      createdAt: DateTime.now(),
    );
  }
}