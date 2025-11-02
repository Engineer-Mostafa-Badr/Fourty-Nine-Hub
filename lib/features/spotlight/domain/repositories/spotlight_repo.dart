import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/spotlight/domain/entities/spotlight_entity.dart';

import '../../../../core/error/failure.dart';


abstract class SpotlightRepository {

  Future<Either<Failure, SpotlightEntity>> getSpotLight();

}
