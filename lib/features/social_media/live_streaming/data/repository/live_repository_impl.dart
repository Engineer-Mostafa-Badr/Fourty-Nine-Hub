import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live_create_response.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/repository/live_repository.dart';

import '../datasource/live_datasource.dart';

class LiveRepositoryImpl extends LiveRepository{
  final LiveDataSource _liveDataSource;

  LiveRepositoryImpl({required LiveDataSource liveDataSource}) : _liveDataSource = liveDataSource;
  @override
  Future<Either<Failure, LiveCreateResponse>> createLive() {
    // TODO: implement createLive
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<LiveEntity>>> getAllRooms() {
    // TODO: implement getAllRooms
    throw UnimplementedError();
  }
}