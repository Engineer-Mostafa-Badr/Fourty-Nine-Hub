import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

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
