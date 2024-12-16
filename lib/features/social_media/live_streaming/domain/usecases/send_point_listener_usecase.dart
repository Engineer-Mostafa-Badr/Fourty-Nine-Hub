import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/repository/live_repository.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/create_live_use_case.dart';

class SendPointListenerUseCase extends NormalUseCase<void, NoParams> {
  final LiveRepository _liveRepository;

  SendPointListenerUseCase(this._liveRepository);

  @override
  void call(NoParams params) async{
    return _liveRepository.sendPointListener();
  }
}
