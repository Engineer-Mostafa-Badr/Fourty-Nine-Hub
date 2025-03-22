import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live_create_response_entity.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live_entity.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/topic_entity.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/repository/live_repository.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/edit_goal_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../domain/usecases/create_live_use_case.dart';
import '../datasource/live_datasource.dart';

class LiveRepositoryImpl extends LiveRepository {
  final LiveDataSource _liveDataSource;

  LiveRepositoryImpl({required LiveDataSource liveDataSource})
      : _liveDataSource = liveDataSource;

  @override
  Future<Either<Failure, LiveCreateResponseEntity>> createLive(
      CreateLiveParams params) {
    return _liveDataSource.createLive(params);
  }

  @override
  Future<Either<Failure, List<LiveEntity>>> getAllRooms(
      PaginationParams params) {
    return _liveDataSource.getAllRooms(params);
  }

  @override
  Future<Either<Failure, List<TopicEntity>>> getAllTopics() {
    return _liveDataSource.getAllTopics();
  }

  @override
  Future<Either<Failure, void>> endLive(MeetingParams params) =>
      _liveDataSource.endLive(params);

  @override
  Future<void> sendPoints(PointsParams params) {
    return _liveDataSource.sendPoints(params);
  }

  @override
  Future<void> listenToSendPoints(NoParams noParams) {
    return _liveDataSource.listenToSendLiveGoal(noParams);
  }

  @override
  Future<void> listenToRequestBattle(NoParams noParams) {
    return _liveDataSource.listenToRequestBattle(noParams);
  }

  @override
  Future<void> requestBattle(RequestBattleParams params) {
    return _liveDataSource.requestBattle(params);
  }

  @override
  Future<Either<Failure, bool>> editGoal(EditGoalParams params) {
    return _liveDataSource.editGoal(params);
  }

  @override
  Future<Either<Failure, bool>> sendPointSocket(PointsParams params) {
    return _liveDataSource.sendPointSocket(params);
  }

  @override
  void sendPointListener() {
    return _liveDataSource.sendPointListener();
  }
}
