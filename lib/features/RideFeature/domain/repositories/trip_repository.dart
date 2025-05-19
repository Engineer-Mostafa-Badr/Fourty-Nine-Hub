import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/accept_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_auto_accept_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_price_entity.dart';

import '../../../../core/error/failure.dart';
import '../entities/dashboards/driver_settings_entity.dart';
import '../entities/dashboards/get_accepted_ride_non_socket_trip_entity.dart';
import '../entities/dashboards/get_available_ride_non_socket_trip_entity.dart';
import '../entities/dashboards/get_past_ride_non_socket_trip_entity.dart';
import '../entities/dashboards/settings_dashboard_entity.dart';
import '../entities/dashboards/trips_response_entity.dart';
import '../usecases/dashboards/create_driver_rating_usecase.dart';
import '../usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import '../usecases/dashboards/get_available_ride_trips_use_case.dart';
import '../usecases/dashboards/update_settings_dashboard_usecase.dart';
import '../usecases/get_client_pending_untracked_trips_use_case.dart';

abstract class TripRepository {
   Future<Either<Failure, TripsResponseEntity>> getAvailableTrips(AvailableRideTripsUseCaseParams params);
   Future<Either<Failure, List<AvailableRideNonSocketTripEntity>>> getAvailableNonSocketTrips(ClientPendingTripParams params);
   Future<Either<Failure, List<AcceptedRideNonSocketTripEntity >>> getAcceptedNonSocketTrips(ClientPendingTripParams params);
   Future<Either<Failure, List<HistoryTripEntity  >>> getPastNonSocketTrips(ClientPendingTripParams params);
   Future<Either<Failure, TripsResponseEntity>> getPastTrips(String params);
   Future<Either<Failure, SettingsDashboardEntityResponse>> getSettings();
   Future<Either<Failure, DriverSettingsEntity >> getDriverSettings();
   Future<Either<Failure, bool>> updateSettings(UpdateSettingsDashboardUsecaseParam params);
   Future<Either<Failure, bool>> createNewOffer(CreateNewOfferDashboardUsecaseParam params);
   Future<Either<Failure, bool>> createNewOfferNonSocket(CreateNewOfferDashboardUsecaseParam params);
   Future<Either<Failure, bool>> createDriverRating(CreateUpdateDriverRatingUsecaseParam params);
   Future<Either<Failure, bool>> updateDriverRating(CreateUpdateDriverRatingUsecaseParam params);
   Future<Either<Failure, bool>> acceptTrip(String params);
   Future<Either<Failure, bool>> getRunningTrip();
   void listenToUpdateTripAutoAccept(Function(UpdateTripAutoAcceptEntity trip) params);
   void listenToUpdateTripPrice(Function(UpdateTripPriceEntity trip) params);
   void listenToNewTrip(Function(AvailableRideTripEntity trip) params);
   void listenToRemoveTrip(Function(String tripId) params);
   void listenToRemoveUntrackedTrip(Function(String tripId) params);
   void listenToAcceptOffer(Function(AcceptOfferEntity trip) params);


}