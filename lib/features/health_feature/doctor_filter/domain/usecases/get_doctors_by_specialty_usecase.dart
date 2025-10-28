import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../health/domain/entities/most_booking_entity.dart';
import '../repositories/doctor_list_repo.dart';

class GetDoctorsBySpecialtyUseCase
    extends UseCase<List<MostBookingEntity>, GetDoctorsBySpecialtyParams> {
  final DoctorListRepo _repo;

  GetDoctorsBySpecialtyUseCase(this._repo);

  @override
  Future<Either<Failure, List<MostBookingEntity>>> call(
      GetDoctorsBySpecialtyParams params) async {
    return await _repo.getDoctorsBySpecialty(params: params);
  }
}

class GetDoctorsBySpecialtyParams {
  final int page;
  final int limit;
  final String specialtyId;

  GetDoctorsBySpecialtyParams({
    required this.page,
    required this.limit,
    required this.specialtyId,
  });

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
      };
}
