import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entity/live.dart';
import '../../domain/entity/live_create_response.dart';

abstract class LiveRepository {
  Future<Either<Failure, LiveCreateResponse>> createLive();
  Future<Either<Failure, List<LiveEntity>>> getAllRooms();
}
