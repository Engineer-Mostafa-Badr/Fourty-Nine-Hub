import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../../../chat_room/data/models/seen_history_model.dart';
import '../repositories/chats_repository.dart';

class GetSeenHistoryUseCase extends UseCase<List<SeenHistoryModel>, String> {
  final ChatsRepository _repo;

  GetSeenHistoryUseCase(this._repo);

  @override
  Future<Either<Failure, List<SeenHistoryModel>>> call(String params) {
    return _repo.getSeenHistory(chatId: params);
  }
}
