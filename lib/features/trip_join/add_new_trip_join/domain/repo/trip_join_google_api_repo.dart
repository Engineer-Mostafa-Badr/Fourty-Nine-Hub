import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/location_entity.dart';

abstract class TripJoinGoogleApiRepo {
  Future<Either<Failure, LocationEntity>> fetchLocationCordinations(
      {required String address});
}
