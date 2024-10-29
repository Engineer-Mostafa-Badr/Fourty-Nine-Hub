import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_recording_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_typing_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_message_as_seen_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_messages_as_delivered_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';

abstract class ChatRoomRepository {
  Future<Either<Failure, bool>> sendMessage(SendMessageParams params);

  Future<Either<Failure, bool>> startTyping({required String chatId});
  Future<Either<Failure, bool>> stopTyping({required String chatId});
  void listenToTypingStatus(Function(ListenToTypingParams) params);

  Future<Either<Failure, bool>> startRecording({required String chatId});
  Future<Either<Failure, bool>> stopRecording({required String chatId});
  void listenToRecordingStatus(Function(ListenToRecordingParams) params);

  Future<Either<Failure, List<MessageEntity>>> getMessages(
      GetMessagesParams params);

  void listenToNewMessages(Function(MessageEntity message) params);

  void stopListenToMessages();

  Future<Either<Failure, bool>> markMessageAsSeen(
      MarkMessageAsSeenParams params);

  Future<Either<Failure, bool>> markMessageAsDelivered(
      MarkMessagesAsDeliveredParams params);

  void listenToSeenStatus(Function(List<MessageEntity> messages) params);

  void stopListenToSeenStatus();

  void listenToDeliveredStatus(Function(String chatId) params);

  void stopListenToDeliveredStatus();
}
