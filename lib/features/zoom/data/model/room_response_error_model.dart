import 'package:fourtyninehub/features/zoom/domain/entities/room_response.dart';

class RoomResponseErrorModel extends RoomResponseError {
  const RoomResponseErrorModel(
      {required super.message, required super.success});
  factory RoomResponseErrorModel.fromJson(Map<String, dynamic> map) {
    return RoomResponseErrorModel(
      message: map['error']['message'] as String,
      success: map['success'] as bool,
    );
  }
}
