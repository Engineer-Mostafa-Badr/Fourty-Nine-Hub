import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/domain/repositories/doctor_list_repo.dart';
import '../../../../../../core/abstract/use_case.dart';

class GetDoctorListUseCase extends UseCase<List<DoctorEntity>, DoctorSearchParams> {
  final DoctorListRepo _repo;
  GetDoctorListUseCase(this._repo);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(DoctorSearchParams params) {
    return _repo.getDoctorsList(params: params);
  }
}

class DoctorSearchParams {
  final int? stateId;
  final int? cityId;
  final num? minRate;
  final num? fromPrice;
  final num? toPrice;
  DoctorSearchParams({
     this.cityId,
     this.stateId,
     this.minRate,
     this.fromPrice,
     this.toPrice,
  });
}
