import 'package:dartz/dartz.dart';
import '../../../../../../common/models/public/pagination_params.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_room_repository.dart';

class GetMessagesUseCase
    extends UseCase<List<MessageEntity>, GetMessagesParams> {
  final ChatRoomRepository _chatRoomRepository;

  GetMessagesUseCase(this._chatRoomRepository);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(GetMessagesParams params) {
    return _chatRoomRepository.getMessages(params);
  }
}

class GetMessagesParams {
  final String chatId;
  final PaginationParams pagination;

  GetMessagesParams({required this.chatId, required this.pagination});
}
