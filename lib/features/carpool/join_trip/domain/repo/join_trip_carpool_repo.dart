import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/join_trip/data/models/join_trip_carpool_model.dart';
import 'package:fourtyninehub/features/carpool/join_trip/domain/entities/join_trip_entity.dart';

abstract class JoinTripCarpoolRepo {
  Future<Either<Failure, JoinTripCarpoolModel>> joinTripCarpool(
      {required JoinTripCarPoolParam joinTripCarPoolParam});
}
