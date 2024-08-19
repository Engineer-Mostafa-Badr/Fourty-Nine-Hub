import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/chat_messgaes_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/delete_message_request.dart';

abstract class ChatRoomRepository {
  Future<Either<Failure, ChatMessagesModel>> getChatMessages(String chatId);

  Future<Either<Failure, bool>> deleteChatMessage(
    DeleteMessageParams deleteMessageParams,
  );
}
