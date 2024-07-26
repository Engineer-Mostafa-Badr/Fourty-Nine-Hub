import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/create_doctor.dart';

abstract class CreateDoctorRepo {
  Future<Either<Failure, void>> createDoctor(CreateDoctorParams params);
}
