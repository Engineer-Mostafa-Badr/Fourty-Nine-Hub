import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';

class SendMessageUseCase extends UseCase<bool, MessageEntity> {
  @override
  Future<Either<Failure, bool>> call(MessageEntity params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
