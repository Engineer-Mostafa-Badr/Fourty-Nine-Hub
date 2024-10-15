import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../tinder/data/models/gift_model.dart';
import '../entity/live_create_response_entity.dart';
import '../repository/live_repository.dart';

class CreateLiveUseCase
    extends UseCase<LiveCreateResponseEntity, CreateLiveParams> {
  final LiveRepository _liveRepository;

  CreateLiveUseCase(LiveRepository liveRepository)
      : _liveRepository = liveRepository;

  @override
  Future<Either<Failure, LiveCreateResponseEntity>> call(
      CreateLiveParams params) {
    return _liveRepository.createLive(params);
  }
}

class CreateLiveParams {
  final String title;
  final String roomID;
  final String? topicId;
  final String? description;
  final List<GoalParams>? goals;

  CreateLiveParams(
      {required this.title,required this.roomID, this.topicId, this.description, this.goals});

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "topic": topicId,
      "roomId":roomID,
      "description": description,
      "goals": goals
    };
  }
}

class GoalParams {
  final String giftId;
  final int amount;

  GoalParams({required this.giftId, required this.amount});

  Map<String, dynamic> toJson() {
    return {"giftId": giftId, "goal": amount};
  }
}

class PointsParams {
  final String streamId;
  final String memberId;

  PointsParams({required this.streamId, required this.memberId});

  Map<String, dynamic> toJson() {
    return {"streamId": streamId, "memberId": memberId};
  }}
  class RequestBattleParams {
    final String streamId;
    final String receiverId;

    RequestBattleParams({required this.streamId, required this.receiverId});

    Map<String, dynamic> toJson() {
      return {"streamId": streamId, "receiverId": receiverId};
    }
  }
