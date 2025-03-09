import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/car_years_and_types_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/check_driver_type_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/driver_info_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/driver_picture_optional_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/driver_statistics_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/drivers_in_subcategory_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_color_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_model.dart';
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
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_car_years_and_types_usecase.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/governrate_model.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';

abstract class RideRemoteDataSource {
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(String userId);

  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(String userId);
  Future<Either<Failure, CheckDriverTypeEntity>> checkDriverType();
  Future<Either<Failure, bool>> registerRideNotSpecial(RegisterRideNotSpecialEntity params);
  Future<Either<Failure, bool>> registerRideSpecial(RegisterRideSpecialEntity params);
  Future<Either<Failure, bool>> requestTrip(RequestTripEntity params);
  Future<Either<Failure, bool>> checkRealAmountEnough(double params);
  Future<Either<Failure, List<DriversInSubcategoryEntity>>> getDriversInSubcategory(String subCategoryId);
  Future<Either<Failure, RideExpectedPriceEntity>> getExpectedPrice(RideExpectedPriceParams params);
  Future<Either<Failure, RideDriverStatisticsEntity>> getDriverStatistics();
  Future<Either<Failure, bool>> deleteRideRegistration();
  Future<Either<Failure, List<String>>> getRideBrands();
  Future<Either<Failure, List<String>>> getRideModels(String brand);
  Future<Either<Failure, List<CarYearsAndTypesEntity>>> getCarYearsAndTypes(GetCarYearsAndTypesParams params);
  Future<Either<Failure, List<RideColorEntity>>> getRideCarColors();
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates();
  Future<Either<Failure, DriverInfoEntity>> getRideDriverInfo();
  Future<Either<Failure, DriverPictureOptionalEntity>> getDriverPictureOptional();
}

class RideRemoteDataSourceImplementation
    implements RideRemoteDataSource {
  final ApiConsumer _apiConsumer;

  RideRemoteDataSourceImplementation(this._apiConsumer);


  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(String userId) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getRideCategories(userId),
      );

      return response.fold((failure) => Left(failure), (data) {
        RideCategoryModelUpdated rideCategoryModel = RideCategoryModelUpdated.fromJson(data['data']);
        return Right(rideCategoryModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(String userId) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getShippingCategories(userId),
      );

      return response.fold((failure) => Left(failure), (data) {
        RideCategoryModelUpdated rideCategoryModel = RideCategoryModelUpdated.fromJson(data['data']);
        return Right(rideCategoryModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CheckDriverTypeEntity>> checkDriverType() async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.checkDriverType,
      );

      return response.fold((failure) => Left(failure), (data) {
        CheckDriverTypeModel checkDriverTypeModel = CheckDriverTypeModel.fromJson(data['data']);
        return Right(checkDriverTypeModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> registerRideNotSpecial(RegisterRideNotSpecialEntity params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.riderRegister,
        data: params.toJson(),
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']??false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> registerRideSpecial(RegisterRideSpecialEntity params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.specialRegister,
        data: params.toJson(),
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']??false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DriversInSubcategoryEntity>>> getDriversInSubcategory(String subCategoryId) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getDriversInSubcategory(subCategoryId),
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right((data['data'] as List)
            .map((e) => DriversInSubcategoryModel.fromJson(e))
            .toList());
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> requestTrip(RequestTripEntity params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.requestTrip(params.id),
        data: params.toJson(),
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']??false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkRealAmountEnough(double params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.checkWalletEnough,
        data: {
          "amount" : params
        },
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']??false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideExpectedPriceEntity>> getExpectedPrice(RideExpectedPriceParams params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.getExpectedPrice(params.id),
        data: params.toJson(),
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']??false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideDriverStatisticsEntity>> getDriverStatistics() async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getDriverStatistics,
      );

      return response.fold((failure) => Left(failure), (data) {
        RideDriverStatisticsModel rideDriverStatisticsModel = RideDriverStatisticsModel.fromJson(data['data']);
        return Right(rideDriverStatisticsModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteRideRegistration() async {
    try {
      final response = await _apiConsumer.delete(
        EndPoints.deleteRideRegistration,
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']??false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRideBrands() async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.getRideBrands,
        data: {
          "brand" : ""
        }
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right((data['data']!=null||data['data'].isNotEmpty)?List<String>.from(data['data'].map((e) => e['brand'].toString())):[]);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRideModels(String brand) async {
    try {
      final response = await _apiConsumer.get(
          EndPoints.getRideModels,
          queryParameters: {
            "brand" : brand
          }
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right((data['data']!=null||data['data'].isNotEmpty)?List<String>.from(data['data'].map((e) => e['model'].toString())):[]);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CarYearsAndTypesEntity>>> getCarYearsAndTypes(GetCarYearsAndTypesParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getCarYearsAndTypes,
        queryParameters: params.toJson()
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right((data['data'] as List)
            .map((e) => CarsYearsAndTypesModel.fromJson(e))
            .toList());
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RideColorEntity>>> getRideCarColors() async {
    try {
      final response = await _apiConsumer.get(
          EndPoints.getRideCarColors,
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right((data['data'] as List)
            .map((e) => RideColorModel.fromJson(e))
            .toList());
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates() async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getGovernorates,
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right((data['data'] as List)
            .map((e) => GovernorateModel.fromJson(e))
            .toList());
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DriverInfoEntity>> getRideDriverInfo() async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getRideDriverInfo,
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(DriverInfoModel.fromJson(data['data']));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DriverPictureOptionalEntity>> getDriverPictureOptional() async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getRideDriverPictureOptional,
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(DriverPictureOptionalModel.fromJson(data['data']));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

}