import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/appointment_booking_model.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/health_subcategory_model.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';

abstract class HealthRemoteDataSource {
  Future<Either<Failure, List<BookedAppointmentEntity>>> getMyBookingsHistory();
  Future<Either<Failure, List<BookedAppointmentEntity>>> getUpcomingBookings();
  Future<Either<Failure, List<HealthSubcategoryEntity>>>
      getHealthSubcategories();
  Future<Either<Failure, List<HealthSubcategoryEntity>>> getMedicalServices();
  Future<Either<Failure, bool>> toggleFavoriteSubcategory(String sucategoryId);
  Future<Either<Failure, bool>> isDoctor();
}

class HealthRemoteDataSourceImpl implements HealthRemoteDataSource {
  final ApiConsumer _apiConsumer;
  HealthRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<BookedAppointmentEntity>>>
      getMyBookingsHistory() async {
    final response = await _apiConsumer.get(EndPoints.getHealthRequestsHistory);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => BookedUserAppointmentModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<BookedAppointmentEntity>>>
      getUpcomingBookings() async {
    final response =
        await _apiConsumer.get(EndPoints.getUpcomingUserAppointments);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => BookedUserAppointmentModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<HealthSubcategoryEntity>>>
      getHealthSubcategories() async {
    final response = await _apiConsumer.get(EndPoints.getHealthSubcategories);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['subcategories'] as List)
            .map((e) => HealthSubcategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<HealthSubcategoryEntity>>>
      getMedicalServices() async {
    final response = await _apiConsumer.get(EndPoints.getMedicalServices);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['subcategories'] as List)
            .map((e) => HealthSubcategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> toggleFavoriteSubcategory(
      String sucategoryId) async {
    final response = await _apiConsumer
        .post(EndPoints.toggleFavoriteSubcategory(sucategoryId));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> isDoctor() async {
    final response = await _apiConsumer.get(EndPoints.isDoctor);
    return response.fold(
        (l) => Left(l), (data) => Right(data['data']['isDoctor'] as bool));
  }
}
