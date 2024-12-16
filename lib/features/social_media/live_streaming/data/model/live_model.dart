import 'package:fourtyninehub/features/social_media/live_streaming/data/model/goal_model.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live_entity.dart';

import 'members_model.dart';

class LiveModel extends LiveEntity {
  const LiveModel({
    required super.id,
    required super.title,
    required super.topicName,
    required super.ownerId,
    required super.gift,
    required super.description,
    required super.members,
    required super.roomId,
  });

  //from json
  factory LiveModel.fromJson(Map<String, dynamic> json) {
    return LiveModel(
      id: json['_id'],
      title: json['title'],
      topicName: json['topicName'],
      ownerId: json['owner']['_id']??'',
      gift: List.from(json['goals']).map((e) => GoalModel.fromJson(e)).toList(),
      description: json['description'],
      members: List.from(json['members'])
          .map((e) => MembersModel.fromJson(e))
          .toList(),
      roomId: json['roomId'],
    );
  }
}
