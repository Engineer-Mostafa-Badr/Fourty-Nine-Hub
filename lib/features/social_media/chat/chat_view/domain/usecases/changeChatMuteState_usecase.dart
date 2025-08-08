import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chats_repository.dart';

class ChangeChatMuteStateUseCase extends UseCase<bool, String> {
  final ChatsRepository _repo;

  ChangeChatMuteStateUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.changeChatMuteState(params);
  }
}
