import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/trip_info_entity.dart';
import '../repo/trip_join_repo.dart';
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
