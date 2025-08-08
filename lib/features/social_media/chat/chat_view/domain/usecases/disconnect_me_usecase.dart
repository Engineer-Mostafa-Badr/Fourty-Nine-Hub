import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chats_repository.dart';

class DisconnectMeUseCase extends UseCase<bool, NoParams> {
  final ChatsRepository _repo;

  DisconnectMeUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repo.disconnectMe();
  }
}
