import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/chat_messgaes_model.dart';

abstract class ChatRoomRepository {
  Future<Either<Failure, ChatMessagesModel>> getChatMessages(String chatId);
}
