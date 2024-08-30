import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';

class GroupsChatsUseCase extends UseCase<ChatItemModel, NoParams> {
  final ChatsRepository _repo;

  GroupsChatsUseCase(this._repo);

  @override
  Future<Either<Failure, ChatItemModel>> call(NoParams params) {
    return _repo.getGroups();
  }
}
