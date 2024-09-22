import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/topic_entity.dart';

import '../../../../../core/error/failure.dart';
import '../entity/live_entity.dart';
import '../entity/live_create_response_entity.dart';

abstract class LiveRepository {
  Future<Either<Failure, LiveCreateResponseEntity>> createLive();
  Future<Either<Failure, List<LiveEntity>>> getAllRooms();
  Future<Either<Failure, List<TopicEntity>>> getAllTopics();
}
