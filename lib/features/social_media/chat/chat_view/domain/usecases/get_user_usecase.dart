import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../authentication/domain/entities/user_entity.dart';
import '../repositories/chats_repository.dart';

class GetUserUseCase extends UseCase<UserEntity, String> {
  final ChatsRepository _repo;

  GetUserUseCase(this._repo);

  @override
  Future<Either<Failure, UserEntity>> call(String params) {
    return _repo.getUser(userId: params);
  }
}
