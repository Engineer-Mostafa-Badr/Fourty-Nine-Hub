import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/competition/domain/entity/competition_entity.dart';
import 'package:fourtyninehub/features/competition/domain/entity/winner_competition_entity.dart';

abstract class CompetitionRepository{
  Future<Either<Failure,List<CompetitionEntity>>> fetchCompetition();
  Future<Either<Failure,List<WinnerCompetitionEntity>>> fetchWinner();
}