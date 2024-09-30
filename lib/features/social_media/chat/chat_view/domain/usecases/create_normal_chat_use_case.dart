import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';

class CreateNormalChatUseCase extends UseCase<bool, CreateNormalChatParams> {
  final ChatsRepository _repo;
  CreateNormalChatUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(CreateNormalChatParams params) {
    return _repo.createNormalChat(params);
  }
}

class CreateNormalChatParams {
  String categoryId;
  String otherUserId;

  CreateNormalChatParams({
    required this.categoryId,
    required this.otherUserId,
  });
}
