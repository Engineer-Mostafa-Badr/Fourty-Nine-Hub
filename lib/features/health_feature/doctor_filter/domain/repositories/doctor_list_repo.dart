import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../doctor_details/domain/entities/doctor_entity.dart';
import '../usecases/get_doctor_list_usecase.dart';

abstract class DoctorListRepo {
  Future<Either<Failure, List<DoctorEntity>>> getDoctorsList({
    required DoctorSearchParams params
  });
}