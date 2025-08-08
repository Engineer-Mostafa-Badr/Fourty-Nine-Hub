import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/car_model_entity.dart';
import '../repo/trip_join_repo.dart';

class FetchCarModelUseCase {
  final TripJoinRepo tripJoinRepo;

  FetchCarModelUseCase({required this.tripJoinRepo});
  Future<Either<Failure, List<CarModelEntity>>> call({required String brand}) {
    return tripJoinRepo.fetchCarModel(brand: brand);
  }
}
