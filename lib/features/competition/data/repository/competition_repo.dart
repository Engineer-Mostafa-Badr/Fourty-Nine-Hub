import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/competition/data/models/competion_model.dart';

import '../../../../core/error/failure.dart';

abstract class CompetitionRepo{
 Future<Either<Failure,CompetitionModel>> fetchCompetition();
}