import '../../domain/entity/live_create_response_entity.dart';

class LiveCreateResponseModel extends LiveCreateResponseEntity {
  const LiveCreateResponseModel({
    required super.id,
  });
  //from json
  factory LiveCreateResponseModel.fromJson(Map<String, dynamic> json) {
    return LiveCreateResponseModel(
      id: json['_id'],
    );
  }
}
