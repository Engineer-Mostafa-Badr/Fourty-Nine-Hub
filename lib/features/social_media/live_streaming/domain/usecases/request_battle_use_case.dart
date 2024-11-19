import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/repository/live_repository.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/create_live_use_case.dart';

class RequestBattleUseCase
    extends NormalUseCase<Future<void>, RequestBattleParams> {
  final LiveRepository _liveRepository;

  RequestBattleUseCase(this._liveRepository);

  @override
  Future<void> call(RequestBattleParams params) {
    return _liveRepository.requestBattle(params);
  }
}
