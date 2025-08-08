import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/car_brand_entity.dart';
import '../entities/car_model_entity.dart';
import '../entities/car_year_type_entity.dart';
import '../entities/trip_info_entity.dart';
import '../entities/trip_join_publish_param.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TripJoinRepo {
  Future<Either<Failure, TripInfoEntity>> fetchDistancePrice({
    required LatLng startLocation,
    required LatLng destinationLocation,
  });
  Future<Either<Failure, List<CarBrandEntity>>> fetchCarBrand(
      {required String search});
  Future<Either<Failure, List<CarModelEntity>>> fetchCarModel(
      {required String brand});
  Future<Either<Failure, List<CarYearTypeEntity>>> fetchCarYearType(
      {required String brand, required String model});
  Future<Either<Failure, bool>> publishTripJoin(
      {required TripJoinPublishParam tripJoinPublishParam});
}
