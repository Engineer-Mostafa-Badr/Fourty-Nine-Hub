import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/seen_history_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_category_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chat_last_seen_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_online_offline_status_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/lock_chat_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/show_deleted_message_usecase.dart';

abstract class ChatsRepository {
  Future<Either<Failure, List<ChatEntity>>> getChats(GetChatsParams params);
  Future<Either<Failure, bool>> changeChatMuteState(String chatId);
  Future<Either<Failure, MessageEntity>> showDeletedMessage(ShowDeletedMessageParams showDeletedMessageParams);
  Future<Either<Failure, bool>> changeChatToArchiveNormal(String chatId);
  Future<Either<Failure, List<LastSeenChatsEntity>>> getChatLastSeen(String chatId);
  Future<Either<Failure, bool>> deleteChat({required String chatId});
  Future<Either<Failure, bool>> pinChat({required String chatId});
  Future<Either<Failure, bool>> unPinChat({required String chatId});
  Future<Either<Failure, bool>> lockChat(LockChatParams lockChatParams);
  Future<Either<Failure, UserEntity>> getUser({required String userId});
  Future<Either<Failure, GetOnlineOfflineStatusEntity>> getOnlineOfflineStatus({required String userId});
  Future<Either<Failure, bool>> unLockChat(LockChatParams lockChatParams);
  Future<Either<Failure, ChatCategoryEntity>> getGroups();
  Future<Either<Failure, bool>> recoverDeletedChats();
  Future<Either<Failure, bool>> connectMe();
  Future<Either<Failure, bool>> disconnectMe();
  Future<Either<Failure, List<SeenHistoryModel>>> getSeenHistory(
      {required String chatId});

  

  void listenToNewChats(Function(ChatEntity) params);
  void stopListenToNewChats();
}
