import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';

class CreateAnonymousChatUseCase
    extends UseCase<ChatEntity, CreateAnonymousChatParams> {
  final AuthRepository _repository;
  CreateAnonymousChatUseCase(this._repository);

  @override
  Future<Either<Failure, ChatEntity>> call(params) {
    return _repository.createAnonymousChat(params);
  }
}

class CreateAnonymousChatParams {
  String otherUserId;

  CreateAnonymousChatParams({
    required this.otherUserId,
  });
}
