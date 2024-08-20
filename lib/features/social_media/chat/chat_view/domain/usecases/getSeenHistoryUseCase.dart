import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/seen_history_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';

class GetSeenHistoryUseCase extends UseCase<List<SeenHistoryModel>, String> {
  final ChatsRepository _repo;

  GetSeenHistoryUseCase(this._repo);

  @override
  Future<Either<Failure, List<SeenHistoryModel>>> call(String params) {
    return _repo.getSeenHistory(chatId: params);
  }
}
