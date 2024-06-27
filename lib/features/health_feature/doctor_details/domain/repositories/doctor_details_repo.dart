import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/doctor_entity.dart';

abstract class DoctorDetailsRepo {
  Future<Either<Failure, DoctorEntity>> getDoctorDetails({required int id});
}