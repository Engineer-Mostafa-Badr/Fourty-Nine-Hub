import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/appointment_entity.dart';

import '../../domain/repositories/book_doctor_appointment_repo.dart';
import '../datasources/book_doctor_appointment_remote_datasource.dart';

class BookAppointmentRepoImpl implements BookAppointmentRepo {
  final BookAppointmentRemoteDataSource _remoteDataSource;
  BookAppointmentRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<AppointmentEntity>>> getDoctorAppointments(
      {required DateTime date}) async {
    return await _remoteDataSource.getDoctorAppointments(date: date);
  }
}
