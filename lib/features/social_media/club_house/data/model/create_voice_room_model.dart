// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fourtyninehub/features/social_media/club_house/domain/entities/create_room_response_entity.dart';

class CreateClubVoiceRoomResponseModel extends CreateRoomResponseEntity {
  const CreateClubVoiceRoomResponseModel({
    required super.roomId,
    required super.status,
  });
  factory CreateClubVoiceRoomResponseModel.fromJson(
          Map<String, dynamic> json) =>
      CreateClubVoiceRoomResponseModel(
        roomId: json['data']['_id'],
        status: json['status'],
      );
}
