import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/data/model/live_create_response_model.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/data/model/live_model.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/data/model/topic_model.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live_entity.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live_create_response_entity.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/topic_entity.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/data/datasources/remote/socket/socket_data_source.dart';
import '../../../../../routes/pages.dart';
import '../../../../zoom/domain/usecases/add_room_use_case.dart';
import '../../domain/usecases/create_live_use_case.dart';

abstract class LiveDataSource {
  Future<Either<Failure, LiveCreateResponseEntity>> createLive(
      CreateLiveParams params);

  Future<Either<Failure, List<LiveEntity>>> getAllRooms(
      PaginationParams params);

  Future<Either<Failure, List<TopicEntity>>> getAllTopics();

  Future<Either<Failure, void>> endLive(MeetingParams params);

//sockets

  Future<Either<Failure, void>> editLiveGoals(GoalParams params);

  Future<Either<Failure, void>> sendLiveGoal(GoalParams params);

  Future<void> listenToSendLiveGoal(NoParams noParams);

  Future<void> sendPoints(PointsParams params);

  Future<void> requestBattle(RequestBattleParams params);

  Future<void> listenToRequestBattle(NoParams noParams);

  Future<Either<Failure, void>> acceptBattleRequest(NoParams noParams);

  Future<Either<Failure, void>> rejectBattleRequest(NoParams noParams);

  Future<Either<Failure, void>> sendGift(NoParams noParams);

  Future<Either<Failure, void>> playGiftVideo(NoParams noParams);

  Future<Either<Failure, void>> determineWinner(NoParams noParams);
}

class LiveDataSourceImpl extends LiveDataSource {
  final ApiConsumer _apiConsumer;
  final Socket _socket;

  LiveDataSourceImpl({required ApiConsumer apiConsumer, required Socket socket})
      : _socket = socket,
        _apiConsumer = apiConsumer;

  @override
  Future<Either<Failure, LiveCreateResponseEntity>> createLive(
      CreateLiveParams params) async {
    final result =
        await _apiConsumer.post(EndPoints.createLive, data: params.toJson());
    return result.fold((l) => Left(l), (r) {
      return Right(LiveCreateResponseModel.fromJson(r['data']['stream']));
    });
  }

  @override
  Future<Either<Failure, List<LiveEntity>>> getAllRooms(
      PaginationParams params) async {
    final result = await _apiConsumer
        .get(EndPoints.allLives, queryParameters: params.toJson(), headers: {
      'Accept-Language':
          AppPages.router.configuration.navigatorKey.currentContext!.isArabic
              ? 'ar'
              : 'en',
    });
    return result.fold((l) => Left(l), (r) {
      final List<LiveEntity> liveEntities =
          List.from(r['data']).map((e) => LiveModel.fromJson(e)).toList();
      return Right(liveEntities);
    });
  }

  @override
  Future<Either<Failure, List<TopicEntity>>> getAllTopics() async {
    final result = await _apiConsumer.get(EndPoints.allLiveTopics, headers: {
      'Accept-Language': AppPages
          .router.configuration.navigatorKey.currentContext!.locale
          .toString()
    });
    return result.fold((l) => Left(l), (r) {
      final List<TopicEntity> topics =
          List.from(r['data']).map((e) => TopicModel.fromJson(e)).toList();
      return Right(topics);
    });
  }

  @override
  Future<Either<Failure, void>> endLive(MeetingParams params) async {
    final result = await _apiConsumer.delete(EndPoints.endStream(params.id));
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, void>> acceptBattleRequest(NoParams noParams) {
    // TODO: implement acceptBattleRequest
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> determineWinner(NoParams noParams) {
    // TODO: implement determineWinner
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> editLiveGoals(GoalParams params) {
    // TODO: implement editLiveGoals
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> playGiftVideo(NoParams noParams) {
    // TODO: implement playGiftVideo
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> rejectBattleRequest(NoParams noParams) {
    // TODO: implement rejectBattleRequest
    throw UnimplementedError();
  }

  @override
  Future<void> requestBattle(RequestBattleParams params) async {
    _socket.connect();
    _socket.emit(SocketIOListeners.requestBattle, params.toJson);
  }

  @override
  Future<void> listenToRequestBattle(NoParams noParams) async {
    _socket.on(SocketIOListeners.requestBattle, (data) => print(data));
  }

  @override
  Future<Either<Failure, void>> sendGift(NoParams noParams) {
    // TODO: implement sendGift
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> sendLiveGoal(GoalParams params) {
    // TODO: implement sendLiveGoal
    throw UnimplementedError();
  }

  @override
  Future<void> sendPoints(PointsParams params) async {
    // TODO: connect socket
    _socket.connect();
    print('Connected');

    /// TODO: emit event
    _socket.emit(
        SocketIOListeners.sendPoints,
        jsonEncode({
          "memberId": params.memberId,
          "streamId": params.streamId,
        }));
    print(jsonEncode({
      "memberId": params.memberId,
      "streamId": params.streamId,
    }));
  }

  @override
  Future<void> listenToSendLiveGoal(NoParams noParams) async {
    _socket.connect();
    _socket.on(SocketIOListeners.sendPoints, (data) => print(data.toString()));
  }
}
