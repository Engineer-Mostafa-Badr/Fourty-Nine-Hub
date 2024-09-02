import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/car_brand_entity.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/repo/trip_join_repo.dart';

class FetchCarBrandUseCase {
  final TripJoinRepo tripJoinRepo;

  FetchCarBrandUseCase({required this.tripJoinRepo});
  Future<Either<Failure, List<CarBrandEntity>>> call({required String search}) {
    return tripJoinRepo.fetchCarBrand(search: search);
  }
}
