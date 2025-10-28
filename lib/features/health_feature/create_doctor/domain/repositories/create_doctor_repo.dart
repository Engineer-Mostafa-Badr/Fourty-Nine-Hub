import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/create_doctor.dart';

abstract class CreateDoctorRepo {
  Future<Either<Failure, bool>> createDoctor(CreateDoctorParams params);
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates();
  Future<Either<Failure, List<CityEntity>>> getCities(String governorateId);
  Future<Either<Failure, bool>> uploadDocuments(List<DocumentParams> docs);
}
