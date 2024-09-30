import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/repository/live_repository.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';

class EndLiveUseCase extends UseCase<void, MeetingParams>{
  final LiveRepository _liveRepository;

  EndLiveUseCase(this._liveRepository);
  @override
  Future<Either<Failure, void>> call(MeetingParams params) {
    return _liveRepository.endLive(params);
  }

}