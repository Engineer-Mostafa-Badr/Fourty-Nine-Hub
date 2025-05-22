import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/accept_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/arrived_to_client_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/emergency_contact_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/support_details_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_auto_accept_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/driver_rate_client_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/emergency_support_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_support_details_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/start_ride_trip_usecase.dart';

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
   Future<Either<Failure, SupportDetailsEntity>> getSupportDetails(GetSupportDetailsParams params);
   Future<Either<Failure, List<AvailableRideNonSocketTripEntity>>> getAvailableNonSocketTrips(ClientPendingTripParams params);
   Future<Either<Failure, List<AcceptedRideNonSocketTripEntity >>> getAcceptedNonSocketTrips(ClientPendingTripParams params);
   Future<Either<Failure, List<HistoryTripEntity  >>> getPastNonSocketTrips(ClientPendingTripParams params);
   Future<Either<Failure, TripsResponseEntity>> getPastTrips(String params);
   Future<Either<Failure, List<EmergencyContactEntity>>> getEmergencyContacts();
   Future<Either<Failure, EmergencyContactEntity>> addEmergencyContacts(EmergencyContactEntity params);
   Future<Either<Failure, bool>> deleteEmergencyContact(EmergencyContactEntity params);
   Future<Either<Failure, EmergencyContactEntity>> editEmergencyContacts(EmergencyContactEntity params);
   Future<Either<Failure, SettingsDashboardEntityResponse>> getSettings();
   Future<Either<Failure, DriverSettingsEntity >> getDriverSettings();
   Future<Either<Failure, bool>> updateSettings(UpdateSettingsDashboardUsecaseParam params);
   Future<Either<Failure, bool>> createNewOffer(CreateNewOfferDashboardUsecaseParam params);
   Future<Either<Failure, bool>> createNewOfferNonSocket(CreateNewOfferDashboardUsecaseParam params);
   Future<Either<Failure, bool>> createDriverRating(CreateUpdateDriverRatingUsecaseParam params);
   Future<Either<Failure, bool>> updateDriverRating(CreateUpdateDriverRatingUsecaseParam params);
   Future<Either<Failure, bool>> acceptTrip(String params);
   Future<Either<Failure, RunningTripEntity>> getRunningTrip();
   Future<Either<Failure, bool>> goingToClient(String id);
   Future<Either<Failure, bool>> driverRateClient(DriverRateClientParams id);
   Future<Either<Failure, bool>> arrivedToClient(ArrivedToClientEntity params);
   Future<Either<Failure, bool>> emergencySupport(EmergencySupportParams params);
   Future<Either<Failure, bool>> startDriverTrip(StartDriverTripParams params);
   Future<Either<Failure, bool>> completeDriverTrip(StartDriverTripParams params);
   void listenToUpdateTripAutoAccept(Function(UpdateTripAutoAcceptEntity trip) params);
   void listenToUpdateTripPrice(Function(UpdateTripPriceEntity trip) params);
   void listenToNewTrip(Function(AvailableRideTripEntity trip) params);
   void listenToRemoveTrip(Function(String tripId) params);
   void listenToRemoveUntrackedTrip(Function(String tripId) params);
   void listenToAcceptOffer(Function(AcceptOfferEntity trip) params);
   void listenToAcceptUntrackedTripOffer(Function(String tripId) params);
   void listenToAvailableUntrackedTrip(Function(AvailableRideNonSocketTripEntity trip) params);


}