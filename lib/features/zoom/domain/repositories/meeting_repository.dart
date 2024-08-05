import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';

import '../../../../../core/error/failure.dart';

abstract class MeetingRepository {
  Future<Either<Failure, void>> addRoom(MeetingParams params);
  Future<Either<Failure, void>> join(MeetingParams params);
  Future<Either<Failure, void>> end(MeetingParams params);
}
