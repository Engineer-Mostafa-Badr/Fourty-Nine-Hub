import 'package:fourtyninehub/features/social_media/live_streaming/data/model/goal_model.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/goal_entity.dart';

import '../../domain/entity/live_create_response_entity.dart';

class LiveCreateResponseModel extends LiveCreateResponseEntity {
  const LiveCreateResponseModel({
    required super.id,
    required super.streamId,
    required super.goals,
  });
  //from json
  factory LiveCreateResponseModel.fromJson(Map<String, dynamic> json) {
    return LiveCreateResponseModel(
      id: json['stream']['roomId'],
      streamId: json['stream']['_id'],
      goals: List.from(json['streamGoals'].map((x) {
        final model = GoalModel.fromJson(x);
        print("model.toJson()${model.toJson()}");
        return GoalModel.fromJson(x);
      })),
    );
  }
}
