import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chat_room_repository.dart';

class GetChatUseCase extends UseCase<String?, GetChatParams> {
  final ChatRoomRepository _chatRoomRepository;

  GetChatUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, String?>> call(GetChatParams params) async {
    return await _chatRoomRepository.getChatPinnedMessage(params);
  }
}

class GetChatParams {
  final String chatId;

  GetChatParams({required this.chatId});
}
