import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live_entity.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live_create_response_entity.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/topic_entity.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/repository/live_repository.dart';

import '../datasource/live_datasource.dart';

class LiveRepositoryImpl extends LiveRepository {
  final LiveDataSource _liveDataSource;

  LiveRepositoryImpl({required LiveDataSource liveDataSource})
      : _liveDataSource = liveDataSource;
  @override
  Future<Either<Failure, LiveCreateResponseEntity>> createLive() {
    // TODO: implement createLive
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<LiveEntity>>> getAllRooms() {
    // TODO: implement getAllRooms
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TopicEntity>>> getAllTopics() {
    return _liveDataSource.getAllTopics();
  }
}
