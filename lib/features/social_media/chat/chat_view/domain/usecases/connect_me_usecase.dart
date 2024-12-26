import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';

class ConnectMeUseCase extends UseCase<bool, NoParams> {
  final ChatsRepository _repo;

  ConnectMeUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repo.connectMe();
  }
}
