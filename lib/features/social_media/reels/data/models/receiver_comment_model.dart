import 'package:fourtyninehub/features/social_media/reels/domain/entities/reciever_comment_entity.dart';

class ReceiverCommentModel extends ReceiverCommentEntity {
  const ReceiverCommentModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    // required super.profilePictureSignedUrl,
  });

  factory ReceiverCommentModel.fromJson(Map<String, dynamic> json) {
    return ReceiverCommentModel(
      id: json['_id']??'',
      firstName: json['firstName'],
      lastName: json['lastName'],
      // profilePictureSignedUrl: json['profilePictureSignedUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      // 'profilePictureSignedUrl': profilePictureSignedUrl,
    };
  }
}
