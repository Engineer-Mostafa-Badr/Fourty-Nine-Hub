import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class MarkMessageAsSeenUseCase extends UseCase<bool, MarkMessageAsSeenParams> {
  final ChatRoomRepository _chatRoomRepository;

  MarkMessageAsSeenUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, bool>> call(MarkMessageAsSeenParams params) {
    return _chatRoomRepository.markMessageAsSeen(params);
  }
}

class MarkMessageAsSeenParams {
  final String chatId;
  MarkMessageAsSeenParams({required this.chatId});
}
