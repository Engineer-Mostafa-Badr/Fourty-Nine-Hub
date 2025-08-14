import '../../../../../core/abstract/use_case.dart';
import '../repository/live_repository.dart';

class ListenToSendPointsUseCase extends NormalUseCase<Future<void>, NoParams> {
  final LiveRepository _liveRepository;

  ListenToSendPointsUseCase(this._liveRepository);

  @override
  Future<void> call(NoParams noParams) {
    return _liveRepository.listenToSendPoints(noParams);
  }
}
