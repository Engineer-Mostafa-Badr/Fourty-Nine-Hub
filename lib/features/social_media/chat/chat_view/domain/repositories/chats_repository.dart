import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/seen_history_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/chats_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/lock_chat_request.dart';

abstract class ChatsRepository {
  Future<Either<Failure, ChatItemModel>> getChats(ChatsRequestParams chatsRequestParams);
  Future<Either<Failure, bool>> changeChatMuteState(String chatId);
  Future<Either<Failure, bool>> changeChatToArchiveNormal(String chatId);
  Future<Either<Failure, bool>> lockChat(LockChatParams lockChatParams);
  Future<Either<Failure, bool>> unLockChat(LockChatParams lockChatParams);
  Future<Either<Failure, ChatItemModel>> getGroups();
  Future<Either<Failure, List<SeenHistoryModel>>> getSeenHistory({required String chatId});
}
