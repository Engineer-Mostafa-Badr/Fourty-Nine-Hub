import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live_create_response.dart';

abstract class LiveDataSource {
  Future<Either<Failure, LiveCreateResponse>> createLive();
  Future<Either<Failure, List<LiveEntity>>> getAllRooms();
}

class LiveDataSourceImpl extends LiveDataSource {
  final ApiConsumer _apiConsumer;

  LiveDataSourceImpl({required ApiConsumer apiConsumer})
      : _apiConsumer = apiConsumer;
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
