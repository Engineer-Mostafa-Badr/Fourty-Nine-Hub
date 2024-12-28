import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/clear_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/delete_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_one_time_view_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_pin_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_recording_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_typing_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_unpin_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_message_as_seen_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_messages_as_delivered_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/pin_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/set_record_as_listened.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/unpin_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/update_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';

abstract class ChatRoomRepository {
  Future<Either<Failure, bool>> sendMessage(SendMessageParams params);
Future<Either<Failure, bool>> updateChat(UpdateChatParams params);

  Future<Either<Failure, bool>> deleteMessage(DeleteMessageParams params);
  Future<Either<Failure, bool>> startTyping({required String chatId});
  Future<Either<Failure, bool>> stopTyping({required String chatId});

  Future<Either<Failure, bool>> clearChat(ClearChatParams params);

  void listenToTypingStatus(Function(ListenToTypingParams) params);

  Future<Either<Failure, bool>> startRecording({required String chatId});
  Future<Either<Failure, bool>> stopRecording({required String chatId});
  void listenToRecordingStatus(Function(ListenToRecordingParams) params);
void listenToDeleteMessage(Function(DeleteMessageParams) params);
  Future<Either<Failure, MessageEntity>> getOneTimeViewMessage(
      GetOneTimeViewMessageParams params);

  Future<Either<Failure, List<MessageEntity>>> getMessages(
      GetMessagesParams params);

  Future<Either<Failure, String?>> getChatPinnedMessage(GetChatParams params);
  void listenToNewMessages(Function(MessageEntity message) params);

  void listenToRecordListened(
      Function(SetRecordAsListenedParams setRecordAsListenedParams) params);

  void listenToSeenOneTimeViewMessage(Function(MessageEntity message) params);

  void stopListenToMessages();

  Future<Either<Failure, bool>> markMessageAsSeen(
      MarkMessageAsSeenParams params);

  Future<Either<Failure, bool>> pinMessage(PinMessageParams params);
  Future<Either<Failure, bool>> unPinMessage(UnPinMessageParams params);

  Future<Either<Failure, bool>> setRecordAsListened(
      SetRecordAsListenedParams params);

  Future<Either<Failure, bool>> markMessageAsDelivered(
      MarkMessagesAsDeliveredParams params);

  void listenToPinMessage(Function(ListenToPinMessageParams params) params);
  void listenToUnPinMessage(Function(ListenToUnPinMessageParams params) params);

  void listenToSeenStatus(Function(List<MessageEntity> messages) params);

  void stopListenToSeenStatus();

  void listenToDeliveredStatus(Function(String chatId) params);

  void listenToClearChatStatus(Function(String chatId) params);

  void stopListenToDeliveredStatus();
}
