// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'goal_entity.dart';
import 'members_entity.dart';

class LiveEntity extends Equatable {
  final String id;
  final String roomId;
  final String? description;
  final String title;
  final String? topicName;
  final List<GoalEntity> gift;
  final List<MembersEntity> members;

  const LiveEntity({
    required this.id,
    required this.title,
    required this.topicName,
    required this.description,
    required this.gift,
    required this.members,
    required this.roomId,
  });

  @override
  List<Object?> get props =>
      [id, title, topicName, gift, description, members, roomId];
}
