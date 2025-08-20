import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/car_year_type_entity.dart';
import '../repo/trip_join_repo.dart';

class FetchCarYearTypeUseCase {
  final TripJoinRepo tripJoinRepo;

  FetchCarYearTypeUseCase({required this.tripJoinRepo});
  Future<Either<Failure, List<CarYearTypeEntity>>> call(
      {required String brand, required String model}) {
    return tripJoinRepo.fetchCarYearType(brand: brand, model: model);
  }
}
