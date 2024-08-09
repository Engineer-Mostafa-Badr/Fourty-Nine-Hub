import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/chats_request.dart';

class GetChatsUseCase extends UseCase<ChatItemModel, ChatsRequestParams> {
  final ChatsRepository _repo;

  GetChatsUseCase(this._repo);

  @override
  Future<Either<Failure, ChatItemModel>> call(ChatsRequestParams params) {
    return _repo.getChats(params);
  }
}
