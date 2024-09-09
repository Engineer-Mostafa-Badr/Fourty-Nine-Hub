import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/seen_history_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_category_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/lock_chat_request.dart';

abstract class ChatsRepository {
  Future<Either<Failure, ChatCategoryEntity>> getChats(
      GetChatsParams params);
  Future<Either<Failure, bool>> changeChatMuteState(String chatId);
  Future<Either<Failure, bool>> changeChatToArchiveNormal(String chatId);
  Future<Either<Failure, bool>> lockChat(LockChatParams lockChatParams);
  Future<Either<Failure, bool>> unLockChat(LockChatParams lockChatParams);
  Future<Either<Failure, ChatCategoryEntity>> getGroups();
  Future<Either<Failure, List<SeenHistoryModel>>> getSeenHistory(
      {required String chatId});
}
