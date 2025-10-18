


import 'package:fourtyninehub/features/social_media/find/domain/entity/find_like_entity.dart';

class FindLikeModel extends FindLikeEntity {
  const FindLikeModel({
    bool? status,
    String? message,
  }) : super(
    status: status,
    message: message,
  );

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
