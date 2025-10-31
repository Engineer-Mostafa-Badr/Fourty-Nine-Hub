import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/most_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/repositories/health_repo.dart';

class SearchDoctorsBySpecialtyUseCase
    extends UseCase<List<MostBookingEntity>, SearchDoctorsBySpecialtyParams> {
  final HealthRepo _repo;

  SearchDoctorsBySpecialtyUseCase(this._repo);

  @override
  Future<Either<Failure, List<MostBookingEntity>>> call(
      SearchDoctorsBySpecialtyParams params) {
    return _repo.searchDoctorsBySpecialty(params);
  }
}

class SearchDoctorsBySpecialtyParams {
  final String specialtyId;
  final String query;
  final int page;
  final int limit;

  SearchDoctorsBySpecialtyParams({
    required this.specialtyId,
    required this.query,
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toQuery() => {
        'page': page,
        'limit': limit,
        'query': query,
      };
}
