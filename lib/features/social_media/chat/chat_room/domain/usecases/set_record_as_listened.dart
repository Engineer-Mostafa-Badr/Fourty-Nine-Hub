import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chat_room_repository.dart';

class SetRecordAsListenedUseCase
    extends UseCase<bool, SetRecordAsListenedParams> {
  final ChatRoomRepository _chatRoomRepository;

  SetRecordAsListenedUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, bool>> call(SetRecordAsListenedParams params) {
    return _chatRoomRepository.setRecordAsListened(params);
  }
}

class SetRecordAsListenedParams {
  String chatId;
  String messageId;
  SetRecordAsListenedParams({required this.chatId, required this.messageId});
}
