import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/data/datasources/ride_remote_data_source.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/activity_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/car_years_and_types_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/check_driver_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/client/client_all_rating_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/client/unread_offers_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/cost_per_km_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/create_no_track_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/create_non_track_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_driver_settings_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_picture_optional_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_statistics_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/drivers_in_subcategory_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_client_accepted_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_client_offer_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_client_past_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_client_pending_trips_entity.dart';
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
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_model_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_request_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/accept_non_track_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/add_car_model_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_non_track_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_pending_trip_by_client_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/click_global_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/client_trips/get_driver_all_rating_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/client_trips/update_client_rate_non_socket_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/create_non_track_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/add_rate_with_driver_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/watching_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/create_non_track_offer_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/update_driver_settings_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_history_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_car_years_and_types_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_client_pending_untracked_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/make_loading_request_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_trip_auto_accept_by_client_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_categories_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_socket_location_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_trip_price_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/rate_response_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/accept_trip_by_driver_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_trip_by_client.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_trip_by_rider.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/complete_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_activity_trips.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_completed_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_history_trips_for_rider_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_running_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_location_from_address_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/partial_payment_in_trip.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/recording_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/rider_in_start_location_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/start_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_driver_location_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_trip_price_from_client_use_case.dart';

import '../../../../core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_ride_trips_use_case.dart';

import '../../domain/entities/client/driver_all_rating_entity.dart';
import '../../domain/entities/driver_ratings_entity.dart';
import '../../domain/entities/get_offers_entity.dart';
import '../../domain/usecases/make_non_tracking_request_trip_usecase.dart';

import '../../../account_taps/my_adds/domain/entity/click_entity.dart';
import '../../domain/usecases/rating_driver_by_client.dart';

class RideRepositoryImplementation extends RideRepository {
  final RideRemoteDataSource rideRemoteDataSource;

  RideRepositoryImplementation(this.rideRemoteDataSource);

  ////////////////////////////Nasr//////////////////////////

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(
      GetRideCategoriesParams params) async {
    return await rideRemoteDataSource.getRideCategories(params);
  }

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(
      GetRideCategoriesParams params) async {
    return await rideRemoteDataSource.getShippingCategories(params);
  }

  @override
  Future<Either<Failure, CheckDriverTypeEntity>> checkDriverType() async {
    return await rideRemoteDataSource.checkDriverType();
  }

  @override
  Future<Either<Failure, bool>> registerRideNotSpecial(
      RegisterRideNotSpecialEntity params) async {
    return await rideRemoteDataSource.registerRideNotSpecial(params);
  }

  @override
  Future<Either<Failure, bool>> registerRideSpecial(
      RegisterRideSpecialEntity params) async {
    return await rideRemoteDataSource.registerRideSpecial(params);
  }

  @override
  Future<Either<Failure, List<DriversInSubcategoryEntity>>>
      getDriversInSubcategory(String subCategoryId) async {
    return await rideRemoteDataSource.getDriversInSubcategory(subCategoryId);
  }

  @override
  Future<Either<Failure, RideRequestTripEntity>> requestTrip(
      RequestTripUseCaseParams params) async {
    return await rideRemoteDataSource.requestTrip(params);
  }

  @override
  Future<Either<Failure, RideRequestTripEntity>>
      retrieveClientLatestTrip() async {
    return await rideRemoteDataSource.retrieveClientLatestTrip();
  }

  @override
  Future<Either<Failure, bool>> checkRealAmountEnough(double params) async {
    return await rideRemoteDataSource.checkRealAmountEnough(params);
  }

  @override
  Future<Either<Failure, RideExpectedPriceEntity>> getExpectedPrice(
      RideExpectedPriceParams params) async {
    return await rideRemoteDataSource.getExpectedPrice(params);
  }

  @override
  Future<Either<Failure, RideDriverStatisticsEntity>>
      getDriverStatistics() async {
    return await rideRemoteDataSource.getDriverStatistics();
  }

  @override
  Future<Either<Failure, bool>> deleteRideRegistration() async {
    return await rideRemoteDataSource.deleteRideRegistration();
  }

  @override
  Future<Either<Failure, List<RideBrandEntity>>> getRideBrands() async {
    return await rideRemoteDataSource.getRideBrands();
  }

  @override
  Future<Either<Failure, List<RideModelEntity>>> getRideModels(String brand) async {
    return await rideRemoteDataSource.getRideModels(brand);
  }

  @override
  Future<Either<Failure, List<RideModelEntity>>> getRideShippingModels(String brand) async {
    return await rideRemoteDataSource.getRideShippingModels(brand);
  }

  @override
  Future<Either<Failure, List<RideModelEntity>>> getRideNonTrackingModels(String brand) async {
    return await rideRemoteDataSource.getRideNonTrackingModels(brand);
  }

  @override
  Future<Either<Failure, String>> addCarModel(AddCarModelParams params) async {
    return await rideRemoteDataSource.addCarModel(params);
  }

  @override
  Future<Either<Failure, String>> addCarBrand(String params) async {
    return await rideRemoteDataSource.addCarBrand(params);
  }

  @override
  Future<Either<Failure, List<CarYearsAndTypesEntity>>> getCarYearsAndTypes(
      GetCarYearsAndTypesParams params) async {
    return await rideRemoteDataSource.getCarYearsAndTypes(params);
  }

  @override
  Future<Either<Failure, List<RideColorEntity>>> getRideCarColors() async {
    return await rideRemoteDataSource.getRideCarColors();
  }

  @override
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates() async {
    return await rideRemoteDataSource.getGovernorates();
  }

  @override
  Future<Either<Failure, DriverInfoEntity>> getRideDriverInfo(
      bool refresh) async {
    return await rideRemoteDataSource.getRideDriverInfo(refresh);
  }

  @override
  Future<Either<Failure, DriverPictureOptionalEntity>>
      getDriverPictureOptional() async {
    return await rideRemoteDataSource.getDriverPictureOptional();
  }

  @override
  Future<Either<Failure, bool>> updateDriverLocation(
      UpdateDriverLocationUseCaseParams params) async {
    return await rideRemoteDataSource.updateDriverLocation(params);
  }

  @override
  Future<Either<Failure, List<RunningTripsEntity>>> getAllRunningTrips(
      GetAllRunningTripsUseCaseParams params) async {
    return await rideRemoteDataSource.getAllRunningTrips(params);
  }

  @override
  Future<Either<Failure, List<CompletedTripsEntity>>> getAllCompletedTrips(
      GetAllCompletedTripsUseCaseParams params) async {
    return await rideRemoteDataSource.getAllCompletedTrips(params);
  }

  @override
  Future<Either<Failure, GetLocationFromAddressEntity>> getLocationFromAddress(
      GetLocationFromAddressUseCaseParams params) async {
    return await rideRemoteDataSource.getLocationFromAddress(params);
  }

  @override
  Future<Either<Failure, bool>> acceptTripByDriver(
      AcceptTripByDriverUseCaseParams params) async {
    return await rideRemoteDataSource.acceptTripByDriver(params);
  }

  @override
  Future<Either<Failure, bool>> riderInStartLocation(
      RiderInStartLocationUseCaseParams params) async {
    return await rideRemoteDataSource.riderInStartLocation(params);
  }

  @override
  Future<Either<Failure, bool>> startTrip(StartTripUseCaseParams params) async {
    return await rideRemoteDataSource.startTrip(params);
  }

  @override
  Future<Either<Failure, bool>> partialPaymentInTrip(
      PartialPaymentInTripUseCaseParams params) async {
    return await rideRemoteDataSource.partialPaymentInTrip(params);
  }

  @override
  Future<Either<Failure, bool>> completeTrip(
      CompleteTripUseCaseParams params) async {
    return await rideRemoteDataSource.completeTrip(params);
  }

  @override
  Future<Either<Failure, bool>> cancelTripByRider(
      CancelTripByRiderUseCaseParams params) async {
    return await rideRemoteDataSource.cancelTripByRider(params);
  }

  @override
  Future<Either<Failure, bool>> finalizeTripByRider(
      String params) async {
    return await rideRemoteDataSource.finalizeTripByRider(params);
  }

  @override
  Future<Either<Failure, bool>> cancelTripByClient(
      CancelTripByClientUseCaseParams params) async {
    return await rideRemoteDataSource.cancelTripByClient(params);
  }

  @override
  Future<Either<Failure, bool>> cancelPendingTripByClient(
      CancelPendingTripByClientUseCaseParams params) async {
    return await rideRemoteDataSource.cancelPendingTripByClient(params);
  }

  @override
  Future<Either<Failure, bool>> recordingTrip(
      RecordingTripUseCaseParams params) async {
    return await rideRemoteDataSource.recordingTrip(params);
  }

  @override
  Future<Either<Failure, bool>> updateTripPriceFromClient(
      UpdateTripPriceFromClientUseCaseParams params) async {
    return await rideRemoteDataSource.updateTripPriceFromClient(params);
  }

  @override
  Future<Either<Failure, ActivityTripEntity>> getAllActivityTrips(
      GetAllActivityTripsUseCaseParams params) async {
    return await rideRemoteDataSource.getAllActivityTrips(params);
  }

  @override
  Future<Either<Failure, List<HistoryTripForUserEntity>>>
      getAllHistoryTripsForUser() async {
    return await rideRemoteDataSource.getAllHistoryTripsForUser();
  }

  @override
  Future<Either<Failure, List<HistoryTripForRiderEntity>>>
      getAllHistoryTripsForRider(
          GetAllHistoryTripsForRiderUseCaseParams params) async {
    return await rideRemoteDataSource.getAllHistoryTripsForRider(params);
  }

  @override
  Future<Either<Failure, CostPerKmEntity>> getCostPerKm() async {
    return await rideRemoteDataSource.getCostPerKm();
  }

  @override
  Future<Either<Failure, bool>> loadingRegister(
      LoadingRegisterEntity params) async {
    return await rideRemoteDataSource.loadingRegister(params);
  }

  @override
  Future<Either<Failure, LoadingInfoEntity>> getLoadingInfo(
      bool refresh) async {
    return await rideRemoteDataSource.getLoadingInfo(refresh);
  }

  @override
  Future<Either<Failure, bool>> makeRequestTrip() async {
    return await rideRemoteDataSource.makeRequestTrip();
  }

  @override
  Future<Either<Failure, List<AvailableRideTripEntity>>> getAvailableRideTrips(
      AvailableRideTripsUseCaseParams params) async {
    final data = await rideRemoteDataSource.getAvailableRideTrips(params);
    return data;
  }

  @override
  Future<Either<Failure, bool>> makeNonTrackingRequestTrip(
      MakeNonTrackingRequestTripUsecaseParam params) async {
    return await rideRemoteDataSource.makeNonTrackingRequestTrip(params);
  }

  @override
  Future<Either<Failure, bool>> listenToUpdateLocation(
      UpdateSocketLocationParams params) async {
    final data = await rideRemoteDataSource.listenToUpdateLocation(params);
    return data;
  }

  @override
  Future<Either<Failure, GetOffersResponseEntity>> getClientOffers() async{
    return await rideRemoteDataSource.getClientOffers();
  }

  @override
  void listenToRideOffers(Function(RideOfferEntity offer) params) {
    rideRemoteDataSource.listenToRideOffers(params);
  }

  @override
  Future<Either<Failure, RideRequestTripEntity>> acceptOfferByClient(String params) {
    return rideRemoteDataSource.acceptOfferByClient(params);
  }

  @override
  Future<Either<Failure, bool>> updateTripAutoAcceptByClient(UpdateTripAutoAcceptByClientUseCaseParams params) async{
    return await rideRemoteDataSource.updateTripAutoAcceptByClient(params);
  }

  @override
  Future<Either<Failure, bool>> makeLoadingRequestTrip(MakeLoadingRequestTripUsecaseParam params) async{
    return await rideRemoteDataSource.makeLoadingRequestTrip(params);
  }

  @override
  Future<Either<Failure, GetOffersResponseEntity>> getLoadingOffers() async{
    return await rideRemoteDataSource.getLoadingOffers();
  }

  @override
  Future<Either<Failure, bool>> updateTripPrice(UpdateTripPriceUseCaseParams params) {
    return rideRemoteDataSource.updateTripPrice(params);
  }

  @override
  Future<Either<Failure, ClickEntity>> click(ClickParams params) {
    return rideRemoteDataSource.click(params);
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> createNonTrackTrip(CreateNonTrackTripParams params) async{
    return rideRemoteDataSource.createNonTrackTrip(params);
  }

  @override
  Future<Either<Failure, List<ClientPendingTripEntity>>> getClientPendingUntrackedTrips({required ClientPendingTripParams params}) {
    return rideRemoteDataSource.getClientPendingUntrackedTrips(params: params);
  }

  @override
  Future<Either<Failure, List<ClientPendingTripEntity>>> getClientPendingShippingTrips({required ClientPendingTripParams params}) {
    return rideRemoteDataSource.getClientPendingShippingTrips(params: params);
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> cancelNonTrackTrip(CancelNonTrackTripParams params) {
    return rideRemoteDataSource.cancelNonTrackTrip(params);
  }

  @override
  Future<Either<Failure, List<ClientAcceptedTripEntity>>> getClientAcceptedUntrackedTrips({required ClientPendingTripParams params}) {
    return rideRemoteDataSource.getClientAcceptedUntrackedTrips(params: params);
  }

  @override
  Future<Either<Failure, List<ClientAcceptedTripEntity>>> getClientAcceptedShippingTrips({required ClientPendingTripParams params}) {
    return rideRemoteDataSource.getClientAcceptedShippingTrips(params: params);
  }

  @override
  Future<Either<Failure, List<ClientOfferTripEntity>>> getClientOfferUntrackedTrips({required ClientPendingTripParams params}) {
    return rideRemoteDataSource.getClientOfferUntrackedTrips(params: params);
  }
  @override
  Future<Either<Failure, List<ClientOfferTripEntity>>> getClientOfferShippingTrips({required ClientPendingTripParams params}) {
    return rideRemoteDataSource.getClientOfferShippingTrips(params: params);
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> acceptNonTrackTrip(AcceptNonTrackTripParams params) {
    return rideRemoteDataSource.acceptNonTrackTrip( params);
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> acceptShippingTrip(AcceptNonTrackTripParams params) {
    return rideRemoteDataSource.acceptShippingTrip( params);
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> refuseNonTrackTrip(AcceptNonTrackTripParams params) {
    return rideRemoteDataSource.refuseNonTrackTrip( params);
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> refuseShippingTrip(AcceptNonTrackTripParams params) {
    return rideRemoteDataSource.refuseShippingTrip( params);
  }

  @override
  Future<Either<Failure, List<ClientPastTripEntity>>> getClientPastUntrackedTrips({required ClientPendingTripParams params}) {
    return rideRemoteDataSource.getClientPastUntrackedTrips( params: params);
  }

  @override
  Future<Either<Failure, List<ClientPastTripEntity>>> getClientPastShippingTrips({required ClientPendingTripParams params}) {
    return rideRemoteDataSource.getClientPastShippingTrips( params: params);
  }

  @override
  Future<Either<Failure, bool>> emitWatchingTrips(WatchingTripsParams params) async {
    final data = await rideRemoteDataSource.watchingTripsParams(params);
    return data;
  }

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity>> createNonTrackOffer(CreateNonTrackOfferParams params) {
  return rideRemoteDataSource.createNonTrackOffer(params);
  }

  @override
  Future<Either<Failure, UpdateDriverSettingsEntity>> updateDriverSettings(UpdateDriverSettingsParams params) {
    return rideRemoteDataSource.updateDriverSettings(params);

  }

  @override
  Future<Either<Failure, bool>> sendOkIamComing() {
    return rideRemoteDataSource.sendOkIamComing();
  }

  @override
  Future<Either<Failure, bool>> ratingDriverByClient(RatingDriverByClientUseCaseParams params) async {
    return rideRemoteDataSource.ratingDriverByClient(params);
  }

  @override
  void listenToOfferUpdateUntrackedTrip(Function(ClientOfferTripEntity offer) params) {
    return rideRemoteDataSource.listenToOfferUpdateUntrackedTrip(params);
  }

  @override
  void listenToOfferUpdateShippingTrip(Function(ClientOfferTripEntity offer) params) {
    return rideRemoteDataSource.listenToOfferUpdateShippingTrip(params);
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> cancelShippingTrip(CancelNonTrackTripParams params) async {
    final data = await rideRemoteDataSource.cancelShippingTrip(params);
    return data;
  }
  @override
  Future<Either<Failure, List<HistoryTripsEntity>>> getAllHistoryTrips(GetAllHistoryTripsUseCaseParams params) async {
    return await rideRemoteDataSource.getAllHistoryTrips(params);
  }

  @override
  Future<Either<Failure, String>> getAvailableMapCountry() async {
    return await rideRemoteDataSource.getAvailableMapCountry();
  }


  @override
  Future<Either<Failure, RateResponseEntity>> addRateWithClient(AddRateWithDriverParams params) {
    return rideRemoteDataSource.addRateWithClient(params);
  }


  @override
  Future<Either<Failure, bool>> readLoadingOffer(String params) {
    return rideRemoteDataSource.readLoadingOffer(params);
  }


  @override
  Future<Either<Failure, bool>> readNonTrackingOffer(String params) {
    return rideRemoteDataSource.readNonTrackingOffer(params);
  }

  @override
  Future<Either<Failure, UnreadOffersEntity>> getUnreadOffers() {
    return rideRemoteDataSource.getUnreadOffers();
  }

  @override
  Future<Either<Failure, CreateNonTrackTripEntity>> updateClientRateNonSocket(UpdateClientRateParams params) {
    return rideRemoteDataSource.updateClientRateNonSocket(params);
  }

  @override
  Future<Either<Failure, DriverAllRatingEntity>> getDriverAllRating(params) {
    return rideRemoteDataSource.getDriverAllRating(params);
  }

  @override
  Future<Either<Failure, ClientAllRatingEntity>> getClientAllRating(DriverAllRatingParams params) {
    return rideRemoteDataSource.getClientAllRating(params);
  }

  @override
  Future<Either<Failure, DriverRatingsEntity>> getDriverRatings({required String driverId}) async {
    return await rideRemoteDataSource.getDriverRatings(driverId: driverId);
  }


  @override
  Future<Either<Failure, void>> rejectOfferByClient({required String offerId}) async {
    return await rideRemoteDataSource.rejectOfferByClient(offerId: offerId);
  }

}
