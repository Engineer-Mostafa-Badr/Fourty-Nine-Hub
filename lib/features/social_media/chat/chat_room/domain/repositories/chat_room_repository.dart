import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/delete_message_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';

abstract class ChatRoomRepository {
  Future<Either<Failure, bool>> deleteChatMessage(
    DeleteMessageParams deleteMessageParams,
  );

  Future<Either<Failure, bool>> sendMessage(SendMessageParams params);
  Future<Either<Failure, List<MessageEntity>>> getMessages(GetMessagesParams params);

  void listenToNewMessages(Function(MessageEntity message) params);

  void stopListenToMessages();
}
