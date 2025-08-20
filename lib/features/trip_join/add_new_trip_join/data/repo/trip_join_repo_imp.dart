import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../remote_data_source/trip_join_remote_datasource.dart';
import '../../domain/entities/car_brand_entity.dart';
import '../../domain/entities/car_model_entity.dart';
import '../../domain/entities/car_year_type_entity.dart';
import '../../domain/entities/trip_info_entity.dart';
import '../../domain/entities/trip_join_publish_param.dart';
import '../../domain/repo/trip_join_repo.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class TripJoinRepoImp implements TripJoinRepo {
  final TripJoinRemoteDataSource tripJoinRemoteDataSource;

  TripJoinRepoImp({required this.tripJoinRemoteDataSource});
  @override
  Future<Either<Failure, TripInfoEntity>> fetchDistancePrice(
      {required LatLng startLocation, required LatLng destinationLocation}) {
    return tripJoinRemoteDataSource.fetchPriceDistance(
      startLocation: startLocation,
      destinationLocation: destinationLocation,
    );
  }

  @override
  Future<Either<Failure, List<CarBrandEntity>>> fetchCarBrand(
      {required String search}) {
    return tripJoinRemoteDataSource.fetchCarBrand(search: search);
  }

  @override
  Future<Either<Failure, List<CarModelEntity>>> fetchCarModel(
      {required String brand}) {
    return tripJoinRemoteDataSource.fetchCarModel(brand: brand);
  }

  @override
  Future<Either<Failure, List<CarYearTypeEntity>>> fetchCarYearType({
    required String brand,
    required String model,
  }) {
    return tripJoinRemoteDataSource.fetchCarYearType(
        brand: brand, model: model);
  }

  @override
  Future<Either<Failure, bool>> publishTripJoin(
      {required TripJoinPublishParam tripJoinPublishParam}) {
    return tripJoinRemoteDataSource.publishTripJoin(
        tripJoinPublishParam: tripJoinPublishParam);
  }
}
