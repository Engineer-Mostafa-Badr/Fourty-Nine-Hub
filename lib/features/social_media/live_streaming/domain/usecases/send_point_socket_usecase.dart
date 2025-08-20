import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repository/live_repository.dart';
import 'create_live_use_case.dart';

class SendPointSocketUseCase extends UseCase<bool, PointsParams> {
  final LiveRepository _liveRepository;

  SendPointSocketUseCase(this._liveRepository);

  @override
  Future<Either<Failure, bool>> call(PointsParams params) async {
    return _liveRepository.sendPointSocket(params);
  }
}
