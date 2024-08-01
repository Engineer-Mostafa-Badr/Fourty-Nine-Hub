import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/book_regular_appointment.dart';

abstract class BookAppointmentRemoteDataSource {
  Future<Either<Failure, bool>> bookRegularAppointment(
      BookAppointmentParams params);

  Future<Either<Failure, bool>> bookPremiumAppointment(
      BookAppointmentParams params);
}

class BookAppointmentRemoteDataSourceImpl
    implements BookAppointmentRemoteDataSource {
  final ApiConsumer _apiConsumer;
  BookAppointmentRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, bool>> bookRegularAppointment(params) async {
    final response = await _apiConsumer.post(
        EndPoints.bookRegularAppointment(params.appointmentId),
        data: params.toJson());

    return response.fold((failure) => Left(failure), (data) {
      return Right(data['status']);
    });
  }

  @override
  Future<Either<Failure, bool>> bookPremiumAppointment(params) async {
    final response = await _apiConsumer.post(
        EndPoints.bookPremiumAppointment(params.appointmentId),
        data: params.toJson());

    return response.fold((failure) => Left(failure), (data) {
      return Right(data['status']);
    });
  }
}
