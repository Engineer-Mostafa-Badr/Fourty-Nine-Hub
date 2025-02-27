import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/data/datasources/ride_remote_data_source.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/activity_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trip_for_rider_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trip_for_user_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
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

class RideRepositoryImplementation extends RideRepository {

  final RideRemoteDataSource rideRemoteDataSource;

  RideRepositoryImplementation(this.rideRemoteDataSource);

  ////////////////////////////Nasr//////////////////////////

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(String userId) async {
    return await rideRemoteDataSource.getRideCategories(userId);
  }

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(String userId) async {
    return await rideRemoteDataSource.getShippingCategories(userId);
  }

  @override
  Future<Either<Failure, bool>> updateDriverLocation(UpdateDriverLocationUseCaseParams params) async{
    return await rideRemoteDataSource.updateDriverLocation(params);
  }

  @override
  Future<Either<Failure, List<RunningTripsEntity>>> getAllRunningTrips(GetAllRunningTripsUseCaseParams params) async {
    return await rideRemoteDataSource.getAllRunningTrips(params);
  }

  @override
  Future<Either<Failure, List<CompletedTripsEntity>>> getAllCompletedTrips(GetAllCompletedTripsUseCaseParams params) async {
    return await rideRemoteDataSource.getAllCompletedTrips(params);
  }

  @override
  Future<Either<Failure, GetLocationFromAddressEntity>> getLocationFromAddress(GetLocationFromAddressUseCaseParams params) async {
    return await rideRemoteDataSource.getLocationFromAddress(params);
  }

  @override
  Future<Either<Failure, bool>> acceptTripByDriver(AcceptTripByDriverUseCaseParams params) async {
    return await rideRemoteDataSource.acceptTripByDriver(params);
  }

  @override
  Future<Either<Failure, bool>> riderInStartLocation(RiderInStartLocationUseCaseParams params) async {
    return await rideRemoteDataSource.riderInStartLocation(params);
  }

  @override
  Future<Either<Failure, bool>> startTrip(StartTripUseCaseParams params) async{
    return await rideRemoteDataSource.startTrip(params);
  }

  @override
  Future<Either<Failure, bool>> partialPaymentInTrip(PartialPaymentInTripUseCaseParams params) async {
    return await rideRemoteDataSource.partialPaymentInTrip(params);
  }

  @override
  Future<Either<Failure, bool>> completeTrip(CompleteTripUseCaseParams params) async {
    return await rideRemoteDataSource.completeTrip(params);
  }

  @override
  Future<Either<Failure, bool>> cancelTripByRider(CancelTripByRiderUseCaseParams params) async {
    return await rideRemoteDataSource.cancelTripByRider(params);
  }

  @override
  Future<Either<Failure, bool>> cancelTripByClient(CancelTripByClientUseCaseParams params) async {
    return await rideRemoteDataSource.cancelTripByClient(params);
  }

  @override
  Future<Either<Failure, bool>> recordingTrip(RecordingTripUseCaseParams params) async {
    return await rideRemoteDataSource.recordingTrip(params);
  }

  @override
  Future<Either<Failure, bool>> updateTripPriceFromClient(UpdateTripPriceFromClientUseCaseParams params) async {
    return await rideRemoteDataSource.updateTripPriceFromClient(params);
  }

  @override
  Future<Either<Failure, ActivityTripEntity>> getAllActivityTrips(GetAllActivityTripsUseCaseParams params) async{
    return await rideRemoteDataSource.getAllActivityTrips(params);
  }

  @override
  Future<Either<Failure, List<HistoryTripForUserEntity>>> getAllHistoryTripsForUser() async {
    return await rideRemoteDataSource.getAllHistoryTripsForUser();
  }

  @override
  Future<Either<Failure, List<HistoryTripForRiderEntity>>> getAllHistoryTripsForRider(GetAllHistoryTripsForRiderUseCaseParams params) async {
    return await rideRemoteDataSource.getAllHistoryTripsForRider(params);
  }
}