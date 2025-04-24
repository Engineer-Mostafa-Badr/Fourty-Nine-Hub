import 'package:fourtyninehub/features/social_media/instagram/domain/entities/create_post_request_entity.dart';

class CreatePostRequestModel extends CreatePostRequestEntity {
  CreatePostRequestModel(
      {required super.itemId,
      required super.mediaHolderId,
      required super.signedUrl,
      });

  factory CreatePostRequestModel.fromJson(Map<String, dynamic> json) {
    return CreatePostRequestModel(
      itemId: json['itemId'],
      mediaHolderId: json['mediaHolderId'],
      signedUrl: json['signedUrl'],
    );
  }
}
