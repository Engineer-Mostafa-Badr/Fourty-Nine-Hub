import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/repository/live_repository.dart';

class ListenBattleRequestUseCase extends NormalUseCase<Future<void>, NoParams> {
  final LiveRepository _liveRepository;

  ListenBattleRequestUseCase(this._liveRepository);

  @override
  Future<void> call(NoParams params) {
    return _liveRepository.listenToRequestBattle(params);
  }
}
