import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chat_room_repository.dart';

class StartTypingMessageUseCase extends UseCase<bool, String> {
  final ChatRoomRepository _chatRoomRepository;

  StartTypingMessageUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return _chatRoomRepository.startTyping(chatId: params);
  }
}
