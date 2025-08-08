import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chat_room_repository.dart';

class StartRecordingMessageUseCase extends UseCase<bool, String> {
  final ChatRoomRepository _chatRoomRepository;

  StartRecordingMessageUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return _chatRoomRepository.startRecording(chatId: params);
  }
}
