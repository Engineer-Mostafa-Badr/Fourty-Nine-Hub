import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/state_model.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';

import '../../../../../common/models/public/city_model.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../res/assets/jsons.dart';
import '../../../doctor_details/data/models/doctor_model.dart';
import '../../domain/usecases/get_doctor_list_usecase.dart';

abstract class DoctorListRemoteDataSource {
  Future<Either<Failure, List<DoctorEntity>>> getDoctorsList({
       required DoctorSearchParams params

  });
  Future<Either<Failure, List<StateModel>>> getStates();
  Future<Either<Failure, List<CityModel>>> getCities({required int stateId});
}

class DoctorListRemoteDataSourceImpl implements DoctorListRemoteDataSource {
  final JsonParser _apiConsumer;
  DoctorListRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<CityModel>>> getCities(
      {required int stateId}) async {
    final response = await _apiConsumer.get(Jsons.citiesList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['cities'] as List)
            .map((e) => CityModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctorsList(
      {    required DoctorSearchParams params
}) async {
    final response = await _apiConsumer.get(Jsons.doctorsList);

    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['doctors'] as List)
            .map((e) => DoctorModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<StateModel>>> getStates() async {
    final response = await _apiConsumer.get(Jsons.statesList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['states'] as List)
            .map((e) => StateModel.fromJson(e))
            .toList()));
  }
}
