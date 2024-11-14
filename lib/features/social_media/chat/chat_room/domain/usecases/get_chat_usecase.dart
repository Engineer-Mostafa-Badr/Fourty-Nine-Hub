import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class GetChatUseCase
    extends UseCase<String?, GetChatParams> {
  final ChatRoomRepository _chatRoomRepository;

  GetChatUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, String?>> call(GetChatParams params) async{
    return await _chatRoomRepository.getChatPinnedMessage(params);
  }
}

class GetChatParams {
  final String chatId;

  GetChatParams({required this.chatId});
}
