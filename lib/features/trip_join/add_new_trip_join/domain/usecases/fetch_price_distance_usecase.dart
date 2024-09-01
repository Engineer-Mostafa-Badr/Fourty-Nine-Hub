import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/trip_info_entity.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/repo/trip_join_repo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FetchPriceDistanceUsecase {
  final TripJoinRepo tripJoinRepo;

  FetchPriceDistanceUsecase({required this.tripJoinRepo});
  Future<Either<Failure, TripInfoEntity>> call({
    required LatLng startLocation,
    required LatLng destiantionLocation,
  }) async {
    return await tripJoinRepo.fetchDistancePrice(
      startLocation: startLocation,
      destinationLocation: destiantionLocation,
    );
  }
}
