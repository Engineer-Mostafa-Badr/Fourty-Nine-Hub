import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_category_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';

class GroupsChatsUseCase extends UseCase<ChatCategoryEntity, NoParams> {
  final ChatsRepository _repo;

  GroupsChatsUseCase(this._repo);

  @override
  Future<Either<Failure, ChatCategoryEntity>> call(NoParams params) {
    return _repo.getGroups();
  }
}
