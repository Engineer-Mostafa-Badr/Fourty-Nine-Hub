import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/repository/live_repository.dart';

class SendPointListenerUseCase extends NormalUseCase<void, NoParams> {
  final LiveRepository _liveRepository;

  SendPointListenerUseCase(this._liveRepository);

  @override
  void call(NoParams params) async{
    return _liveRepository.sendPointListener();
  }
}
