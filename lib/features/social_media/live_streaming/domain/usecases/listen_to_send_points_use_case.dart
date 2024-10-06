import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/repository/live_repository.dart';

class ListenToSendPointsUseCase extends NormalUseCase<Future<void>, NoParams> {
  final LiveRepository _liveRepository;

  ListenToSendPointsUseCase(this._liveRepository);

  @override
  Future<void> call(NoParams noParams) {
    return _liveRepository.listenToSendPoints(noParams);
  }
}
