import 'package:fourtyninehub/features/Conversations/Domain/Entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.userName,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.lastSeenAt,
    required super.profilePictureUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      userName: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? 'male',
      lastSeenAt: json['lastSeenAt'] != null ? DateTime.parse(json['lastSeenAt']) : DateTime.now(),
      profilePictureUrl: json['profilePicUrl'],
    );
  }
}