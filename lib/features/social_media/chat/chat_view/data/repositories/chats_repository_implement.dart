import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/seen_history_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/datasources/chats_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_category_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_anonymous_chat_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_normal_chat_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chat_last_seen_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_online_offline_status_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/lock_chat_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/show_deleted_message_usecase.dart';

class ChatsRepositoryImplementation extends ChatsRepository {
  final ChatsRemoteDataSource _chatsRemoteDataSource;

  ChatsRepositoryImplementation(this._chatsRemoteDataSource);

  @override
  Future<Either<Failure, List<ChatEntity>>> getChats(GetChatsParams params) {
    return _chatsRemoteDataSource.getChats(params);
  }

  @override
  Future<Either<Failure, bool>> changeChatMuteState(String chatId) {
    return _chatsRemoteDataSource.changeChatMuteState(chatId: chatId);
  }

  @override
  Future<Either<Failure, bool>> changeChatToArchiveNormal(String chatId) {
    return _chatsRemoteDataSource.changeChatToArchiveOrToNormal(chatId: chatId);
  }

  @override
  Future<Either<Failure, bool>> lockChat(LockChatParams lockChatParams) {
    return _chatsRemoteDataSource.lockChat(
        chatId: lockChatParams.chatId!,
        lockChatPassword: lockChatParams.lockChatPassword);
  }

  @override
  Future<Either<Failure, bool>> unLockChat(LockChatParams lockChatParams) {
    return _chatsRemoteDataSource.unLockChat(
        chatId: lockChatParams.chatId!,
        password: lockChatParams.lockChatPassword!);
  }

  @override
  Future<Either<Failure, ChatCategoryEntity>> getGroups() {
    // TODO: implement getGroups
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SeenHistoryModel>>> getSeenHistory(
      {required String chatId}) {
    // TODO: implement getSeenHistory
    throw UnimplementedError();
  }

  

  @override
  void listenToNewChats(Function(ChatEntity) params) {
    _chatsRemoteDataSource.listenToNewChats(params);
  }

  @override
  void stopListenToNewChats() {
    _chatsRemoteDataSource.stopListenToNewChats();
  }
  
  @override
  Future<Either<Failure, bool>> deleteChat({required String chatId}) {
    return _chatsRemoteDataSource.deleteChat(chatId: chatId);
  }
  
  @override
  Future<Either<Failure, bool>> pinChat({required String chatId}) {
   return _chatsRemoteDataSource.pinChat(chatId: chatId);
  }
  
  @override
  Future<Either<Failure, bool>> unPinChat({required String chatId}) {
    return _chatsRemoteDataSource.unPinChat(chatId: chatId);
  }

  @override
  Future<Either<Failure, UserEntity>> getUser({required String userId}) {
    return _chatsRemoteDataSource.getUser(userId: userId);
  }

  @override
  Future<Either<Failure, MessageEntity>> showDeletedMessage(ShowDeletedMessageParams showDeletedMessageParams) {
    return _chatsRemoteDataSource.showDeletedMessage( showDeletedMessageParams);
  }

  @override
  Future<Either<Failure, List<LastSeenChatsEntity>>> getChatLastSeen(String chatId) {
    return _chatsRemoteDataSource.getChatLastSeen(chatId);
  }
  
  @override
  Future<Either<Failure, bool>> recoverDeletedChats() {
    return _chatsRemoteDataSource.recoverDeletedChats();
  }
  
  @override
  Future<Either<Failure, bool>> connectMe() {
    return _chatsRemoteDataSource.connectMe();
  }
  
  @override
  Future<Either<Failure, bool>> disconnectMe() {
    return _chatsRemoteDataSource.disconnectMe();
  }

  @override
  Future<Either<Failure, GetOnlineOfflineStatusEntity>> getOnlineOfflineStatus({required String userId}) {
    return _chatsRemoteDataSource.getOnlineOfflineStatus(userId: userId);
  }
}
