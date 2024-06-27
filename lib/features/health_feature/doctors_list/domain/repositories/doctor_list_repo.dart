import 'package:dartz/dartz.dart';

import '../../../../../common/models/public/city_model.dart';
import '../../../../../common/models/public/state_model.dart';
import '../../../../../core/error/failure.dart';
import '../../../doctor_details/domain/entities/doctor_entity.dart';
import '../usecases/get_doctor_list_usecase.dart';

abstract class DoctorListRepo {
  Future<Either<Failure, List<DoctorEntity>>> getDoctorsList({
    required DoctorSearchParams params
  });
  Future<Either<Failure, List<StateModel>>> getStates();
  Future<Either<Failure, List<CityModel>>> getCities({required int stateId});
}