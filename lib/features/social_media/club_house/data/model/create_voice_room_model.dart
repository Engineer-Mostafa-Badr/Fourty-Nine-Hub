// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fourtyninehub/features/social_media/club_house/domain/entities/create_room_response_entity.dart';

class ZegoResponseModel extends ZegoResponseEntity {
  const ZegoResponseModel({
    required super.roomId,
    required super.status,
  });
  factory ZegoResponseModel.fromJson(Map<String, dynamic> json) =>
      ZegoResponseModel(
        roomId: json['data']['_id'],
        status: json['status'],
      );
}
