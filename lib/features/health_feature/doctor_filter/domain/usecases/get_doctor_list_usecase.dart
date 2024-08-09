import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/enums/doctor_services.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/repositories/doctor_list_repo.dart';
import '../../../../../../core/abstract/use_case.dart';

class GetDoctorListUseCase
    extends UseCase<List<DoctorEntity>, DoctorSearchParams> {
  final DoctorListRepo _repo;
  GetDoctorListUseCase(this._repo);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(DoctorSearchParams params) {
    return _repo.getDoctorsList(params: params);
  }
}

class DoctorSearchParams {
  String governorateId = "";
  String cityId = "";
  String subCategoryId = "";
  DoctorServices? doctorService;
  DoctorSearchParams();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['governorateId'] = governorateId;
    data['cityId'] = cityId;
    data['subCategoryId'] = subCategoryId;
    return data;
  }

  void reset() {
    governorateId = "";
    cityId = "";
    subCategoryId = "";
    doctorService = null;
  }
}
