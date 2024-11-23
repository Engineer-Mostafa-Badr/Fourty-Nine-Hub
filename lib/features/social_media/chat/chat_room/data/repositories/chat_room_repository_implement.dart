import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/datasources/local/chat_message_local_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/datasources/remote/chat_message_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/clear_chat_usecase.dart';
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

class ChatRoomRepositoryImplementation extends ChatRoomRepository {
  final MessagesRemoteDataSource _chatRemoteDataSource;
  final MessagesLocalDataSource _chatLocalDataSource;

  ChatRoomRepositoryImplementation(
      this._chatRemoteDataSource, this._chatLocalDataSource);

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
  Future<Either<Failure, bool>> markMessageAsSeen(
      MarkMessageAsSeenParams params) {
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
  void listenToDeliveredStatus(Function(String chatId) params) {
    _chatRemoteDataSource.listenToDeliveredStatus(params);
  }

  @override
  void stopListenToDeliveredStatus() {
    _chatRemoteDataSource.stopListenToDeliveredStatus();
  }

  @override
  Future<Either<Failure, bool>> markMessageAsDelivered(
      MarkMessagesAsDeliveredParams params) {
    return _chatRemoteDataSource.markMessageAsDelivered(params);
  }

  @override
  Future<Either<Failure, bool>> startTyping({required String chatId}) {
    return _chatRemoteDataSource.startTyping(chatId: chatId);
  }

  @override
  Future<Either<Failure, bool>> stopTyping({required String chatId}) {
    return _chatRemoteDataSource.stopTyping(chatId: chatId);
  }

  @override
  void listenToTypingStatus(Function(ListenToTypingParams p1) params) {
    _chatRemoteDataSource.listenToTypingStatus(params);
  }

  @override
  void listenToRecordingStatus(Function(ListenToRecordingParams p1) params) {
    _chatRemoteDataSource.listenToRecordingStatus(params);
  }

  @override
  Future<Either<Failure, bool>> startRecording({required String chatId}) {
    return _chatRemoteDataSource.startRecording(chatId: chatId);
  }

  @override
  Future<Either<Failure, bool>> stopRecording({required String chatId}) {
    return _chatRemoteDataSource.stopRecording(chatId: chatId);
  }

  @override
  Future<Either<Failure, bool>> clearChat(ClearChatParams params) {
    return _chatRemoteDataSource.clearChat(params);
  }

  @override
  Future<Either<Failure, MessageEntity>> getOneTimeViewMessage(
      GetOneTimeViewMessageParams params) {
    return _chatRemoteDataSource.getOneTimeViewMessage(params);
  }

  @override
  void listenToSeenOneTimeViewMessage(Function(MessageEntity message) params) {
    _chatRemoteDataSource.listenToSeenOneTimeViewMessage(params);
  }

  @override
  Future<Either<Failure, bool>> setRecordAsListened(
      SetRecordAsListenedParams params) {
    return _chatRemoteDataSource.setRecordAsListened(params);
  }

  @override
  void listenToRecordListened(
      Function(SetRecordAsListenedParams setRecordAsListenedParams) params) {
    _chatRemoteDataSource.listenToRecordListened(params);
  }

  @override
  void listenToClearChatStatus(Function(String chatId) params) {
    _chatRemoteDataSource.listenToClearChatStatus(params);
  }

  @override
  Future<Either<Failure, bool>> pinMessage(PinMessageParams params) {
    return _chatRemoteDataSource.pinMessage(params);
  }

  @override
  Future<Either<Failure, bool>> unPinMessage(UnPinMessageParams params) {
    return _chatRemoteDataSource.unPinMessage(params);
  }

  @override
  void listenToPinMessage(Function(ListenToPinMessageParams params) params) {
    _chatRemoteDataSource.listenToPinMessage(params);
  }

  @override
  void listenToUnPinMessage(
      Function(ListenToUnPinMessageParams params) params) {
    _chatRemoteDataSource.listenToUnPinMessage(params);
  }

  @override
  Future<Either<Failure, String?>> getChatPinnedMessage(
      GetChatParams params) async {
    return await _chatRemoteDataSource.getChatPinnedMessage(params);
  }
}
