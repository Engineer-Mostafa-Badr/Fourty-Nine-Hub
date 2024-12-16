import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/doctor_info_model.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_info_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/favorite_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';

import '../../../../../core/error/failure.dart';
import '../entities/appointment_booking_entity.dart';

abstract class HealthRepo {
  Future<Either<Failure, List<BookedAppointmentEntity>>> getMyBookingsHistory();
  Future<Either<Failure, List<FavoriteCategoryBannersEntity>>>
      getCategoryFavorite();

  Future<Either<Failure, List<BookedAppointmentEntity>>> getUpcomingBookings(String userId);

  Future<Either<Failure, List<HealthSubcategoryEntity>>>
      getHealthSubcategories(String id);

  Future<Either<Failure, List<HealthSubcategoryEntity>>> getMedicalServices(String userId);
  Future<Either<Failure, bool>> isDoctor();
  Future<Either<Failure, bool>> isDoctorApproval();
  Future<Either<Failure, DoctorInfoEntity>> getDoctorInfo();
  Future<Either<Failure, bool>> cancelAppointment(String id);
}
