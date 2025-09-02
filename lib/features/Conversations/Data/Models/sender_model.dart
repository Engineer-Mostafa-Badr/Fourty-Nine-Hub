import 'package:fourtyninehub/features/Conversations/Domain/Entities/sender_entity.dart';

class SenderModel extends SenderEntity{
  SenderModel({
    required super.id,
    required super.userName,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.profilePicUrl,
    required super.isMe,
  });

  factory SenderModel.fromJson(Map<String, dynamic> json) {
    return SenderModel(
      id: json['id'],
      userName: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? 'male',
      profilePicUrl: json['profilePicUrl'],
      isMe: json['isMe'] ?? false,
    );
  }
}