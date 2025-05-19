import '../../domain/entities/last_like_enyity.dart';

class LastLikeModel extends LastLikeEntity {
  const LastLikeModel({
    required super.userId,
    required super.username,
    required super.profilePic,
    required super.firstName,
    required super.lastName,
  });

  factory LastLikeModel.fromJson(Map<String, dynamic> json) {
    return LastLikeModel(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      profilePic: json['profilePictureUrl'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}
