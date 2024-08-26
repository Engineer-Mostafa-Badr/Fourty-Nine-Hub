import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/car_year_type_entity.dart';
import 'package:fourtyninehub/features/trip_join/domain/repo/trip_join_repo.dart';

class FetchCarYearTypeUseCase {
  final TripJoinRepo tripJoinRepo;

  FetchCarYearTypeUseCase({required this.tripJoinRepo});
  Future<Either<Failure, List<CarYearTypeEntity>>> call(
      {required String brand, required String model}) {
    return tripJoinRepo.fetchCarYearType(brand: brand, model: model);
  }
}
