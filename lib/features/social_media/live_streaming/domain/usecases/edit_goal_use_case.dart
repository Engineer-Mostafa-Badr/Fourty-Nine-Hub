import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';

import '../../../../../core/abstract/use_case.dart';
import '../repository/live_repository.dart';

class EditGoalUseCase extends UseCase<bool, EditGoalParams> {
  final LiveRepository _liveRepository;

  EditGoalUseCase(LiveRepository liveRepository)
      : _liveRepository = liveRepository;

  @override
  Future<Either<Failure, bool>> call(EditGoalParams params) {
    return _liveRepository.editGoal(params);
  }
}

class EditGoalParams {
  final String roomID;
  final String? goalId;
  final String? goal;

  EditGoalParams({
    required this.roomID,
    this.goalId,
    this.goal,
  });

  Map<String, dynamic> toJson() {
    return {
      "giftId": goalId,
      "goal": goal,
    };
  }
}
