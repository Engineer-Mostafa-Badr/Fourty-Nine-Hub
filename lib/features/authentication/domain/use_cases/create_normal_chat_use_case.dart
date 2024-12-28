import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';

class CreateNormalChatUseCase extends UseCase<ChatEntity, CreateNormalChatParams> {
  final AuthRepository _repository;
  CreateNormalChatUseCase(this._repository);

  @override
  Future<Either<Failure, ChatEntity>> call(CreateNormalChatParams params) {
    return _repository.createNormalChat(params);
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
