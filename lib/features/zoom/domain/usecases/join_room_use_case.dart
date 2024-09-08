import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repositories/meeting_repository.dart';
import 'add_room_use_case.dart';

class JoinRoomUseCase extends UseCase<bool, MeetingParams> {
  final MeetingRepository repository;

  JoinRoomUseCase(this.repository);
  @override
  Future<Either<Failure, bool>> call(MeetingParams params) {
    return repository.join(params);
  }
}
