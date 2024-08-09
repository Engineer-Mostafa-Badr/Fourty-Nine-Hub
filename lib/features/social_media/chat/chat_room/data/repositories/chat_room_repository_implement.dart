import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/datasources/chat_message_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/delete_message_request.dart';

import '../models/chat_messgaes_model.dart';

class ChatRoomRepositoryImplementation extends ChatRoomRepository {
  final ChatRemoteDataSource _chatRemoteDataSource;

  ChatRoomRepositoryImplementation(this._chatRemoteDataSource);

  @override
  Future<Either<Failure, ChatMessagesModel>> getChatMessages(String chatId) {
    return _chatRemoteDataSource.getChatMessages(chatId: chatId);
  }

  @override
  Future<Either<Failure, bool>> deleteChatMessage(
      DeleteMessageParams deleteMessageParams) {
    return _chatRemoteDataSource.deleteMessage(
      chatId: deleteMessageParams.chatId!,
      messageId: deleteMessageParams.messageId!,
    );
  }
}
