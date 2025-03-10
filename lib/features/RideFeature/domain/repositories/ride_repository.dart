
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/car_years_and_types_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/check_driver_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/drivers_in_subcategory_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/request_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_car_years_and_types_usecase.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';

import '../../../../core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_statistics_entity.dart';

abstract class RideRepository {
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(String userId);
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(String userId);
  Future<Either<Failure, CheckDriverTypeEntity>> checkDriverType();
  Future<Either<Failure, bool>> registerRideNotSpecial(RegisterRideNotSpecialEntity params);
  Future<Either<Failure, bool>> registerRideSpecial(RegisterRideSpecialEntity params);
  Future<Either<Failure, bool>> requestTrip(RequestTripEntity params);
  Future<Either<Failure, bool>> checkRealAmountEnough(double params);
  Future<Either<Failure, RideExpectedPriceEntity>> getExpectedPrice(RideExpectedPriceParams params);
  Future<Either<Failure, List<DriversInSubcategoryEntity>>> getDriversInSubcategory(String subCategoryId);
  Future<Either<Failure, RideDriverStatisticsEntity>> getDriverStatistics();
  Future<Either<Failure, bool>> deleteRideRegistration();
  Future<Either<Failure, List<String>>> getRideBrands();
  Future<Either<Failure, List<String>>> getRideModels(String brand);
  Future<Either<Failure, List<CarYearsAndTypesEntity>>> getCarYearsAndTypes(GetCarYearsAndTypesParams params);
  Future<Either<Failure, List<RideColorEntity>>> getRideCarColors();
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates();
}