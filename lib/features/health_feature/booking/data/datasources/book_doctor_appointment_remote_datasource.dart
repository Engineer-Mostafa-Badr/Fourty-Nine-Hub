import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/book_appointment.dart';

abstract class BookAppointmentRemoteDataSource {
  Future<Either<Failure, bool>> bookAppointment(BookAppointmentParams params);
}

class BookAppointmentRemoteDataSourceImpl
    implements BookAppointmentRemoteDataSource {
  final ApiConsumer _apiConsumer;
  BookAppointmentRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, bool>> bookAppointment(params) async {
    final response = await _apiConsumer.post(
        EndPoints.bookAppointment(params.appointmentId),
        data: params.toJson());

    return response.fold((failure) => Left(failure), (data) {
      return Right(data['status']);
    });
  }
}
