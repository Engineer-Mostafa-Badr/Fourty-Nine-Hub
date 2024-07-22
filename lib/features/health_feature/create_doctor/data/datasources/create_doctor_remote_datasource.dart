import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/create_doctor.dart';

abstract class CreateDoctorRemoteDataSource {
  Future<Either<Failure, void>> createDoctor(CreateDoctorParams params);
}

// class CreateDoctorRemoteDataSourceImpl
//     implements CreateDoctorRemoteDataSource {
//       final ApiConsumer _apiConsumer;
//   CreateDoctorRemoteDataSourceImpl(this._apiConsumer);
//   @override
//   Future<Either<Failure, void>> createDoctor(CreateDoctorParams params) {
//     final response = _apiConsumer.post(EndPoints.createDoctor, data: params.toJson());
//   }
// }