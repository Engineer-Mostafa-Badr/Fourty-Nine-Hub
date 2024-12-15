import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/booking/data/models/all_appointment_model.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/entities/all_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/book_regular_appointment.dart';

abstract class BookAppointmentRemoteDataSource {
  Future<Either<Failure, bool>> bookRegularAppointment(
      BookAppointmentParams params);

  Future<Either<Failure, bool>> bookPremiumAppointment(
      BookAppointmentParams params);
  Future<Either<Failure, bool>> doctorCancelAppointment(
      String id);
  Future<Either<Failure, List<AllAppointmentEntity>>> allAppointment(
      PaginationParams params);
}

class BookAppointmentRemoteDataSourceImpl
    implements BookAppointmentRemoteDataSource {
  final ApiConsumer _apiConsumer;
  BookAppointmentRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, bool>> bookRegularAppointment(params) async {
    final response = await _apiConsumer.post(
        EndPoints.bookRegularAppointment(params.appointmentId),
        data: params.toJson(),
        queryParameters: {'subCategory': params.subCategoryId});

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

  @override
  Future<Either<Failure, List<AllAppointmentEntity>>> allAppointment(PaginationParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.allAppointments(params),
    );

    return response.fold((l) => Left(l), (r) => Right((r['data'] as List)
        .map((e) => AllAppointmentModel.fromJson(e))
        .toList()));  }

  @override
  Future<Either<Failure, bool>> doctorCancelAppointment(String id) async {
    final response = await _apiConsumer.delete(EndPoints.doctorCancelAppointment(id));
    return response.fold((failure) => Left(failure), (data) {
      return Right(data['status']);
    });}
}
