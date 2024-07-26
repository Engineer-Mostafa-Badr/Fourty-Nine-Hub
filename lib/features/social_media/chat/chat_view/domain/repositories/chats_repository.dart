import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/chats_request.dart';

abstract class ChatsRepository {
  Future<Either<Failure, List<ChatItemModel>>> getChats(ChatsRequestParams chatsRequestParams);
  Future<Either<Failure, bool>> changeChatMuteState(String chatId);
}
