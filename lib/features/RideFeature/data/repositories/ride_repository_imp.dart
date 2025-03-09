import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/data/datasources/ride_remote_data_source.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/car_years_and_types_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/check_driver_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_picture_optional_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_statistics_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/drivers_in_subcategory_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/request_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_car_years_and_types_usecase.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';

import '../../../../core/error/failure.dart';

class RideRepositoryImplementation extends RideRepository {

  final RideRemoteDataSource rideRemoteDataSource;

  RideRepositoryImplementation(this.rideRemoteDataSource);

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(String userId) async {
    return await rideRemoteDataSource.getRideCategories(userId);
  }

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(String userId) async {
    return await rideRemoteDataSource.getShippingCategories(userId);
  }

  @override
  Future<Either<Failure, CheckDriverTypeEntity>> checkDriverType() async {
    return await rideRemoteDataSource.checkDriverType();
  }

  @override
  Future<Either<Failure, bool>> registerRideNotSpecial(RegisterRideNotSpecialEntity params) async{
    return await rideRemoteDataSource.registerRideNotSpecial(params);
  }

  @override
  Future<Either<Failure, bool>> registerRideSpecial(RegisterRideSpecialEntity params) async{
    return await rideRemoteDataSource.registerRideSpecial(params);
  }

  @override
  Future<Either<Failure, List<DriversInSubcategoryEntity>>> getDriversInSubcategory(String subCategoryId) async{
    return await rideRemoteDataSource.getDriversInSubcategory(subCategoryId);
  }

  @override
  Future<Either<Failure, bool>> requestTrip(RequestTripEntity params) async{
    return await rideRemoteDataSource.requestTrip(params);
  }

  @override
  Future<Either<Failure, bool>> checkRealAmountEnough(double params) async {
    return await rideRemoteDataSource.checkRealAmountEnough(params);
  }

  @override
  Future<Either<Failure, RideExpectedPriceEntity>> getExpectedPrice(RideExpectedPriceParams params) async {
    return await rideRemoteDataSource.getExpectedPrice(params);
  }

  @override
  Future<Either<Failure, RideDriverStatisticsEntity>> getDriverStatistics() async {
    return await rideRemoteDataSource.getDriverStatistics();
  }

  @override
  Future<Either<Failure, bool>> deleteRideRegistration() async{
    return await rideRemoteDataSource.deleteRideRegistration();
  }

  @override
  Future<Either<Failure, List<String>>> getRideBrands() async{
    return await rideRemoteDataSource.getRideBrands();
  }
  @override
  Future<Either<Failure, List<String>>> getRideModels(String brand) async{
    return await rideRemoteDataSource.getRideModels(brand);
  }

  @override
  Future<Either<Failure, List<CarYearsAndTypesEntity>>> getCarYearsAndTypes(GetCarYearsAndTypesParams params) async{
    return await rideRemoteDataSource.getCarYearsAndTypes(params);
  }

  @override
  Future<Either<Failure, List<RideColorEntity>>> getRideCarColors() async{
    return await rideRemoteDataSource.getRideCarColors();
  }

  @override
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates() async{
    return await rideRemoteDataSource.getGovernorates();
  }

  @override
  Future<Either<Failure, DriverInfoEntity>> getRideDriverInfo() async{
    return await rideRemoteDataSource.getRideDriverInfo();
  }

  @override
  Future<Either<Failure, DriverPictureOptionalEntity>> getDriverPictureOptional() async{
    return await rideRemoteDataSource.getDriverPictureOptional();
  }
}