import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/spotlight/domain/entities/spotlight_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/available_trip_join_entity.dart';

import '../../../../core/error/failure.dart';


abstract class SpotlightRepository {

  Future<Either<Failure, SpotlightEntity>> getSpotLight();

}
