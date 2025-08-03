import '../../../../../core/abstract/use_case.dart';
import '../repository/live_repository.dart';
import 'create_live_use_case.dart';

class RequestBattleUseCase
    extends NormalUseCase<Future<void>, RequestBattleParams> {
  final LiveRepository _liveRepository;

  RequestBattleUseCase(this._liveRepository);

  @override
  Future<void> call(RequestBattleParams params) {
    return _liveRepository.requestBattle(params);
  }
}
