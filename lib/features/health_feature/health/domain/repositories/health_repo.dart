import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_info_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_setting_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/favorite_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import '../../../../../core/error/failure.dart';
import '../entities/appointment_booking_entity.dart';
import '../entities/most_booking_entity.dart';
import '../usecases/get_booking_use_case.dart';
import '../usecases/get_most_booking_use_case.dart';

abstract class HealthRepo {
  Future<Either<Failure, List<BookedAppointmentEntity>>> getMyBookingsHistory();
  Future<Either<Failure, List<FavoriteCategoryBannersEntity>>>
      getCategoryFavorite();

  Future<Either<Failure, List<BookedAppointmentEntity>>> getUpcomingBookings(
      String userId);

  Future<Either<Failure, List<HealthSubcategoryEntity>>> getHealthSubcategories(
      String id);

  Future<Either<Failure, List<HealthSubcategoryEntity>>> getMedicalServices(
      String userId);
  Future<Either<Failure, DoctorSettingEntity>> isDoctor();
  Future<Either<Failure, bool>> isDoctorApproval();
  Future<Either<Failure, DoctorInfoEntity>> getDoctorInfo();
  Future<Either<Failure, bool>> cancelAppointment(String id);
  Future<Either<Failure, List<BookingEntity>>> getBooking({required GetBookingParams params});
  Future<Either<Failure, List<BookingEntity>>> getHistoryBooking({required GetBookingParams params});
  Future<Either<Failure, List<MostBookingEntity>>> getMostBooking({required GetMostBookingParams params});
  Future<Either<Failure, List<MostBookingEntity>>> getUserBooking({required GetMostBookingParams params});
}
