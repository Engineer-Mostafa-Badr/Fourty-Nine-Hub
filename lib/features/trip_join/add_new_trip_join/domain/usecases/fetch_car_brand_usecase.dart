import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/car_brand_entity.dart';
import '../repo/trip_join_repo.dart';

class FetchCarBrandUseCase {
  final TripJoinRepo tripJoinRepo;

  FetchCarBrandUseCase({required this.tripJoinRepo});
  Future<Either<Failure, List<CarBrandEntity>>> call({required String search}) {
    return tripJoinRepo.fetchCarBrand(search: search);
  }
}
