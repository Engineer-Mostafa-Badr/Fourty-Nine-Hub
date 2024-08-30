import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/car_model_entity.dart';
import 'package:fourtyninehub/features/trip_join/domain/repo/trip_join_repo.dart';

class FetchCarModelUseCase {
  final TripJoinRepo tripJoinRepo;

  FetchCarModelUseCase({required this.tripJoinRepo});
  Future<Either<Failure, List<CarModelEntity>>> call({required String brand}) {
    return tripJoinRepo.fetchCarModel(brand: brand);
  }
}
