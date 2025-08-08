import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/socket/socket_data_source.dart';
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
import 'package:fourtyninehub/features/RideFeature/data/models/history_trips_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/loading_info_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_brand_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_car_model_model.dart';
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
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_register_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/request_trip_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_brand_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_model_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_request_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/accept_trip_by_driver_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/add_car_model_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_pending_trip_by_client_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_trip_by_client.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_trip_by_rider.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/click_global_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/complete_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/watching_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_activity_trips.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_completed_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_history_trips_for_rider_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_history_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_running_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_car_years_and_types_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_location_from_address_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_categories_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/partial_payment_in_trip.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/recording_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/rider_in_start_location_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/start_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_driver_location_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_socket_location_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_trip_auto_accept_by_client_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_trip_price_from_client_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_trip_price_use_case.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/governrate_model.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:fourtyninehub/shared_web_socket.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/available_ride_trip_model.dart';

import '../../../food_feature/restaurants_list/data/models/rate_response_model.dart';
import '../../../food_feature/restaurants_list/domain/entities/rate_response_entity.dart';
import '../../domain/entities/client/client_all_rating_entity.dart';
import '../../domain/entities/client/driver_all_rating_entity.dart';
import '../../domain/entities/create_no_track_trip_entity.dart';
import '../../domain/entities/dashboards/create_non_track_offer_entity.dart';
import '../../domain/entities/dashboards/update_driver_settings_entity.dart';
import '../../domain/entities/get_client_accepted_trips_entity.dart';
import '../../domain/entities/get_client_offer_trips_entity.dart';
import '../../domain/entities/get_client_past_trips_entity.dart';
import '../../domain/entities/get_client_pending_trips_entity.dart';
import '../../domain/entities/get_offers_entity.dart';
import '../../domain/usecases/accept_non_track_trip_use_case.dart';
import '../../domain/usecases/cancel_non_track_trip_use_case.dart';
import '../../domain/usecases/client_trips/get_driver_all_rating_use_case.dart';
import '../../domain/usecases/client_trips/update_client_rate_non_socket_use_case.dart';
import '../../domain/usecases/create_non_track_trip_use_case.dart';
import '../../domain/usecases/dashboards/add_rate_with_driver_use_case.dart';
import '../../domain/usecases/dashboards/create_non_track_offer_use_case.dart';
import '../../domain/usecases/dashboards/update_driver_settings_use_case.dart';
import '../../domain/usecases/get_client_pending_untracked_trips_use_case.dart';
import '../../domain/usecases/make_loading_request_trip_usecase.dart';
import '../../domain/usecases/make_non_tracking_request_trip_usecase.dart';
import '../../domain/usecases/rating_driver_by_client.dart';
import '../models/client/client_all_rating_model.dart';
import '../models/client/driver_all_rating_model.dart';
import '../models/create_no_track_trip_model.dart';
import '../models/dashboards/create_non_track_offer_model.dart';
import '../models/dashboards/get_offers_response_model.dart';
import '../../../account_taps/my_adds/data/model/click_model.dart';
import '../../../account_taps/my_adds/domain/entity/click_entity.dart';
import '../models/dashboards/update_driver_settings_model.dart';
import '../models/get_client_accepted_trips_model.dart';
import '../models/get_client_offer_trips_model.dart';
import '../models/get_client_past_trips_model.dart';
import '../models/get_client_pending_trips_model.dart';

abstract class RideRemoteDataSource {
  ////////////////////Nasr////////////////////
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(
      GetRideCategoriesParams params);
  Future<Either<Failure, bool>> listenToUpdateLocation(
      UpdateSocketLocationParams params);
  Future<Either<Failure, bool>> watchingTripsParams(WatchingTripsParams params);
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(
      GetRideCategoriesParams params);
  Future<Either<Failure, CheckDriverTypeEntity>> checkDriverType();
  Future<Either<Failure, bool>> registerRideNotSpecial(
      RegisterRideNotSpecialEntity params);
  Future<Either<Failure, bool>> registerRideSpecial(
      RegisterRideSpecialEntity params);
  Future<Either<Failure, RideRequestTripEntity>> requestTrip(
      RequestTripUseCaseParams params);
  Future<Either<Failure, RideRequestTripEntity>> retrieveClientLatestTrip();
  Future<Either<Failure, RideRequestTripEntity>> acceptOfferByClient(
      String offerId);
  Future<Either<Failure, bool>> checkRealAmountEnough(double params);
  Future<Either<Failure, List<DriversInSubcategoryEntity>>>
      getDriversInSubcategory(String subCategoryId);
  Future<Either<Failure, RideExpectedPriceEntity>> getExpectedPrice(
      RideExpectedPriceParams params);
  Future<Either<Failure, RideDriverStatisticsEntity>> getDriverStatistics();
  Future<Either<Failure, bool>> deleteRideRegistration();
  Future<Either<Failure, List<RideBrandEntity>>> getRideBrands();
  Future<Either<Failure, List<RideModelEntity>>> getRideModels(String brand);
  Future<Either<Failure, List<RideModelEntity>>> getRideShippingModels(String brand);
  Future<Either<Failure, List<RideModelEntity>>> getRideNonTrackingModels(String brand);
  Future<Either<Failure, String>> addCarModel(AddCarModelParams params);
  Future<Either<Failure, String>> addCarBrand(String params);
  Future<Either<Failure, List<CarYearsAndTypesEntity>>> getCarYearsAndTypes(
      GetCarYearsAndTypesParams params);
  Future<Either<Failure, List<RideColorEntity>>> getRideCarColors();
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates();
  Future<Either<Failure, DriverInfoEntity>> getRideDriverInfo(bool refresh);
  Future<Either<Failure, DriverPictureOptionalEntity>>
      getDriverPictureOptional();

  Future<Either<Failure, bool>> updateDriverLocation(
      UpdateDriverLocationUseCaseParams params);

  Future<Either<Failure, List<RunningTripsEntity>>> getAllRunningTrips(
      GetAllRunningTripsUseCaseParams params);

  Future<Either<Failure, List<HistoryTripsEntity>> > getAllHistoryTrips(GetAllHistoryTripsUseCaseParams params);

  Future<Either<Failure, bool>> updateTripAutoAcceptByClient(
      UpdateTripAutoAcceptByClientUseCaseParams params);

  Future<Either<Failure, List<CompletedTripsEntity>>> getAllCompletedTrips(
      GetAllCompletedTripsUseCaseParams params);

  Future<Either<Failure, GetLocationFromAddressEntity>> getLocationFromAddress(
      GetLocationFromAddressUseCaseParams params);

  Future<Either<Failure, bool>> acceptTripByDriver(
      AcceptTripByDriverUseCaseParams params);

  Future<Either<Failure, bool>> riderInStartLocation(
      RiderInStartLocationUseCaseParams params);

  Future<Either<Failure, bool>> startTrip(StartTripUseCaseParams params);

  Future<Either<Failure, bool>> partialPaymentInTrip(
      PartialPaymentInTripUseCaseParams params);

  Future<Either<Failure, bool>> completeTrip(CompleteTripUseCaseParams params);

  Future<Either<Failure, bool>> cancelTripByRider(
      CancelTripByRiderUseCaseParams params);

  Future<Either<Failure, bool>> finalizeTripByRider(
      String params);

  Future<Either<Failure, bool>> cancelTripByClient(
      CancelTripByClientUseCaseParams params);

  Future<Either<Failure, bool>> cancelPendingTripByClient(
      CancelPendingTripByClientUseCaseParams params);

  Future<Either<Failure, bool>> recordingTrip(
      RecordingTripUseCaseParams params);

  Future<Either<Failure, bool>> updateTripPriceFromClient(
      UpdateTripPriceFromClientUseCaseParams params);

  Future<Either<Failure, bool>> updateTripPrice(UpdateTripPriceUseCaseParams params);

  Future<Either<Failure, ActivityTripEntity>> getAllActivityTrips(GetAllActivityTripsUseCaseParams params);

  Future<Either<Failure, String>> getAvailableMapCountry();


  Future<Either<Failure, List<HistoryTripForUserEntity>>>
      getAllHistoryTripsForUser();

  Future<Either<Failure, List<HistoryTripForRiderEntity>>>
      getAllHistoryTripsForRider(
          GetAllHistoryTripsForRiderUseCaseParams params);
  Future<Either<Failure, CostPerKmEntity>> getCostPerKm();
  Future<Either<Failure, bool>> loadingRegister(LoadingRegisterEntity params);
  Future<Either<Failure, LoadingInfoEntity>> getLoadingInfo(bool refresh);
  Future<Either<Failure, bool>> makeRequestTrip();
  Future<Either<Failure, List<AvailableRideTripEntity>>> getAvailableRideTrips(
      AvailableRideTripsUseCaseParams params);
  Future<Either<Failure, bool>> makeNonTrackingRequestTrip(
      MakeNonTrackingRequestTripUsecaseParam params);
  Future<Either<Failure, GetOffersResponseEntity>> getClientOffers();
  Future<Either<Failure, GetOffersResponseEntity>> getLoadingOffers();

  void listenToRideOffers(Function(RideOfferEntity offer) params);

  Future<Either<Failure, ClickEntity>> click(ClickParams params);

  Future<Either<Failure, bool>> makeLoadingRequestTrip(
      MakeLoadingRequestTripUsecaseParam params);

  Future<Either<Failure, CreateNonTrackTripEntity>> createNonTrackTrip(CreateNonTrackTripParams params);

  Future<Either<Failure, List<ClientPendingTripEntity>>> getClientPendingUntrackedTrips({required ClientPendingTripParams params});
  Future<Either<Failure, List<ClientPendingTripEntity>>> getClientPendingShippingTrips({required ClientPendingTripParams params});

  Future<Either<Failure, CreateNonTrackTripEntity>> cancelNonTrackTrip(CancelNonTrackTripParams params);
  Future<Either<Failure, CreateNonTrackTripEntity>> cancelShippingTrip(CancelNonTrackTripParams params);

  Future<Either<Failure, List<ClientAcceptedTripEntity>>> getClientAcceptedUntrackedTrips({required ClientPendingTripParams params});
  Future<Either<Failure, List<ClientAcceptedTripEntity>>> getClientAcceptedShippingTrips({required ClientPendingTripParams params});

  Future<Either<Failure, List<ClientOfferTripEntity>>> getClientOfferUntrackedTrips({required ClientPendingTripParams params});
  Future<Either<Failure, List<ClientOfferTripEntity>>> getClientOfferShippingTrips({required ClientPendingTripParams params});

  Future<Either<Failure, CreateNonTrackTripEntity>> acceptNonTrackTrip(AcceptNonTrackTripParams params);
  Future<Either<Failure, CreateNonTrackTripEntity>> acceptShippingTrip(AcceptNonTrackTripParams params);

  Future<Either<Failure, CreateNonTrackTripEntity>> refuseNonTrackTrip(AcceptNonTrackTripParams params);
  Future<Either<Failure, CreateNonTrackTripEntity>> refuseShippingTrip(AcceptNonTrackTripParams params);

  Future<Either<Failure, List<ClientPastTripEntity >>> getClientPastUntrackedTrips({required ClientPendingTripParams params});
  Future<Either<Failure, List<ClientPastTripEntity >>> getClientPastShippingTrips({required ClientPendingTripParams params});

  Future<Either<Failure, CreateNonTrackOfferEntity>> createNonTrackOffer(CreateNonTrackOfferParams params);

  Future<Either<Failure, UpdateDriverSettingsEntity >> updateDriverSettings(UpdateDriverSettingsParams params);
  Future<Either<Failure, bool>> sendOkIamComing();

  Future<Either<Failure, bool>> ratingDriverByClient(RatingDriverByClientUseCaseParams params);

  void listenToOfferUpdateUntrackedTrip(Function(ClientOfferTripEntity offer) params);
  void listenToOfferUpdateShippingTrip(Function(ClientOfferTripEntity offer) params);
  Future<Either<Failure, RateResponseEntity>> addRateWithClient(AddRateWithDriverParams params);

  Future<Either<Failure, CreateNonTrackTripEntity>> updateClientRateNonSocket(UpdateClientRateParams params);
  Future<Either<Failure, DriverAllRatingEntity >> getDriverAllRating(DriverAllRatingParams params);


  Future<Either<Failure, ClientAllRatingEntity>> getClientAllRating(DriverAllRatingParams params);



}

class RideRemoteDataSourceImplementation implements RideRemoteDataSource {
  final ApiConsumer _apiConsumer;

  RideRemoteDataSourceImplementation(this._apiConsumer);

  ////////////////////Nasr////////////////////
  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(
      GetRideCategoriesParams params) async {
    try {
      final response = await _apiConsumer.get(
          EndPoints.getRideCategories(params.userId),
          refresh: params.refresh);

      return response.fold((failure) => Left(failure), (data) {
        RideCategoryModelUpdated rideCategoryModel =
            RideCategoryModelUpdated.fromJson(data['data']);
        return Right(rideCategoryModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(
      GetRideCategoriesParams params) async {
    try {
      final response = await _apiConsumer.get(
          EndPoints.getShippingCategories(params.userId),
          refresh: params.refresh);

      return response.fold((failure) => Left(failure), (data) {
        RideCategoryModelUpdated rideCategoryModel =
            RideCategoryModelUpdated.fromJson(data['data']);
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
        CheckDriverTypeModel checkDriverTypeModel =
            CheckDriverTypeModel.fromJson(data['data']);
        return Right(checkDriverTypeModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> registerRideNotSpecial(
      RegisterRideNotSpecialEntity params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.riderRegister,
        data: params.toJson(),
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status'] ?? false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> registerRideSpecial(
      RegisterRideSpecialEntity params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.specialRegister,
        data: params.toJson(),
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status'] ?? false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DriversInSubcategoryEntity>>>
      getDriversInSubcategory(String subCategoryId) async {
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
  Future<Either<Failure, RideRequestTripEntity>> requestTrip(
      RequestTripUseCaseParams params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.requestTrip(params.subcategoryId),
        data: params.toJson(),
      );

      return response.fold((failure) => Left(failure), (data) {
        log('requested trip id before : ${data['data']['tripId']}');
        RideRequestTripModel rideRequestTripModel = RideRequestTripModel.fromJson(data['data']);
        log('requested trip id after : ${rideRequestTripModel.id}');
        return Right(rideRequestTripModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideRequestTripEntity>>
      retrieveClientLatestTrip() async {
    // try {
      final response = await _apiConsumer.get(
        EndPoints.retrieveClientLatestTrip,
      );

      return response.fold((failure) => Left(failure), (data) {
        log('latest trip id before : ${data['data']['latestTrip']['tripId']}');
        RideRequestTripModel rideRequestTripModel = RideRequestTripModel.fromJson(data['data']['latestTrip']);
        log('latest trip id after : ${rideRequestTripModel.id}');
        return Right(rideRequestTripModel);
      });
    // } catch (e) {
    //   log( "latest trip error $e");
    //   return Left(ServerFailure(message: e.toString()));
    // }
  }

  @override
  Future<Either<Failure, bool>> checkRealAmountEnough(double params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.checkWalletEnough,
        data: {"amount": params},
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['data'] ?? false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideExpectedPriceEntity>> getExpectedPrice(
      RideExpectedPriceParams params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.getExpectedPrice(params.id),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        log("55555555555555555555555555");
        RideExpectedPriceModel rideExpectedPriceModel =
            RideExpectedPriceModel.fromJson(data['data']);
        log("777777777.55555555555555");
        return Right(rideExpectedPriceModel);
      });
    } catch (e) {
      log(e.toString());
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideDriverStatisticsEntity>>
      getDriverStatistics() async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getDriverStatistics,
      );

      return response.fold((failure) => Left(failure), (data) {
        RideDriverStatisticsModel rideDriverStatisticsModel =
            RideDriverStatisticsModel.fromJson(data['data']);
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
        return Right(data['status'] ?? false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RideBrandEntity>>> getRideBrands() async {
    try {
      final response =
          await _apiConsumer.get(EndPoints.getRideBrands, );

      return response.fold((failure) => Left(failure), (data) {
        return Right((data['data'] != null || data['data']['carBrands'].isNotEmpty)
            ? List<RideBrandModel>.from(data['data']['carBrands'].map((e) =>RideBrandModel.fromJson(e)))
            : []);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RideModelEntity>>> getRideModels(String brand) async {
    try {
      final response = await _apiConsumer
          .get(EndPoints.getRideModels(brand));

      return response.fold((failure) => Left(failure), (data) {
        return Right((data['data'] != null || data['data']['carModels'].isNotEmpty)
            ? List<RideCarModelModel>.from(data['data']['carModels'].map((e) => RideCarModelModel.fromJson(e)))
            : []);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RideModelEntity>>> getRideShippingModels(String brand) async {
    try {
      final response = await _apiConsumer
          .get(EndPoints.getRideShippingModels(brand));

      return response.fold((failure) => Left(failure), (data) {
        return Right((data['data'] != null || data['data']['trackCarModels'].isNotEmpty)
            ? List<RideCarModelModel>.from(data['data']['trackCarModels'].map((e) => RideCarModelModel.fromJson(e)))
            : []);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RideModelEntity>>> getRideNonTrackingModels(String brand) async {
    try {
      final response = await _apiConsumer
          .get(EndPoints.getRideNonTrackingModels(brand));

      return response.fold((failure) => Left(failure), (data) {
        return Right((data['data'] != null || data['data']['busCarModels'].isNotEmpty)
            ? List<RideCarModelModel>.from(data['data']['busCarModels'].map((e) => RideCarModelModel.fromJson(e)))
            : []);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CarYearsAndTypesEntity>>> getCarYearsAndTypes(
      GetCarYearsAndTypesParams params) async {
    try {
      final response = await _apiConsumer.get(EndPoints.getCarYearsAndTypes,
          queryParameters: params.toJson());

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
  Future<Either<Failure, DriverInfoEntity>> getRideDriverInfo(
      bool refresh) async {
    try {
      final response =
          await _apiConsumer.get(EndPoints.getRideDriverInfo, refresh: refresh);

      return response.fold((failure) => Left(failure), (data) {
        return Right(DriverInfoModel.fromJson(data['data']));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DriverPictureOptionalEntity>>
      getDriverPictureOptional() async {
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
          log('Running Trip trip id: ${trip['tripDetails']?['id']}');
          runningTrips.add(RunningTripsModel.fromJson(trip));
          log('Running Trip length: ${runningTrips.length}');
        }
        return Right(runningTrips);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HistoryTripsEntity>>> getAllHistoryTrips(
      GetAllHistoryTripsUseCaseParams params) async {
    // try {
      final response = await _apiConsumer.get(
        EndPoints.getAllHistoryTrips(limit: params.limit, page: params.page),
      );

      return response.fold((failure) => Left(failure), (data) {
        List<HistoryTripsModel> historyTrips = [];
        for (Map<String, dynamic> trip in data['data']['trips']) {
          log('History Trip trip id: ${trip['tripDetails']?['id']}');
          historyTrips.add(HistoryTripsModel.fromJson(trip));
          log('History Trip length: ${historyTrips.length}');
        }
        return Right(historyTrips);
      });
    // } catch (e) {
    //   log('History Trip error: $e');
    //   return Left(ServerFailure(message: e.toString()));
    // }
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
          log('Completed Trip trip id: ${trip['tripDetails']?['id']}');
          completedTrips.add(CompletedTripsModel.fromJson(trip));
          log('Completed Trip length: ${completedTrips.length}');
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
  Future<Either<Failure, bool>> finalizeTripByRider(
      String params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.finalizeTripByRider(params),
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
  Future<Either<Failure, List<HistoryTripForUserEntity>>>
      getAllHistoryTripsForUser() async {
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
  Future<Either<Failure, List<HistoryTripForRiderEntity>>>
      getAllHistoryTripsForRider(
          GetAllHistoryTripsForRiderUseCaseParams params) async {
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
  Future<Either<Failure, CostPerKmEntity>> getCostPerKm() async {
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
  Future<Either<Failure, bool>> loadingRegister(
      LoadingRegisterEntity params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.loadingRegister,
        data: params.toJson(),
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status'] ?? false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoadingInfoEntity>> getLoadingInfo(
      bool refresh) async {
    try {
      final response =
          await _apiConsumer.get(EndPoints.getLoadingInfo, refresh: refresh);

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
        return Right(data['status'] ?? false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AvailableRideTripEntity>>> getAvailableRideTrips(
      AvailableRideTripsUseCaseParams params) async {
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
  Future<Either<Failure, bool>> listenToUpdateLocation(
      UpdateSocketLocationParams params) async {
    try {
      CliLogger.info('Listen To Update Location');
      SharedWebSocket.socket!.emit(SocketIOEvents.updateDriverLocation, {
        "location": {"longitude": params.longitude, "latitude": params.latitude}
      });
      CliLogger.info(
          "SocketIOEvents.updateDriverLocation${SocketIOEvents.updateDriverLocation}");

      return const Right(true);
    } catch (e) {
      CliLogger.error('can\'t Update Location error $e');
      return const Left(ServerFailure(message: "can't Update Location "));
    }
  }

  @override
  Future<Either<Failure, bool>> watchingTripsParams(WatchingTripsParams params) async {
    try {
      CliLogger.info('Listen To Watching Trips');
      CliLogger.info('Listen To Watching Trips ${params.toJson()}');
      SharedWebSocket.socket!.emit(SocketIOEvents.watchingTrips, params.toJson());
      CliLogger.info(
          "SocketIOEvents.watchingTrips${SocketIOEvents.watchingTrips}");

      return const Right(true);
    } catch (e) {
      CliLogger.error('can\'t Watching Trips error $e');
      return const Left(ServerFailure(message: "can't Watching Trips "));
    }
  }

  @override
  Future<Either<Failure, bool>> makeNonTrackingRequestTrip(
      MakeNonTrackingRequestTripUsecaseParam params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.makeNonTrackingTripRequest,
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
  Future<Either<Failure, RideRequestTripEntity>> acceptOfferByClient(
      String offerId) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.acceptOfferByClient(offerId),
      );
      return response.fold((failure) => Left(failure), (data) {
        log('accepted trip id before : ${data['data']['tripId']}');
        RideRequestTripModel rideRequestTripModel = RideRequestTripModel.fromJson(data['data']);
        log('accepted trip id after : ${rideRequestTripModel.id}');
        return Right(rideRequestTripModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateTripAutoAcceptByClient(
      UpdateTripAutoAcceptByClientUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.updateTripAutoAcceptByClient(),
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
  Future<Either<Failure, GetOffersResponseEntity>> getClientOffers() async {
    try {
      final response = await _apiConsumer.get(EndPoints.getClientOffers);

      return response.fold((failure) => Left(failure), (data) {
        GetOffersResponseModel getOffersResponse =
            GetOffersResponseModel.fromJson(data);
        return Right(getOffersResponse);
      });
    } catch (e) {
      print("e.toString ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> makeLoadingRequestTrip(
      MakeLoadingRequestTripUsecaseParam params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.makeLoadingTripRequest,
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
  Future<Either<Failure, GetOffersResponseEntity>> getLoadingOffers() async {
    try {
      final response = await _apiConsumer.get(EndPoints.getLoadingOffers);

      return response.fold((failure) => Left(failure), (data) {
        GetOffersResponseModel getOffersResponse =
            GetOffersResponseModel.fromJson(data);
        return Right(getOffersResponse);
      });
    } catch (e) {
      print("e.toString ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateTripPrice(UpdateTripPriceUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.updateTripPrice(),
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
  Future<Either<Failure, ClickEntity>> click(ClickParams params) async {
    final response =
    await _apiConsumer.post(EndPoints.clickGlobal, data: params.toJson());
    return response.fold(
            (failure) => Left(failure), (data) => Right(ClickModel.fromJson(data)));
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> createNonTrackTrip(CreateNonTrackTripParams params) async{
    final url = EndPoints.createNonTrackTrip;

    final response = await _apiConsumer.post(url,data: params.toJson());

    return response.fold(
          (l) => Left(l),
          (data) {
            final createNonTrackTrip = CreateNonTrackTripModel.fromJson(data);
            return Right(createNonTrackTrip);
      },
    );
    // montasermohamed101@gmail.com
  }

  @override
  Future<Either<Failure, List<ClientPendingTripEntity>>> getClientPendingUntrackedTrips({
    required ClientPendingTripParams params,
  }) async {
    final url =
        "${EndPoints.getClientPendingUntrackedTrips}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
            print("Test Data by Dev montasermohamed100@gmail.com");
        final tripsData = (data['data']['pendingTrips'] as List)
            .map((e) => ClientPendingTripModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, List<ClientPendingTripEntity>>> getClientPendingShippingTrips({
    required ClientPendingTripParams params,
  }) async {
    final url =
        "${EndPoints.getClientPendingShippingTrips}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
            print("Test Data by Dev montasermohamed100@gmail.com");
        final tripsData = (data['data']['pendingTrips'] as List)
            .map((e) => ClientPendingTripModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> cancelNonTrackTrip(CancelNonTrackTripParams params) async{
    const url = EndPoints.cancelClientUntrackedTrips;

    final body = {
      "tripIds": params.tripsIds,
    };


    final response = await _apiConsumer.delete(
      url,
      data: body,
    );

    return response.fold(
          (l) => Left(l),
          (data) {
        final deleteTrip = CreateNonTrackTripModel.fromJson(data);
        return Right(deleteTrip);
      },
    );
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> cancelShippingTrip(CancelNonTrackTripParams params) async{
    final response = await _apiConsumer.delete(
      EndPoints.cancelShippingTrip(params.tripsIds[0]),
    );

    return response.fold(
          (l) => Left(l),
          (data) {
        final deleteTrip = CreateNonTrackTripModel.fromJson(data);
        return Right(deleteTrip);
      },
    );
  }

  @override
  Future<Either<Failure, List<ClientAcceptedTripEntity>>> getClientAcceptedUntrackedTrips({required ClientPendingTripParams params})async {
    final url =
        "${EndPoints.getClientAcceptedUntrackedTrips}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripsData = (data['data']['acceptedTrips'] as List)
            .map((e) => ClientAcceptedTripModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, List<ClientAcceptedTripEntity>>> getClientAcceptedShippingTrips({required ClientPendingTripParams params})async {
    final url =
        "${EndPoints.getClientAcceptedShippingTrips}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripsData = (data['data']['trips'] as List)
            .map((e) => ClientAcceptedTripModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, List<ClientOfferTripEntity>>> getClientOfferUntrackedTrips({required ClientPendingTripParams params}) async{
    final url =
        "${EndPoints.getClientOfferUntrackedTrips}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripsData = (data['data']['offers'] as List)
            .map((e) => ClientOfferTripModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, List<ClientOfferTripEntity>>> getClientOfferShippingTrips({required ClientPendingTripParams params}) async{
    final url =
        "${EndPoints.getClientOfferShippingTrips}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripsData = (data['data']['offers'] as List)
            .map((e) => ClientOfferTripModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> acceptNonTrackTrip(AcceptNonTrackTripParams params) async{
    final url = "${EndPoints.acceptClientUntrackedTrips}${params.tripsId}";
    final response = await _apiConsumer.put(
      url,
    );
    return response.fold(
          (l) => Left(l),
          (data) {
        final deleteTrip = CreateNonTrackTripModel.fromJson(data);
        return Right(deleteTrip);
      },
    );
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> acceptShippingTrip(AcceptNonTrackTripParams params) async{
    final url = "${EndPoints.acceptClientShippingTrips}${params.tripsId}";
    final response = await _apiConsumer.put(
      url,
    );
    return response.fold(
          (l) => Left(l),
          (data) {
        final deleteTrip = CreateNonTrackTripModel.fromJson(data);
        return Right(deleteTrip);
      },
    );
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> refuseNonTrackTrip(AcceptNonTrackTripParams params) async{
    final url = "${EndPoints.refuseClientUntrackedTrips}${params.tripsId}";
    final response = await _apiConsumer.delete(
      url,
    );
    return response.fold(
          (l) => Left(l),
          (data) {
        final deleteTrip = CreateNonTrackTripModel.fromJson(data);
        return Right(deleteTrip);
      },
    );
  }
  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> refuseShippingTrip(AcceptNonTrackTripParams params) async{
    final url = "${EndPoints.refuseClientShippingTrips}${params.tripsId}";
    final response = await _apiConsumer.delete(
      url,
    );
    return response.fold(
          (l) => Left(l),
          (data) {
        final deleteTrip = CreateNonTrackTripModel.fromJson(data);
        return Right(deleteTrip);
      },
    );
  }

  @override
  Future<Either<Failure, List<ClientPastTripEntity>>> getClientPastUntrackedTrips({required ClientPendingTripParams params}) async{
    final url =
        "${EndPoints.getClientPastUntrackedTrips}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripsData = (data['data']['pastTrips'] as List)
            .map((e) => ClientPastTripModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, List<ClientPastTripEntity>>> getClientPastShippingTrips({required ClientPendingTripParams params}) async{
    final url =
        "${EndPoints.getClientPastShippingTrips}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripsData = (data['data']['pastTrips'] as List)
            .map((e) => ClientPastTripModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity>> createNonTrackOffer(CreateNonTrackOfferParams params) async{
    final url = "${EndPoints.createOfferNonTrackedTrips}${params.tripId}";
    final response = await _apiConsumer.post(
      url,
      data: params.toJson()
    );
    return response.fold(
          (l) => Left(l),
          (data) {
        final createOffer = CreateNonTrackOfferModel.fromJson(data);
        return Right(createOffer);
      },
    );
  }


  @override
  Future<Either<Failure, UpdateDriverSettingsEntity>> updateDriverSettings(UpdateDriverSettingsParams params)async {
    final url = EndPoints.updateDriverSettingsNonTrack;
    final response = await _apiConsumer.put(
        url,
        data: params.toJson()
    );
    return response.fold(
          (l) => Left(l),
          (data) {
        final updateDriver = UpdateDriverSettingsModel .fromJson(data);
        return Right(updateDriver);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> sendOkIamComing() async{
    const url = EndPoints.sendOkIamComing;
    final response = await _apiConsumer.get(
      url,
    );
    return response.fold(
          (l) => Left(l),
          (data) {
        return const Right(true);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> ratingDriverByClient(RatingDriverByClientUseCaseParams params) async{
    const url = EndPoints.ratingDriverByClient;

    final response = await _apiConsumer.post(
      url,
      data: params.toJson(),
    );

    return response.fold(
          (l) => Left(l),
          (r) {
        return const Right(true);
      },
    );
  }

  @override
  void listenToOfferUpdateUntrackedTrip(Function(ClientOfferTripEntity offer) params) {
    try {
      CliLogger.info("Listen to  Update Offer  Trip ");
      log("Listen to Update Offer Trip Trip ");
      SharedWebSocket.socket!.on(SocketIOListeners.rideUpdateOfferUntrackedClientTrip, (data) {
        CliLogger.info(" Update Offer Trip data :  $data");
        log(" Update Offer Trip data :  $data");
        print(" Update Offer Trip data :  $data");
        params(ClientOfferTripModel.fromJson(data["offersUpdated"]));
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  void listenToOfferUpdateShippingTrip(Function(ClientOfferTripEntity offer) params) {
    try {
      CliLogger.info("Listen to  Update Offer  Trip  ${SocketIOListeners.rideUpdateOfferShippingClientTrip}");
      log("Listen to Update Offer Trip Trip ");
      SharedWebSocket.socket!.on(SocketIOListeners.rideUpdateOfferShippingClientTrip, (data) {
        CliLogger.info(" Update Offer Trip data :  $data");
        log(" Update Offer Trip data :  $data");
        print(" Update Offer Trip data :  $data");
        params(ClientOfferTripModel.fromJson(data["offersUpdated"]));
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  Future<Either<Failure, String>> addCarModel(AddCarModelParams params) async {
    final response = await _apiConsumer.post(
        EndPoints.addCarModel,
        data: params.toJson(),
    );
    return response.fold(
          (l) => Left(l),
          (data) {
        return Right(data['data']['modelId']??'');
      },
    );
  }

  @override
  Future<Either<Failure, String>> addCarBrand(String params) async {
    final response = await _apiConsumer.post(
        EndPoints.addCarBrand,
        data: {
          'brandName':params
        },
    );
    return response.fold(
          (l) => Left(l),
          (data) {
        return Right(data['data']['brandId']??'');
      },
    );
  }

  @override
  Future<Either<Failure, RateResponseEntity>> addRateWithClient(AddRateWithDriverParams params)async {
    final url = EndPoints.addRateToDriverWithClientNonSocket;

    final response = await _apiConsumer.post(url,data: params.toJson());

    return response.fold(
          (l) => Left(l),
          (data) {
        final rateData = RateResponseModel.fromJson(data);
        return Right(rateData);
      },
    );
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> updateClientRateNonSocket(UpdateClientRateParams params) async {
    final url = EndPoints.updateClientRating;

    final response = await _apiConsumer.put(url,data: params.toJson());

    return response.fold(
          (l) => Left(l),
          (data) {
        final rateData = CreateNonTrackTripModel.fromJson(data);
        return Right(rateData);
      },
    );
  }

  @override
  Future<Either<Failure, DriverAllRatingEntity>> getDriverAllRating(DriverAllRatingParams params) async{
    final url = "${EndPoints.getDriverAllRating}/${params.id}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rateData = DriverAllRatingModel.fromJson(data);
        return Right(rateData);
      },
    );
  }

  @override
  Future<Either<Failure, ClientAllRatingEntity>> getClientAllRating(DriverAllRatingParams params) async{
    final url = "${EndPoints.getClientAllRating}/${params.id}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rateData = ClientAllRatingModel.fromJson(data);
        return Right(rateData);
      },
    );
  }

  @override
  Future<Either<Failure, String>> getAvailableMapCountry() async {
    final response = await _apiConsumer.get(
      EndPoints.getAvailableMapCountry,
    );
    return response.fold(
          (l) => Left(l),
          (data) {
        return Right(data['data']?['availableMap']?['code']?.toString().toLowerCase()??'eg');
      },
    );
  }
// montasermohamed100@gmail.com
}
