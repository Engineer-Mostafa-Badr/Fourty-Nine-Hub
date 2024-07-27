import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/datasources/create_doctor_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/repositories/create_doctor_repo.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/create_doctor.dart';

class CreateDoctorRepoImpl implements CreateDoctorRepo {

  final CreateDoctorRemoteDataSource _createDoctorRemoteDataSource;

  CreateDoctorRepoImpl(this._createDoctorRemoteDataSource);


  @override
  Future<Either<Failure, bool>> createDoctor(CreateDoctorParams params) {
    return _createDoctorRemoteDataSource.createDoctor(params);
  }

  @override
  Future<Either<Failure, List<CityEntity>>> getCities(String governorateId) {
    return _createDoctorRemoteDataSource.getCities(governorateId);
  }

  @override
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates() {
    return _createDoctorRemoteDataSource.getGovernorates();
  }
}
