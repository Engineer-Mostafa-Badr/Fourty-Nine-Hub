import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/topic_entity.dart';

class TopicModel extends TopicEntity {
  const TopicModel({required super.name, required super.id});
  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(id: json['_id'], name: json['name']);
  }
}
