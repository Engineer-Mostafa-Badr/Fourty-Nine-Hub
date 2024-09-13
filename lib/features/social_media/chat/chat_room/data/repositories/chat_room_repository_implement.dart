import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/datasources/local/chat_message_local_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/datasources/remote/chat_message_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/delete_message_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_message_as_seen_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';

class ChatRoomRepositoryImplementation extends ChatRoomRepository {
  final MessagesRemoteDataSource _chatRemoteDataSource;
  final MessagesLocalDataSource _chatLocalDataSource;

  ChatRoomRepositoryImplementation(
      this._chatRemoteDataSource, this._chatLocalDataSource);

  @override
  Future<Either<Failure, bool>> deleteChatMessage(
      DeleteMessageParams deleteMessageParams) {
    return _chatRemoteDataSource.deleteMessage(
      chatId: deleteMessageParams.chatId!,
      messageId: deleteMessageParams.messageId!,
    );
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
      GetMessagesParams params) {
    return _chatRemoteDataSource.getMessages(params);
  }

  @override
  Future<Either<Failure, bool>> sendMessage(SendMessageParams params) {
    return _chatRemoteDataSource.sendMessage(params);
  }

  @override
  void listenToNewMessages(Function(MessageEntity message) params) {
    return _chatRemoteDataSource.listenToNewMessages(params);
  }

  @override
  void stopListenToMessages() {
    _chatRemoteDataSource.stopListenToMessages();
  }

  @override
  Future<Either<Failure, bool>> markMessageAsSeen(MarkMessageAsSeenParams params) {
 return _chatRemoteDataSource.markMessageAsSeen(params);
  }

  @override
  void listenToSeenStatus(Function(List<MessageEntity> messages) params) {
    _chatRemoteDataSource.listenToSeenStatus(params);
  }

  @override
  void stopListenToSeenStatus() {
    _chatRemoteDataSource.stopListenToSeenStatus();
  }

  @override
  void listenToDeliveredStatus(Function(List<MessageEntity> messages) params) {
    _chatRemoteDataSource.listenToDeliveredStatus(params);
  }

  @override
  void stopListenToDeliveredStatus() {
    _chatRemoteDataSource.stopListenToDeliveredStatus();
  }
}
