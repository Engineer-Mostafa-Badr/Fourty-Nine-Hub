import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';

class InstagramPostModel extends InstagramPostEntity {
  InstagramPostModel(
      {required super.id,
      required super.content,
      required super.userId,
      required super.firstName,
      required super.lastName});

  factory InstagramPostModel.fromJson(Map<String, dynamic> json) {
    return InstagramPostModel(
      id: json['_id'],
      content: json['content'],
      userId: json['user']['_id'],
      firstName: json['user']['firstName'],
      lastName: json['user']['lastName'],
    );
  }
}
