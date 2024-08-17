import '../../domain/entities/club_voice_room_entity.dart';

class ClubVoiceRoomModel extends ClubVoiceRoomEntity {
  const ClubVoiceRoomModel({
    required super.id,
    required super.hostname,
    required super.subject,
    required super.users,
  });
  factory ClubVoiceRoomModel.fromJson(Map<String, dynamic> json) {
    return ClubVoiceRoomModel(
      id: json['_id'],
      hostname: json['userId'], // Assuming hostname is the userId
      subject: json['subject'],
      users: List<String>.from(json['members']),
    );
  }
}
