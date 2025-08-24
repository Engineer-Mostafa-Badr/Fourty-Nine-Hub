import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/loading/get_loading_accepted_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/accept_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/arrived_to_client_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/create_non_track_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/emergency_contact_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/support_details_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/driver_settings_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/get_accepted_ride_non_socket_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/get_available_ride_non_socket_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/get_past_ride_non_socket_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trips_response_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_auto_accept_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading/get_loading_history_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading/settings_driver_loading_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/client_trips/update_client_rate_non_socket_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/add_rate_with_driver_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/complete_ride_trip_with_price_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/create_driver_rating_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/create_non_track_offer_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/driver_rate_client_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/emergency_support_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_past_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_support_details_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/loading/create_rate_with_driver_loading_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/loading/update_driver_loading_settings_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/start_ride_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/update_settings_dashboard_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_client_pending_untracked_trips_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/rate_response_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/listen_to_client_coming_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_cancel_route_use_case.dart';

import '../../domain/entities/dashboards/settings_dashboard_entity.dart';
import '../../domain/entities/loading/get_loading_avaliable_entity.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import '../datasources/dashboard_remote_data_source.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;

  TripRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TripsResponseEntity>> getAvailableTrips(AvailableRideTripsUseCaseParams params) async {
    final tripsResponseModel = await remoteDataSource.getAvailableTrips(params);
    return tripsResponseModel;
  }

  @override
  Future<Either<Failure, TripsResponseEntity>> getPastTrips(GetPastTripsParams type) async {
    final tripsResponseModel = await remoteDataSource.getPastTrips(type);
    return tripsResponseModel;
  }
  
  @override
  Future<Either<Failure, SettingsDashboardEntityResponse>> getSettings() async{
    final settingsResponseModel = await remoteDataSource.getSettings();
    return settingsResponseModel;
  }

  @override
  Future<Either<Failure, bool>> updateSettings(UpdateSettingsDashboardUsecaseParam params) async{
    return await remoteDataSource.updateSettings(params);
  }

  @override
  Future<Either<Failure, bool>> createNewOffer(CreateNewOfferDashboardUsecaseParam params) async{
    return await remoteDataSource.createNewOffer(params);
  }
  @override
  Future<Either<Failure, bool>> createNewOfferNonSocket(CreateNewOfferDashboardUsecaseParam params) async{
    return await remoteDataSource.createNewOfferNonSocket(params);
  }

  @override
  Future<Either<Failure, bool>> createDriverRating(CreateUpdateDriverRatingUsecaseParam params) async{
   return await remoteDataSource.createDriverRating(params);
  }
  @override
  Future<Either<Failure, bool>> updateDriverRating(CreateUpdateDriverRatingUsecaseParam params) async{
   return await remoteDataSource.updateDriverRating(params);
  }

  @override
  Future<Either<Failure, bool>> acceptTrip(String params) async{
   return await remoteDataSource.acceptTrip(params);
  }

  @override
  void listenToUpdateTripAutoAccept(Function(UpdateTripAutoAcceptEntity trip) params) {
    remoteDataSource.listenToUpdateTripAutoAccept(params);
  }

  @override
  void listenToPartialPaymentDriver(Function(num amountPaidCash) params) {
    remoteDataSource.listenToPartialPaymentDriver(params);
  }

  @override
  void listenToAcceptOffer(Function(AcceptOfferEntity trip) params) {
    remoteDataSource.listenToAcceptOffer(params);
  }

  @override
  void listenToUpdateTripPrice(Function(UpdateTripPriceEntity trip) params) {
    remoteDataSource.listenToUpdateTripPrice(params);
  }

  @override
  void listenToNewTrip(Function(AvailableRideTripEntity trip) params) {
    remoteDataSource.listenToNewTrip(params);
  }

  @override
  void listenToRemoveTrip(Function(String tripId) params) {
    remoteDataSource.listenToRemoveTrip(params);
  }

  @override
  void listenToEndTrip(Function(String tripId) params) {
    remoteDataSource.listenToEndTrip(params);
  }

  @override
  void listenToClientComing(Function(String tripId) params) {
    remoteDataSource.listenToClientComing(params);
  }

  @override
  void listenToCancelRoute(Function(ListenToCancelRouteParams params) params) {
    remoteDataSource.listenToCancelRoute(params);
  }

  @override
  void listenToUpdateRoute(Function(MyBookingEntity route) params) {
    remoteDataSource.listenToUpdateRoute(params);
  }

  @override
  void listenToAcceptRoute(Function(MyBookingEntity route) params) {
    remoteDataSource.listenToAcceptRoute(params);
  }

  @override
  void listenToDriverTheOnWay(Function(MyBookingEntity route) params) {
    remoteDataSource.listenToDriverTheOnWay(params);
  }

  @override
  void listenToJoinAvailableRoutes(Function(bool isJoined) params) {
    remoteDataSource.listenToJoinAvailableRoutes(params);
  }

  @override
  void listenToLeaveAvailableRoutes(Function(String routeId) params) {
    remoteDataSource.listenToLeaveAvailableRoutes(params);
  }

  @override
  void listenToNewRoute(Function(MyBookingEntity newBooking) params) {
    remoteDataSource.listenToNewRoute(params);
  }

  @override
  void listenToNewRouteDriver(Function(MyBookingEntity newBooking) params) {
    remoteDataSource.listenToNewRouteDriver(params);
  }

  @override
  void listenToComingClient(Function(ListenToClientComingParams params) params) {
    remoteDataSource.listenToComingClient(params);
  }

  @override
  Future<Either<Failure, RunningTripEntity>> getRunningTrip() async{
    return await remoteDataSource.getRunningTrip();
  }

  @override
  Future<Either<Failure, RunningTripEntity>> goingToClient(String id) async{
    return await remoteDataSource.goingToClient(id);
  }

  @override
  Future<Either<Failure, bool>> arrivedToClient(ArrivedToClientEntity params) async{
    return await remoteDataSource.arrivedToClient(params);
  }

  @override
  Future<Either<Failure, String>> startDriverTrip(StartDriverTripParams params) async{
    return await remoteDataSource.startDriverTrip(params);
  }

  @override
  Future<Either<Failure, bool>> completeDriverTrip(StartDriverTripParams params) async{
    return await remoteDataSource.completeDriverTrip(params);
  }

  @override
  Future<Either<Failure, bool>> completeDriverTripWithRemainingMoney(CompleteDriverTripWithRemainingMoneyParams params) async{
    return await remoteDataSource.completeDriverTripWithRemainingMoney(params);
  }

  @override
  Future<Either<Failure, bool>> driverRateClient(DriverRateClientParams params) async {
    return await remoteDataSource.driverRateClient(params);
  }

  @override
  Future<Either<Failure, bool>> updateDriverRateClient(DriverRateClientParams params) async {
    return await remoteDataSource.updateDriverRateClient(params);
  }

  @override
  Future<Either<Failure, bool>> emergencySupport(EmergencySupportParams params) async {
    return await remoteDataSource.emergencySupport(params);
  }

  @override
  Future<Either<Failure, SupportDetailsEntity>> getSupportDetails(GetSupportDetailsParams params) async{
    return await remoteDataSource.getSupportDetails(params);
  }

  @override
  Future<Either<Failure, List<AvailableRideNonSocketTripEntity>>> getAvailableNonSocketTrips(ClientPendingTripParams params) {
    return  remoteDataSource.getAvailableNonSocketTrips(params);
  }

  @override
  Future<Either<Failure, List<AcceptedRideNonSocketTripEntity>>> getAcceptedNonSocketTrips(ClientPendingTripParams params) {
    return  remoteDataSource.getAcceptedNonSocketTrips(params);
  }

  @override
  Future<Either<Failure, List<HistoryTripEntity>>> getPastNonSocketTrips(ClientPendingTripParams params) {
    return  remoteDataSource.getPastNonSocketTrips(params);
  }

  @override
  Future<Either<Failure, DriverSettingsEntity>> getDriverSettings() {
    return remoteDataSource.getDriverSettings();
  }

  @override
  void listenToRemoveUntrackedTrip(Function(String tripId) params) {
    remoteDataSource.listenToRemoveUntrackedTrip(params);
  }

  @override
  Future<Either<Failure, List<EmergencyContactEntity>>> getEmergencyContacts() {
    return  remoteDataSource.getEmergencyContacts();
  }

  @override
  Future<Either<Failure, EmergencyContactEntity>> addEmergencyContacts(EmergencyContactEntity params) {
    return  remoteDataSource.addEmergencyContacts(params);
  }

  @override
  Future<Either<Failure, EmergencyContactEntity>> editEmergencyContacts(EmergencyContactEntity params) {
    return  remoteDataSource.editEmergencyContacts(params);
  }

  @override
  void listenToAcceptUntrackedTripOffer(Function(String tripId) params) {
    return remoteDataSource.listenToAcceptUntrackedTripOffer(params);
  }

  @override
  void listenToAvailableUntrackedTrip(Function(AvailableRideNonSocketTripEntity trip) params) {
  return remoteDataSource.listenToAvailableUntrackedTrip(params);
  }

  @override
  Future<Either<Failure, bool>> deleteEmergencyContact(EmergencyContactEntity params) {
    return  remoteDataSource.deleteEmergencyContact(params);
  }

  @override
  Future<Either<Failure, RateResponseEntity>> addRateWithDriver(AddRateWithDriverParams params) {
    return  remoteDataSource.addRateWithDriver(params);
  }

  @override
  Future<Either<Failure, List<GetLoadingAcceptedEntity>>> getAcceptedNonSocketLoading(ClientPendingTripParams params) {
    return  remoteDataSource.getAcceptedNonSocketLoading(params);
  }

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity>> createOfferLoading(CreateNonTrackOfferParams params) {
    return  remoteDataSource.createOfferLoading(params);
  }

  @override
  Future<Either<Failure, List<GetLoadingAvailableEntity>>> getAvailableNonSocketLoading(ClientPendingTripParams params) {
    return  remoteDataSource.getAvailableNonSocketLoading(params);
  }

  @override
  Future<Either<Failure, List<GetLoadingHistoryEntity>>> getHistoryNonSocketLoading(ClientPendingTripParams params) {
    return  remoteDataSource.getHistoryNonSocketLoading(params);
  }

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity>> updateDriverRateNonSocket(UpdateClientRateParams params) {
    return  remoteDataSource.updateDriverRateNonSocket(params);
  }

  @override
  Future<Either<Failure, DriverSettingLoadingEntity>> getDriverLoadingSettings() {
    return  remoteDataSource.getDriverLoadingSettings();
  }

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity>> updateDriverLoadingSettings(UpdateDriverSettingsLoadingParams params) {
    return  remoteDataSource.updateDriverLoadingSettings(params);
  }

  @override
  void listenToRemoveLoading(Function(String tripId) params) {
    remoteDataSource.listenToRemoveLoading(params);

  }

  @override
  void listenToAvailableLoading(Function(GetLoadingAvailableEntity trip) params) {
    remoteDataSource.listenToAvailableLoading(params);
  }

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity>> updateDriverRateLoadingNonSocket(UpdateClientRateParams params) {
    return  remoteDataSource.updateDriverRateLoadingNonSocket(params);
  }

  @override
  Future<Either<Failure, RateResponseEntity>> addRateWithDriverLoading(AddRateWithDriverLoadingParams params) {
    return  remoteDataSource.addRateWithDriverLoading(params);

  }


}
