import '../../domain/entity/live_create_response_entity.dart';

class LiveCreateResponseModel extends LiveCreateResponseEntity {
  const LiveCreateResponseModel({
    required super.id,
    required super.streamId,
  });
  //from json
  factory LiveCreateResponseModel.fromJson(Map<String, dynamic> json) {
    return LiveCreateResponseModel(
      id: json['roomId'],
      streamId: json['_id'],
    );
  }
}
