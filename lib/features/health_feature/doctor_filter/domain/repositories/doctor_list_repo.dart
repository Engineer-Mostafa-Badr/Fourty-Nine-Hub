import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_subcategory_doctors_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_doctors_by_specialty_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../../doctor_details/domain/entities/doctor_entity.dart';
import '../../../health/domain/entities/most_booking_entity.dart';
import '../usecases/get_doctor_list_use_case.dart';

abstract class DoctorListRepo {
  Future<Either<Failure, List<MostBookingEntity>>> getDoctorsList(
      {required GetDoctorListParams params});

  Future<Either<Failure, List<MostBookingEntity>>> getDoctorsBySpecialty(
      {required GetDoctorsBySpecialtyParams params});

  Future<Either<Failure, List<DoctorEntity>>> getSubCategoryDoctorsList(
      {required GetSubCategoryDoctorsParams params});
}
