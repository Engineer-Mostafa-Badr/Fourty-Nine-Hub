import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/accept_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/arrived_to_client_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trips_response_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_auto_accept_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/create_driver_rating_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/driver_rate_client_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/start_ride_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/update_settings_dashboard_usecase.dart';

import '../../domain/entities/dashboards/settings_dashboard_entity.dart';
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
  Future<Either<Failure, TripsResponseEntity>> getPastTrips(String type) async {
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
  Future<Either<Failure, RunningTripEntity>> getRunningTrip() async{
    return await remoteDataSource.getRunningTrip();
  }

  @override
  Future<Either<Failure, bool>> goingToClient(String id) async{
    return await remoteDataSource.goingToClient(id);
  }

  @override
  Future<Either<Failure, bool>> arrivedToClient(ArrivedToClientEntity params) async{
    return await remoteDataSource.arrivedToClient(params);
  }

  @override
  Future<Either<Failure, bool>> startDriverTrip(StartDriverTripParams params) async{
    return await remoteDataSource.startDriverTrip(params);
  }

  @override
  Future<Either<Failure, bool>> completeDriverTrip(StartDriverTripParams params) async{
    return await remoteDataSource.completeDriverTrip(params);
  }

  @override
  Future<Either<Failure, bool>> driverRateClient(DriverRateClientParams params) async {
    return await remoteDataSource.driverRateClient(params);
  }

}
