import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/data/models/doctor_model.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../res/assets/jsons.dart';

abstract class DoctorDetailsRemoteDataSource {
  Future<Either<Failure, DoctorEntity>> getDoctorDetails({required int id});
}

class DoctorDetailsRemoteDataSourceImpl
    implements DoctorDetailsRemoteDataSource {
  final JsonParser _apiConsumer;
  DoctorDetailsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorDetails(
      {required int id}) async {
    final response = await _apiConsumer.get(Jsons.doctorDetails);
    return response.fold((failure) => Left(failure),
        (data) => Right(DoctorModel.fromJson(data['data'])));
  }
}
