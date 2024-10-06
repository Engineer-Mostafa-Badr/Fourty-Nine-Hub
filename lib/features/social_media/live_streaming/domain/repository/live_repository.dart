import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/topic_entity.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../zoom/domain/usecases/add_room_use_case.dart';
import '../entity/live_entity.dart';
import '../entity/live_create_response_entity.dart';
import '../usecases/create_live_use_case.dart';

abstract class LiveRepository {
  Future<Either<Failure, LiveCreateResponseEntity>> createLive(
      CreateLiveParams params);
  Future<Either<Failure, List<LiveEntity>>> getAllRooms(
      PaginationParams params);
  Future<Either<Failure, List<TopicEntity>>> getAllTopics();
  Future<Either<Failure, void>> endLive(MeetingParams params);
  Future<void> sendPoints(PointsParams params);
  Future<void> listenToSendPoints(NoParams params);
}
