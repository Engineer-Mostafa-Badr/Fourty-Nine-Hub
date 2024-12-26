import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/repository/live_repository.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/create_live_use_case.dart';

class SendPointSocketUseCase extends UseCase<bool, PointsParams> {
  final LiveRepository _liveRepository;

  SendPointSocketUseCase(this._liveRepository);

  @override
  Future<Either<Failure, bool>> call(PointsParams params) async {
    return _liveRepository.sendPointSocket(params);
  }
}
