import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/competition/domain/entity/competition_entity.dart';
import 'package:fourtyninehub/features/competition/domain/repository/competition_repository.dart';

class FetchCompetitionUseCase
    extends UseCase<List<CompetitionEntity>, NoParams> {
  final CompetitionRepository _competitionRepository;

  FetchCompetitionUseCase(this._competitionRepository);

  @override
  Future<Either<Failure, List<CompetitionEntity>>> call(NoParams params) async {
    return await _competitionRepository.fetchCompetition();
  }
}
