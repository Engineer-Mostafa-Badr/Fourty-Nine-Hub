import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/datasources/chats_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/chats_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/lock_chat_request.dart';

class ChatsRepositoryImplementation extends ChatsRepository {
  final ChatsRemoteDataSource _chatsRemoteDataSource;

  ChatsRepositoryImplementation(this._chatsRemoteDataSource);

  @override
  Future<Either<Failure, ChatItemModel>> getChats(
      ChatsRequestParams chatsRequestParams) {
    return _chatsRemoteDataSource.getChats(
      privacy: chatsRequestParams.privacyId!,
      categoryId: chatsRequestParams.categoryId!,
      archived: chatsRequestParams.archived!,
      isLocked: chatsRequestParams.isLocked!,
      password: chatsRequestParams.lockChatPassword,
      unRead: chatsRequestParams.isUnread!,
      isServices: chatsRequestParams.isServices!,
    );
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
    return _chatsRemoteDataSource.unLockChat(chatId: lockChatParams.chatId!,password: lockChatParams.lockChatPassword!);
  }
}
