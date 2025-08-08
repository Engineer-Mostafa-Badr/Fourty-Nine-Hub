import 'dart:async';

import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/message_entity.dart';
import '../usecases/assign_labels_usecase.dart';
import '../usecases/clear_chat_usecase.dart';
import '../usecases/create_lable_usecase.dart';
import '../usecases/delete_message_usecase.dart';
import '../usecases/get_chat_usecase.dart';
import '../usecases/get_lables_usecase.dart';
import '../usecases/get_messages_usecase.dart';
import '../usecases/get_one_time_view_message_usecase.dart';
import '../usecases/listen_to_pin_message_usecase.dart';
import '../usecases/listen_to_recording_usecase.dart';
import '../usecases/listen_to_typing_usecase.dart';
import '../usecases/listen_to_unpin_message_usecase.dart';
import '../usecases/mark_message_as_seen_usecase.dart';
import '../usecases/mark_messages_as_delivered_usecase.dart';
import '../usecases/pin_message_usecase.dart';
import '../usecases/send_message_usecase.dart';
import '../usecases/set_record_as_listened.dart';
import '../usecases/unpin_message_usecase.dart';
import '../usecases/update_chat_usecase.dart';

abstract class ChatRoomRepository {
  Future<Either<Failure, bool>> sendMessage(SendMessageParams params);
  Future<Either<Failure, bool>> updateChat(UpdateChatParams params);

  Future<Either<Failure, bool>> deleteMessage(DeleteMessageParams params);
  Future<Either<Failure, bool>> startTyping({required String chatId});
  Future<Either<Failure, bool>> stopTyping({required String chatId});

  Future<Either<Failure, bool>> clearChat(ClearChatParams params);
  Future<Either<Failure, bool>> createLable(CreatLabelParams params);
  Future<Either<Failure, bool>> assignLabels(AssignLabelParams params);

  void listenToTypingStatus(Function(ListenToTypingParams) params);

  Future<Either<Failure, bool>> startRecording({required String chatId});
  Future<Either<Failure, bool>> stopRecording({required String chatId});
  void listenToRecordingStatus(Function(ListenToRecordingParams) params);
  void listenToDeleteMessage(Function(DeleteMessageParams) params);
  Future<Either<Failure, MessageEntity>> getOneTimeViewMessage(
      GetOneTimeViewMessageParams params);

  Future<Either<Failure, List<MessageEntity>>> getMessages(
      GetMessagesParams params);
Future<Either<Failure, List<GetLablesEntity>>> getLables(GetLablesParams params);
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
