import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/chat_messgaes_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class GetChatMessagesUseCase extends UseCase<ChatMessagesModel, String> {
  final ChatRoomRepository _repo;

  GetChatMessagesUseCase(this._repo);

  @override
  Future<Either<Failure, ChatMessagesModel>> call(String params) {
    return _repo.getChatMessages(params);
  }
}
