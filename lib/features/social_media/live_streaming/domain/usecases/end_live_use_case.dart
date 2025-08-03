import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repository/live_repository.dart';
import '../../../../zoom/domain/usecases/add_room_use_case.dart';

class EndLiveUseCase extends UseCase<void, MeetingParams> {
  final LiveRepository _liveRepository;

  EndLiveUseCase(this._liveRepository);
  @override
  Future<Either<Failure, void>> call(MeetingParams params) {
    return _liveRepository.endLive(params);
  }
}
