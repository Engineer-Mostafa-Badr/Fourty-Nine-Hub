import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/goal_entity.dart';

class GoalModel extends GoalEntity {
  const GoalModel(
      {required super.id,
      required super.giftId,
      required super.goal,
      required super.currentValue});

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
        id: json['_id'],
        giftId: json['gift'],
        goal: json['goal'],
        currentValue: json['currentValue']);
  }
}
