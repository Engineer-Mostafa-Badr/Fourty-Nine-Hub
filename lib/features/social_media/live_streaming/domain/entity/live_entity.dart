// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/topic_entity.dart';

import '../../../tinder/data/models/gift_model.dart';
import 'goal_entity.dart';

class LiveEntity extends Equatable {
  final String id;
  final String description;
  final String title;
  final String topicName;
  final List<GoalEntity> gift;

  const LiveEntity({
    required this.id,
    required this.title,
    required this.topicName,
    required this.description,
    required this.gift,
  });

  @override
  List<Object> get props => [id, title, topicName, gift, description];
}
