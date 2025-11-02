import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/most_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/repositories/health_repo.dart';

class SearchDoctorsUseCase extends UseCase<List<MostBookingEntity>, SearchDoctorsParams> {
  final HealthRepo _repo;

  SearchDoctorsUseCase(this._repo);

  @override
  Future<Either<Failure, List<MostBookingEntity>>> call(SearchDoctorsParams params) {
    return _repo.searchDoctors(params);
  }
}

class SearchDoctorsParams{
  final String name;
  final int page;
  final int limit;

  SearchDoctorsParams({required this.name, required this.page, required this.limit});

  Map<String, dynamic> toJson() => {
    'name': name,
    'page': page,
    'limit': limit,
  };
}