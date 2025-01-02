import 'package:fourtyninehub/features/custom_page/domain/entity/social_page_entity.dart';

class SocialPageModel extends SocialPageEntity {
  SocialPageModel({
    required super.id,
    required super.userId,
    required super.face,
    required super.insta,
    required super.tweet,
  });

  factory SocialPageModel.fromJson(Map<String, dynamic> json) {
    return SocialPageModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      face: json['49Face'] ?? false,
      insta: json['49Insta'] ?? false,
      tweet: json['49Tweet'] ?? false,
    );
  }
}
