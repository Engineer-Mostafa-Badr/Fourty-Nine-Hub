import '../../domain/entities/user_tag_entity.dart';

class UserTagModel extends UserTagEntity {
  UserTagModel({
    required super.id,
    required super.username,
    required super.imageUrl,
    required super.firstName,
    required super.lastName,
  });

  factory UserTagModel.fromJson(Map<String, dynamic> json) => UserTagModel(
        id: json['id'] ?? '',
        username: json['username'] ?? '',
        imageUrl: json['profilePictureKey'] ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
      );
}
