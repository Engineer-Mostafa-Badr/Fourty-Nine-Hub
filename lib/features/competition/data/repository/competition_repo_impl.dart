import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/competition/data/data_source/competition_remote_data_source.dart';

import 'package:fourtyninehub/features/competition/domain/entity/competition_entity.dart';

import 'package:fourtyninehub/features/competition/domain/entity/winner_competition_entity.dart';

import '../../domain/repository/competition_repository.dart';

class CompetitionRepositoryImpl extends CompetitionRepository{
  final CompetitionRemoteDataSource _competitionRemoteDataSource;

  CompetitionRepositoryImpl(this._competitionRemoteDataSource);
  @override
  Future<Either<Failure, List<CompetitionEntity>>> fetchCompetition() {
    return _competitionRemoteDataSource.fetchCompetition();
  }

  @override
  Future<Either<Failure, List<WinnerCompetitionEntity>>> fetchWinner() {
    return _competitionRemoteDataSource.fetchWinner();
  }
}