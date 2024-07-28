import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/book_appointment.dart';


import '../../domain/repositories/book_doctor_appointment_repo.dart';
import '../datasources/book_doctor_appointment_remote_datasource.dart';

class BookAppointmentRepoImpl implements BookAppointmentRepo {
  final BookAppointmentRemoteDataSource _remoteDataSource;
  BookAppointmentRepoImpl(this._remoteDataSource);


  @override
  Future<Either<Failure, bool>> bookAppointment(BookAppointmentParams params) {
    return _remoteDataSource.bookAppointment(params);
  }
}
