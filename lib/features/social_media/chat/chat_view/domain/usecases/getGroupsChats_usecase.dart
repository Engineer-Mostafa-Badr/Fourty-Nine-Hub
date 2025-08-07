import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/chat_category_entity.dart';
import '../repositories/chats_repository.dart';

class GroupsChatsUseCase extends UseCase<ChatCategoryEntity, NoParams> {
  final ChatsRepository _repo;

  GroupsChatsUseCase(this._repo);

  @override
  Future<Either<Failure, ChatCategoryEntity>> call(NoParams params) {
    return _repo.getGroups();
  }
}
