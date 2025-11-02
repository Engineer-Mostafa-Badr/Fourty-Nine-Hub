


import 'package:fourtyninehub/features/social_media/find/domain/entity/find_like_entity.dart';

class FindLikeModel extends FindLikeEntity {
  const FindLikeModel({
    super.status,
    super.message,
  });

  factory FindLikeModel.fromJson(Map<String, dynamic> json) {
    return FindLikeModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
