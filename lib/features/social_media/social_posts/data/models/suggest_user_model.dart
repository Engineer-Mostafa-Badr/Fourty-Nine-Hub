import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';

class SuggestUserModel extends SuggestUserEntity {
  SuggestUserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.profilePicture,
    required super.mutualFriendsCount,
    super.addedSuccessfully,
    super.followSuccessfully,
    super.sendWelcomeSuccessfully,
  });
  factory SuggestUserModel.fromJson(Map<String, dynamic> json) {
    return SuggestUserModel(
        id: json['_id'] ?? '',
        firstName: json['firstName'][0].toUpperCase() + json['firstName'].substring(1).toLowerCase() ?? '',
        lastName: json['lastName'][0].toUpperCase() + json['lastName'].substring(1).toLowerCase() ?? '',
        mutualFriendsCount: json['mutualFriendsCount'] ?? 0,
        profilePicture: json['profilePicture'] ?? '');
  }
}
