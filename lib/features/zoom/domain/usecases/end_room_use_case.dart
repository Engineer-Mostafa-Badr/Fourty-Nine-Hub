import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repositories/meeting_repository.dart';
import 'add_room_use_case.dart';

class EndRoomUseCase extends UseCase<void, MeetingParams> {
  final MeetingRepository repository;

  EndRoomUseCase(this.repository);
  @override
  Future<Either<Failure, void>> call(MeetingParams params) {
    return repository.end(params);
  }
}
