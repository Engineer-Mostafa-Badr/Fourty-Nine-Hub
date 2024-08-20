import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/repositories/create_doctor_repo.dart';

class GetCitiesUseCase extends UseCase<List<CityEntity>, String> {
  final CreateDoctorRepo _createDoctorRepo;

  GetCitiesUseCase(this._createDoctorRepo);

  @override
  Future<Either<Failure, List<CityEntity>>> call(String params) {
    return _createDoctorRepo.getCities(params);
  }
}
