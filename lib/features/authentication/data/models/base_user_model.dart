import '../../domain/entities/base_user_entity.dart';

class BaseUserModel extends BaseUserEntity {
  const BaseUserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.profilePicture,
  });

  factory BaseUserModel.fromJson(Map<String, dynamic> json) {
    return BaseUserModel(
      id: json['_id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      profilePicture: json['profile_picture'],
    );
  }
}
