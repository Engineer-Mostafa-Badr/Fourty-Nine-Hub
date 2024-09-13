import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/seen_history_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/datasources/chats_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_category_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/lock_chat_request.dart';

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
}
