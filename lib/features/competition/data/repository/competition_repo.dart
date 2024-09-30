import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/competition/data/models/competion_model.dart';

import '../../../../core/error/failure.dart';
import '../models/winners_model.dart';

abstract class CompetitionRepo {
  Future<Either<Failure, CompetitionModel>> fetchCompetition();
  Future<Either<Failure, WinnersModel>> fetchWinners();
}
