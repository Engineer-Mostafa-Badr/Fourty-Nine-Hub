import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';

class CreateAnonymousChatUseCase
    extends UseCase<bool, CreateAnonymousChatParams> {
  final ChatsRepository _repo;
  CreateAnonymousChatUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(params) {
    return _repo.createAnonymousChat(params);
  }
}

class CreateAnonymousChatParams {
  String otherUserId;

  CreateAnonymousChatParams({
    required this.otherUserId,
  });
}
