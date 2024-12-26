import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/entities/all_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/book_regular_appointment.dart';

import '../../domain/repositories/book_doctor_appointment_repo.dart';
import '../datasources/book_doctor_appointment_remote_datasource.dart';

class BookAppointmentRepoImpl implements BookAppointmentRepo {
  final BookAppointmentRemoteDataSource _remoteDataSource;
  BookAppointmentRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, bool>> bookRegularAppointment(
      BookAppointmentParams params) {
    return _remoteDataSource.bookRegularAppointment(params);
  }

  @override
  Future<Either<Failure, bool>> bookPremiumAppointment(
      BookAppointmentParams params) {
    return _remoteDataSource.bookPremiumAppointment(params);
  }

  @override
  Future<Either<Failure, List<AllAppointmentEntity>>> allAppointment(
      PaginationParams params) {
    return _remoteDataSource.allAppointment(params);
  }

  @override
  Future<Either<Failure, bool>> doctorCancelAppointment(String id) {
    return _remoteDataSource.doctorCancelAppointment(id);
  }
}
