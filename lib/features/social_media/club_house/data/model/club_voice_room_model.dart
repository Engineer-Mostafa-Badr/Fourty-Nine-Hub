import '../../domain/entities/club_voice_room_entity.dart';

class ClubVoiceRoomModel extends ClubVoiceRoomEntity {
  const ClubVoiceRoomModel({
    required super.id,
    required super.hostname,
    required super.subject,
    super.users,
  });
  factory ClubVoiceRoomModel.fromJson(Map<String, dynamic> json) {
    return ClubVoiceRoomModel(
      id: json['_id'],
      hostname: json['userId'], // Assuming hostname is the userId
      subject: json['subject'],
      users: (json['members'] as List)
          .map((e) => ClubUserModel.fromJson(e))
          .toList(),
    );
  }
}

class ClubUserModel extends ClubUserEntity {
  ClubUserModel(
      {required super.firstName,
      required super.lastName,
      required super.profilePicture,
      required super.id});

  factory ClubUserModel.fromJson(Map<String, dynamic> json) {
    return ClubUserModel(
      firstName: json['firstName'][0].toUpperCase() +
              json['firstName'].substring(1).toLowerCase() ??
          '',
      lastName: json['lastName'][0].toUpperCase() +
              json['lastName'].substring(1).toLowerCase() ??
          '',
      profilePicture: json['image'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}
