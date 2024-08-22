import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/data/remote_data_source/trip_join_remote_datasource.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/car_brand_entity.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/trip_info_entity.dart';
import 'package:fourtyninehub/features/trip_join/domain/repo/trip_join_repo.dart';
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
  Future<Either<Failure, List<CarBrandEntity>>> fetchCarBrand({required String search}) {
    return tripJoinRemoteDataSource.fetchCarBrand(search: search);
  }
}
