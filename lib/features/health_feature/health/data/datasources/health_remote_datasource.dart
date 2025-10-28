import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/appointment_booking_model.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/category_favorite_model.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/doctor_info_model.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/doctor_setting_model.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/health_subcategory_model.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_info_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_setting_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/favorite_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/search_doctors_usecase.dart';

import '../../domain/entities/most_booking_entity.dart';
import '../../domain/usecases/get_booking_use_case.dart';
import '../../domain/usecases/get_most_booking_use_case.dart';
import '../models/booking_model.dart';
import '../models/most_booking_model.dart';

abstract class HealthRemoteDataSource {
  Future<Either<Failure, List<BookedAppointmentEntity>>> getMyBookingsHistory();
  Future<Either<Failure, List<BookedAppointmentEntity>>> getUpcomingBookings(
      String userId);
  Future<Either<Failure, List<HealthSubcategoryEntity>>> getHealthSubcategories(
      String id);
  Future<Either<Failure, List<HealthSubcategoryEntity>>> getMedicalServices(
      String userId);
  Future<Either<Failure, List<MostBookingEntity>>> searchDoctors(
      SearchDoctorsParams params);
  Future<Either<Failure, List<FavoriteCategoryBannersEntity>>>
      getFavoriteCategory();

  Future<Either<Failure, DoctorSettingEntity>> isDoctor();
  Future<Either<Failure, bool>> isDoctorApproval();
  Future<Either<Failure, DoctorInfoEntity>> getDoctorInfo();
  Future<Either<Failure, bool>> cancelAppointment(String id);

  Future<Either<Failure, List<BookingEntity>>> getBooking(
      {required GetBookingParams params});

  Future<Either<Failure, List<BookingEntity>>> getHistoryBooking(
      {required GetBookingParams params});

  Future<Either<Failure, List<MostBookingEntity>>> getMostBooking(
      {required GetMostBookingParams params});

  Future<Either<Failure, List<BookedAppointmentEntity>>> getUserBooking(
      {required GetMostBookingParams params});
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
  Future<Either<Failure, List<BookedAppointmentEntity>>> getUpcomingBookings(
      String userId) async {
    final response =
        await _apiConsumer.get(EndPoints.getUpcomingUserAppointments(userId));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => BookedUserAppointmentModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<HealthSubcategoryEntity>>> getHealthSubcategories(
      String id) async {
    final response =
        await _apiConsumer.get(EndPoints.getHealthSubcategories(id));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['subcategories'] as List)
            .map((e) => HealthSubcategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<HealthSubcategoryEntity>>> getMedicalServices(
      String userId) async {
    final response =
        await _apiConsumer.get(EndPoints.getMedicalServices(userId));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['subcategories'] as List)
            .map((e) => HealthSubcategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<MostBookingEntity>>> searchDoctors(
      SearchDoctorsParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.doctorSearch,
      queryParameters: {
        'name': params.name,
        'limit': params.limit,
        'page': params.page,
      },
    );
    return response.fold((failure) => Left(failure), (data) {
      print('Search response data structure: $data');
      print('Data type: ${data.runtimeType}');

      try {
        // Handle the response structure correctly
        if (data['data'] != null && data['data'] is List) {
          print(
              'Data is in data field, length: ${(data['data'] as List).length}');
          if ((data['data'] as List).isNotEmpty) {
            print('First item structure: ${(data['data'] as List).first}');
          }
          return Right((data['data'] as List)
              .map((e) => MostBookingModel.fromJson(e))
              .toList());
        } else if (data is List) {
          print('Data is directly a list, length: ${data.length}');
          if (data.isNotEmpty) {
            //print('First item structure: ${data.first}');
          }
          return Right(
              (data as List).map((e) => MostBookingModel.fromJson(e)).toList());
        } else {
          print('Unexpected data structure');
          return Right([]);
        }
      } catch (e) {
        print('Error parsing search results: $e');
        return Right([]);
      }
    });
  }

  @override
  Future<Either<Failure, DoctorSettingEntity>> isDoctor() async {
    final response = await _apiConsumer.get(EndPoints.isDoctor);
    return response.fold((l) => Left(l),
        (data) => Right(DoctorSettingModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, bool>> isDoctorApproval() async {
    final response = await _apiConsumer.get(EndPoints.isDoctorApproval);
    return response.fold(
        (l) => Left(l), (data) => Right(data["data"]["isApproved"] as bool));
  }

  @override
  Future<Either<Failure, List<FavoriteCategoryBannersEntity>>>
      getFavoriteCategory() async {
    final response = await _apiConsumer.get(EndPoints.getFavoriteCategory);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['favorites'] as List)
            .map((e) => FavoriteCategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, DoctorInfoEntity>> getDoctorInfo() async {
    final response = await _apiConsumer.get(EndPoints.getDoctorInfo);
    return response.fold((failure) => Left(failure),
        (data) => Right((DoctorInfoModel.fromJson(data['data']))));
  }

  @override
  Future<Either<Failure, bool>> cancelAppointment(String id) async {
    final response = await _apiConsumer.delete(EndPoints.cancelAppointment(id));
    return response.fold(
        (failure) => Left(failure), (data) => Right((data['status'])));
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getBooking(
      {required GetBookingParams params}) async {
    final url =
        "${EndPoints.getBookingCurrent}?type=${params.type}&page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        final restaurantList = (data['data']['bookings'] as List)
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(restaurantList);
      },
    );
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getHistoryBooking(
      {required GetBookingParams params}) async {
    final url =
        "${EndPoints.getHistoryBooking}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        final restaurantList = (data['data']['data'] as List)
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(restaurantList);
      },
    );
  }

  @override
  Future<Either<Failure, List<MostBookingEntity>>> getMostBooking(
      {required GetMostBookingParams params}) async {
    final url =
        "${EndPoints.getMostBooking}?orderBy=popularity&page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        final restaurantList = (data['data']["doctors"] as List)
            .map((e) => MostBookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(restaurantList);
      },
    );
  }

  @override
  Future<Either<Failure, List<BookedAppointmentEntity>>> getUserBooking(
      {required GetMostBookingParams params}) async {
    final url =
        "${EndPoints.getUserBooking}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        final restaurantList = (data['data']["bookings"] as List)
            .map((e) =>
                BookedUserAppointmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(restaurantList);
      },
    );
  }
}
