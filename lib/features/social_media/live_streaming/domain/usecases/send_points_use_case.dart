import '../../../../../core/abstract/use_case.dart';
import '../repository/live_repository.dart';
import 'create_live_use_case.dart';

class SendPointsUseCase extends NormalUseCase<Future<void>, PointsParams> {
  final LiveRepository _liveRepository;

  SendPointsUseCase(this._liveRepository);
  @override
  Future<void> call(PointsParams params) {
    return _liveRepository.sendPoints(params);
  }
}
