import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/data/models/appointment_model.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/appointment_entity.dart';

import '../../../../../res/assets/jsons.dart';

abstract class BookAppointmentRemoteDataSource {
  Future<Either<Failure, List<AppointmentEntity>>> getDoctorAppointments({
    required DateTime date,
  });
}

class BookAppointmentRemoteDataSourceImpl
    implements BookAppointmentRemoteDataSource {
  final JsonParser _apiConsumer;
  BookAppointmentRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<AppointmentEntity>>> getDoctorAppointments(
      {required DateTime date}) async {
    final response = await _apiConsumer.get(Jsons.doctorAppointments);
   return response.fold((failure) => Left(failure), (data) => Right((data['data']['appointments'] as List).map((e) => AppointmentModel.fromJson(e)).toList()));
  }
}
