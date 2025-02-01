import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

class AssignLabelsUsecase extends UseCase<bool, AssignLabelParams> {
  final ChatRoomRepository _repo;

  AssignLabelsUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(AssignLabelParams params) {
    return _repo.assignLabels(params);
  }
}

class AssignLabelParams {
  final String chatId;
  final List<String> labelsId;
  AssignLabelParams({required this.chatId, required this.labelsId});

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'labelsId': labelsId,
    };
  }
}
