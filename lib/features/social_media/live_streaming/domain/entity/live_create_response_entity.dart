// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/goal_entity.dart';

class LiveCreateResponseEntity extends Equatable {
  final String id;
  final String streamId;
  final List<GoalEntity> goals;
  const LiveCreateResponseEntity(
      {required this.id, required this.streamId, required this.goals});

  @override
  List<Object> get props {
    return [id, streamId];
  }
}
