import 'package:fourtyninehub/features/social_media/live_streaming/data/model/goal_model.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live_entity.dart';

class LiveModel extends LiveEntity {
  const LiveModel({
    required super.id,
    required super.title,
    required super.topicName,
    required super.gift,
    required super.description,
  });

  //from json
  factory LiveModel.fromJson(Map<String, dynamic> json) {
    return LiveModel(
      id: json['_id'],
      title: json['title'],
      topicName: json['topicName'],
      gift: List.from(json['goals']).map((e) => GoalModel.fromJson(e)).toList(),
      description: json['description'],
    );
  }
}
