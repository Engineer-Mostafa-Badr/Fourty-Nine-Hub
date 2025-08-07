import '../../../../../core/abstract/use_case.dart';
import '../repository/live_repository.dart';

class ListenBattleRequestUseCase extends NormalUseCase<Future<void>, NoParams> {
  final LiveRepository _liveRepository;

  ListenBattleRequestUseCase(this._liveRepository);

  @override
  Future<void> call(NoParams params) {
    return _liveRepository.listenToRequestBattle(params);
  }
}
