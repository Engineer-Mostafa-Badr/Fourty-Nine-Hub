import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';

class GetUserUseCase extends UseCase<UserEntity, String> {
  final ChatsRepository _repo;

  GetUserUseCase(this._repo);

  @override
  Future<Either<Failure, UserEntity>> call(String params) {
    return _repo.getUser(userId: params);
  }
}
