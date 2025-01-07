import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/competition/domain/entity/winner_competition_entity.dart';
import 'package:fourtyninehub/features/competition/domain/repository/competition_repository.dart';

class FetchWinnerCompetitionUseCase
    extends UseCase<List<WinnerCompetitionEntity>, NoParams> {
  final CompetitionRepository _competitionRepository;

  FetchWinnerCompetitionUseCase(this._competitionRepository);

  @override
  Future<Either<Failure, List<WinnerCompetitionEntity>>> call(
      NoParams params) async {
    return await _competitionRepository.fetchWinner();
  }
}
