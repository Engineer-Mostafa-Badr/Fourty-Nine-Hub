import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/activity_trip_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/car_years_and_types_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/check_driver_type_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/completed_trips_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/cost_per_km_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/driver_info_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/driver_picture_optional_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/driver_statistics_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/drivers_in_subcategory_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/expected_price_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/get_location_from_address_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/history_trip_for_rider_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/history_trip_for_user_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/loading_info_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_color_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_offer_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_request_trip_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/running_trips_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/activity_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/car_years_and_types_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/check_driver_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/cost_per_km_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_picture_optional_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_statistics_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/drivers_in_subcategory_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trip_for_rider_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trip_for_user_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_register_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/request_trip_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_request_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/accept_trip_by_driver_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_pending_trip_by_client_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_trip_by_client.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_trip_by_rider.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/complete_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_activity_trips.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_completed_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_history_trips_for_rider_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_running_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_car_years_and_types_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_location_from_address_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/partial_payment_in_trip.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/recording_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/rider_in_start_location_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/start_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_driver_location_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_trip_price_from_client_use_case.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/governrate_model.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/data/datasources/remote/socket/socket_data_source.dart';
import '../../../../core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/available_ride_trip_model.dart';

import '../../../../shared_web_socket.dart';

abstract class RideRemoteDataSource {
  ////////////////////Nasr////////////////////
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(String userId);

  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(String userId);
  Future<Either<Failure, CheckDriverTypeEntity>> checkDriverType();
  Future<Either<Failure, bool>> registerRideNotSpecial(RegisterRideNotSpecialEntity params);
  Future<Either<Failure, bool>> registerRideSpecial(RegisterRideSpecialEntity params);
  Future<Either<Failure, RideRequestTripEntity>> requestTrip(RequestTripUseCaseParams params);
  Future<Either<Failure, RideRequestTripEntity>> retrieveClientLatestTrip();
  Future<Either<Failure, RideRequestTripEntity>> acceptOfferByClient(String offerId);
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

  Future<Either<Failure, bool>> updateDriverLocation(UpdateDriverLocationUseCaseParams params);

  Future<Either<Failure, List<RunningTripsEntity>>> getAllRunningTrips(GetAllRunningTripsUseCaseParams params);

  Future<Either<Failure, List<CompletedTripsEntity>>> getAllCompletedTrips(GetAllCompletedTripsUseCaseParams params);

  Future<Either<Failure, GetLocationFromAddressEntity>> getLocationFromAddress(GetLocationFromAddressUseCaseParams params);

  Future<Either<Failure, bool>> acceptTripByDriver(AcceptTripByDriverUseCaseParams params);

  Future<Either<Failure, bool>> riderInStartLocation(RiderInStartLocationUseCaseParams params);

  Future<Either<Failure, bool>> startTrip(StartTripUseCaseParams params);

  Future<Either<Failure, bool>> partialPaymentInTrip(PartialPaymentInTripUseCaseParams params);

  Future<Either<Failure, bool>> completeTrip(CompleteTripUseCaseParams params);

  Future<Either<Failure, bool>> cancelTripByRider(CancelTripByRiderUseCaseParams params);

  Future<Either<Failure, bool>> cancelTripByClient(CancelTripByClientUseCaseParams params);

  Future<Either<Failure, bool>> cancelPendingTripByClient(CancelPendingTripByClientUseCaseParams params);

  Future<Either<Failure, bool>> recordingTrip(RecordingTripUseCaseParams params);

  Future<Either<Failure, bool>> updateTripPriceFromClient(UpdateTripPriceFromClientUseCaseParams params);

  Future<Either<Failure, ActivityTripEntity>> getAllActivityTrips(GetAllActivityTripsUseCaseParams params);

  Future<Either<Failure, List<HistoryTripForUserEntity>>> getAllHistoryTripsForUser();

  Future<Either<Failure, List<HistoryTripForRiderEntity>>> getAllHistoryTripsForRider(GetAllHistoryTripsForRiderUseCaseParams params);
  Future<Either<Failure, CostPerKmEntity>> getCostPerKm();
  Future<Either<Failure, bool>> loadingRegister(LoadingRegisterEntity params);
  Future<Either<Failure, LoadingInfoEntity>> getLoadingInfo();
  Future<Either<Failure, bool>> makeRequestTrip();
  Future<Either<Failure, List<AvailableRideTripEntity>>> getAvailableRideTrips(AvailableRideTripsUseCaseParams params);

  void listenToRideOffers(Function(RideOfferEntity offer) params);
}

class RideRemoteDataSourceImplementation
    implements RideRemoteDataSource {
  final ApiConsumer _apiConsumer;

  RideRemoteDataSourceImplementation(this._apiConsumer);

  ////////////////////Nasr////////////////////
  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(
      String userId) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getRideCategories(userId),
      );

      return response.fold((failure) => Left(failure), (data) {
        RideCategoryModelUpdated rideCategoryModel = RideCategoryModelUpdated
            .fromJson(data['data']);
        return Right(rideCategoryModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(
      String userId) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getShippingCategories(userId),
      );

      return response.fold((failure) => Left(failure), (data) {
        RideCategoryModelUpdated rideCategoryModel = RideCategoryModelUpdated
            .fromJson(data['data']);
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
  Future<Either<Failure, RideRequestTripEntity>> requestTrip(RequestTripUseCaseParams params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.requestTrip(params.subcategoryId),
        data: params.toJson(),
      );

      return response.fold((failure) => Left(failure), (data) {
        log('requested trip id before : ${data['data']['trip']['_id']}');
        RideRequestTripModel rideRequestTripModel = RideRequestTripModel.fromJson(data['data']['trip']);
        log('requested trip id after : ${rideRequestTripModel.id}');
        return Right(rideRequestTripModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideRequestTripEntity>> retrieveClientLatestTrip() async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.retrieveClientLatestTrip,
      );

      return response.fold((failure) => Left(failure), (data) {
        RideRequestTripModel rideRequestTripModel = RideRequestTripModel.fromJson(data['data']['latestTrip']);
        return Right(rideRequestTripModel);
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
        return Right(data['data']??false);
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
        log("55555555555555555555555555");
        RideExpectedPriceModel rideExpectedPriceModel = RideExpectedPriceModel.fromJson(data['data']);
        log("777777777.55555555555555");
        return Right(rideExpectedPriceModel);
      });
    } catch (e) {
      log(e.toString());
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

  @override
  Future<Either<Failure, bool>> updateDriverLocation(
      UpdateDriverLocationUseCaseParams params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.updateDriverLocation(),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RunningTripsEntity>>> getAllRunningTrips(
      GetAllRunningTripsUseCaseParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getAllRunningTrips(limit: params.limit, page: params.page),
      );

      return response.fold((failure) => Left(failure), (data) {
        List<RunningTripsModel> runningTrips = [];
        for (Map<String, dynamic> trip in data['data']['trips']) {
          log('Running Trip gender: ${trip['gender']}');
          runningTrips.add(RunningTripsModel.fromJson(trip));
          log('Running Trip length: ${runningTrips.length}');
          log('Running Trip 1 gender: ${runningTrips[0].gender}');
        }
        return Right(runningTrips);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CompletedTripsEntity>>> getAllCompletedTrips(
      GetAllCompletedTripsUseCaseParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getAllCompletedTrips(limit: params.limit, page: params.page),
      );

      return response.fold((failure) => Left(failure), (data) {
        List<CompletedTripsModel> completedTrips = [];
        for (var trip in data['data']['trips']) {
          log('Completed Trip gender: ${trip['gender']}');
          completedTrips.add(CompletedTripsModel.fromJson(trip));
          log('Completed Trip length: ${completedTrips.length}');
          log('Completed Trip 1 gender: ${completedTrips[0].gender}');
        }
        return Right(completedTrips);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetLocationFromAddressEntity>> getLocationFromAddress(
      GetLocationFromAddressUseCaseParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getLocationFromAddress(),
        data: params.toJson(),
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(GetLocationFromAddressModel.fromJson(data['data']));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> acceptTripByDriver(
      AcceptTripByDriverUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.acceptTripByDriver(params.tripId),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> riderInStartLocation(
      RiderInStartLocationUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.rideInStartLocation(params.id),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> startTrip(StartTripUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.startTrip(params.tripId),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> partialPaymentInTrip(
      PartialPaymentInTripUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.partialPaymentInTrip(params.tripId),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> completeTrip(
      CompleteTripUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.completeTripForRide(params.tripId),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelTripByRider(
      CancelTripByRiderUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.cancelTripByRider(params.tripId),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelTripByClient(
      CancelTripByClientUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.cancelTripByClient(params.tripId),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelPendingTripByClient(
    CancelPendingTripByClientUseCaseParams params,
  ) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.cancelPendingTripByClient(params.tripId),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> recordingTrip(
      RecordingTripUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.recordingTrip(params.tripId),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateTripPriceFromClient(
      UpdateTripPriceFromClientUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.updateTripPriceFromClient(params.tripId),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ActivityTripEntity>> getAllActivityTrips(
      GetAllActivityTripsUseCaseParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getAllActivityTrips(limit: params.limit, page: params.page),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(ActivityTripModel.fromJson(data['data']));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HistoryTripForUserEntity>>> getAllHistoryTripsForUser() async{

    try {
      final response = await _apiConsumer.get(
        EndPoints.getAllHistoryTripsForUser(),
      );
      return response.fold((failure) => Left(failure), (data) {
        List<HistoryTripForUserModel> historyTripsForUser = [];
        for (var trip in data['data']['trips']) {
          historyTripsForUser.add(HistoryTripForUserModel.fromJson(trip));
        }
        return Right(historyTripsForUser);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HistoryTripForRiderEntity>>> getAllHistoryTripsForRider(GetAllHistoryTripsForRiderUseCaseParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getAllHistoryTripsForRider(
          limit: params.limit,
          page: params.page,
        ),
      );
      return response.fold((failure) => Left(failure), (data) {
        List<HistoryTripForRiderModel> historyTripsForRider = [];
        for (var trip in data['data']['trips']) {
          historyTripsForRider.add(HistoryTripForRiderModel.fromJson(trip));
        }
        return Right(historyTripsForRider);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CostPerKmEntity>> getCostPerKm() async{
    try {
      final response = await _apiConsumer.get(
        EndPoints.getCostPerKm,
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(CostPerKmModel.fromJson(data['data']));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> loadingRegister(LoadingRegisterEntity params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.loadingRegister,
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
  Future<Either<Failure, LoadingInfoEntity>> getLoadingInfo() async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getLoadingInfo,
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(LoadingInfoModel.fromJson(data['data']));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  @override
  Future<Either<Failure, bool>> makeRequestTrip() async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.makeTripRequest,
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']??false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AvailableRideTripEntity>>> getAvailableRideTrips(AvailableRideTripsUseCaseParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getAvailableRideTrips(params),
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right((data['data']['trips'] as List)
            .map((e) => AvailableRideTripModel.fromJson(e))
            .toList());
      });
    } catch (e) {
      print("e.toString ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  void listenToRideOffers(Function(RideOfferEntity offer) params) {
    try {
      SharedWebSocket.socket!.on(SocketIOListeners.rideSendOffer, (data) {
        // // final decodedData = jsonDecode(data);
        // CliLogger.info("offer data :  $decodedData");
        // params(RideOfferModel.fromJson(decodedData));
        CliLogger.info("offer data :  $data");
        params(RideOfferModel.fromJson(data['formattedNewTripOffer']));
      });
    } catch (e) {
      CliLogger.info("can't listen to offer error $e");
    }
  }

  @override
  Future<Either<Failure, RideRequestTripEntity>> acceptOfferByClient(String offerId) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.acceptOfferByClient(offerId),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(RideRequestTripModel.fromJson(data['data']['tripDetails']));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

