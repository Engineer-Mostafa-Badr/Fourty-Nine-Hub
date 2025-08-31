import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/socket/socket_data_source.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/accept_offer_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/available_ride_trip_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/energency_contact_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/running_trip_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/support_details_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/update_trip_auto_accept_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/update_trip_price_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/accept_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/arrived_to_client_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/emergency_contact_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/support_details_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_auto_accept_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/complete_ride_trip_with_price_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/driver_rate_client_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/emergency_support_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_past_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_support_details_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/start_ride_trip_usecase.dart';
import 'package:fourtyninehub/features/new_trip_join/data/models/my_booking_model.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/listen_to_client_coming_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_cancel_route_use_case.dart';
import 'package:fourtyninehub/shared_web_socket.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';
import '../../../food_feature/restaurants_list/data/models/rate_response_model.dart';
import '../../../food_feature/restaurants_list/domain/entities/rate_response_entity.dart';
import '../../domain/entities/dashboards/create_non_track_offer_entity.dart';
import '../../domain/entities/dashboards/driver_settings_entity.dart';
import '../../domain/entities/dashboards/get_accepted_ride_non_socket_trip_entity.dart';
import '../../domain/entities/dashboards/get_available_ride_non_socket_trip_entity.dart';
import '../../domain/entities/dashboards/get_past_ride_non_socket_trip_entity.dart';
import '../../domain/entities/dashboards/settings_dashboard_entity.dart';
import '../../domain/entities/loading/get_loading_accepted_entity.dart';
import '../../domain/entities/loading/get_loading_avaliable_entity.dart';
import '../../domain/entities/loading/get_loading_history_entity.dart';
import '../../domain/entities/loading/settings_driver_loading_entity.dart';
import '../../domain/usecases/client_trips/update_client_rate_non_socket_use_case.dart';
import '../../domain/usecases/dashboards/add_rate_with_driver_use_case.dart';
import '../../domain/usecases/dashboards/create_driver_rating_usecase.dart';
import '../../domain/usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import '../../domain/usecases/dashboards/create_non_track_offer_use_case.dart';
import '../../domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import '../../domain/usecases/dashboards/loading/create_rate_with_driver_loading_use_case.dart';
import '../../domain/usecases/dashboards/loading/update_driver_loading_settings_use_case.dart';
import '../../domain/usecases/dashboards/update_settings_dashboard_usecase.dart';
import '../../domain/usecases/get_client_pending_untracked_trips_use_case.dart';
import '../models/dashboards/create_non_track_offer_model.dart';
import '../models/dashboards/driver_settings_model.dart';
import '../models/dashboards/get_accepted_ride_non_socket_trip_model.dart';
import '../models/dashboards/get_available_ride_non_socket_trip_model.dart';
import '../models/dashboards/get_past_ride_non_socket_trip_model.dart';
import '../models/dashboards/settings_dashboard_model.dart';
import '../models/dashboards/trips_response_model.dart';
import '../models/loading/get_loading_accepted_model.dart';
import '../models/loading/get_loading_avaliable_model.dart';
import '../models/loading/get_loading_history_model.dart';
import '../models/loading/settings_driver_loading_model.dart';

abstract class TripRemoteDataSource {
  Future<Either<Failure, TripsResponseModel>> getAvailableTrips(AvailableRideTripsUseCaseParams params);

  Future<Either<Failure, TripsResponseModel>> getPastTrips(GetPastTripsParams type);

  Future<Either<Failure, SettingsDashboardEntityResponse>> getSettings();

  Future<Either<Failure, bool>> updateSettings(UpdateSettingsDashboardUsecaseParam params);

  Future<Either<Failure, bool>> createNewOffer(CreateNewOfferDashboardUsecaseParam params);
  Future<Either<Failure, RunningTripEntity>> getRunningTrip();
  Future<Either<Failure, RunningTripEntity>> goingToClient(String id);
  Future<Either<Failure, bool>> arrivedToClient(ArrivedToClientEntity params);
  Future<Either<Failure, List<EmergencyContactEntity>>> getEmergencyContacts();
  Future<Either<Failure, EmergencyContactEntity>> addEmergencyContacts(EmergencyContactEntity params);
  Future<Either<Failure, EmergencyContactEntity>> editEmergencyContacts(EmergencyContactEntity params);
  Future<Either<Failure, bool>> deleteEmergencyContact(EmergencyContactEntity params);
  Future<Either<Failure, String>> startDriverTrip(StartDriverTripParams params);
  Future<Either<Failure, bool>> completeDriverTrip(StartDriverTripParams params);
  Future<Either<Failure, bool>> completeDriverTripWithRemainingMoney(CompleteDriverTripWithRemainingMoneyParams params);
  Future<Either<Failure, bool>> driverRateClient(DriverRateClientParams params);
  Future<Either<Failure, bool>> updateDriverRateClient(DriverRateClientParams params);
  Future<Either<Failure, bool>> emergencySupport(EmergencySupportParams params);
  Future<Either<Failure, SupportDetailsEntity>> getSupportDetails(GetSupportDetailsParams params);
  Future<Either<Failure, bool>> createNewOfferNonSocket(CreateNewOfferDashboardUsecaseParam params);

  Future<Either<Failure, bool>> createDriverRating(CreateUpdateDriverRatingUsecaseParam params);

  Future<Either<Failure, bool>> updateDriverRating(CreateUpdateDriverRatingUsecaseParam params);

  Future<Either<Failure, bool>> acceptTrip(String params);

  void listenToUpdateTripAutoAccept(Function(UpdateTripAutoAcceptEntity trip) params);
  void listenToDriverArrived(Function(String waitingTime) params);
  void listenToTripAccept(Function(String waitingTime) params);
  void listenToDriverOnTheWay(Function(String message) params);
  void listenToRouteCancelled(Function(String message) params);
  void listenToDriverNoShowClient(Function(String waitingTime) params);
  void listenToPassengerPickedUp(Function(String message) params);
  void listenToPartialPaymentDriver(Function(num amountPaidCash) params);

  void listenToAcceptOffer(Function(AcceptOfferEntity trip) params);

  void listenToUpdateTripPrice(Function(UpdateTripPriceEntity trip) params);

  void listenToNewTrip(Function(AvailableRideTripEntity trip) params);

  void listenToRemoveTrip(Function(String tripId) params);
  void listenToEndTrip(Function(String tripId) params);
  void listenToClientComing(Function(String tripId) params);
  void listenToCancelRoute(Function(ListenToCancelRouteParams params) params);
  void listenToUpdateRoute(Function(MyBookingEntity route) params);
  void listenToAcceptRoute(Function(MyBookingEntity route) params);
  void listenToDriverTheOnWay(Function(MyBookingEntity route) params);
  void listenToJoinAvailableRoutes(Function(bool isJoined) params);
  Future<Either<Failure, bool>> listenToLeaveAvailableRoutes(Function(String routeId) params);
  void listenToNewRoute(Function(MyBookingEntity newBooking) params);
  void listenToNewRouteDriver(Function(MyBookingEntity newBooking) params);
  void listenToComingClient(Function(ListenToClientComingParams params) params);
  void listenToRemoveUntrackedTrip(Function(String tripId) params);

  void listenToAcceptUntrackedTripOffer(Function(String tripId) params);

  Future<Either<Failure, List<AvailableRideNonSocketTripEntity>>> getAvailableNonSocketTrips(ClientPendingTripParams params);

  Future<Either<Failure, List<AcceptedRideNonSocketTripEntity>>> getAcceptedNonSocketTrips(ClientPendingTripParams params);
  Future<Either<Failure, List<HistoryTripEntity>>> getPastNonSocketTrips(ClientPendingTripParams params);


  Future<Either<Failure, DriverSettingsEntity >> getDriverSettings();

  void listenToAvailableUntrackedTrip(Function(AvailableRideNonSocketTripEntity trip) params);
  Future<Either<Failure, RateResponseEntity>> addRateWithDriver(AddRateWithDriverParams params);

  Future<Either<Failure, List<GetLoadingAcceptedEntity>>> getAcceptedNonSocketLoading(ClientPendingTripParams params);

  Future<Either<Failure, CreateNonTrackOfferEntity>> createOfferLoading(CreateNonTrackOfferParams params);
  Future<Either<Failure, List<GetLoadingAvailableEntity>>> getAvailableNonSocketLoading(ClientPendingTripParams params);
  Future<Either<Failure, List<GetLoadingHistoryEntity>>> getHistoryNonSocketLoading(ClientPendingTripParams params);
  Future<Either<Failure, CreateNonTrackOfferEntity>> updateDriverRateNonSocket(UpdateClientRateParams params);

  Future<Either<Failure, DriverSettingLoadingEntity >> getDriverLoadingSettings();
  Future<Either<Failure, CreateNonTrackOfferEntity >> updateDriverLoadingSettings(UpdateDriverSettingsLoadingParams params);

  void listenToRemoveLoading(Function(String tripId) params);
  void listenToAvailableLoading(Function(GetLoadingAvailableEntity trip) params);

  Future<Either<Failure, CreateNonTrackOfferEntity>> updateDriverRateLoadingNonSocket(UpdateClientRateParams params);

  Future<Either<Failure, RateResponseEntity>> addRateWithDriverLoading(AddRateWithDriverLoadingParams params);

}

class TripRemoteDataSourceImplementation implements TripRemoteDataSource {
  final ApiConsumer _apiConsumer;

  TripRemoteDataSourceImplementation(this._apiConsumer);

  @override
  Future<Either<Failure, TripsResponseModel>> getAvailableTrips(AvailableRideTripsUseCaseParams params) async {
    try {
      final response = await _apiConsumer.get(EndPoints.getAvailableTrips(params));

      return response.fold((failure) => Left(failure), (data) {
        TripsResponseModel tripsResponseModel = TripsResponseModel.fromJson(data);
        return Right(tripsResponseModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TripsResponseModel>> getPastTrips(GetPastTripsParams params) async {
    try {
      final response = await _apiConsumer.get(EndPoints.getPastTrips,queryParameters: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        TripsResponseModel tripsResponseModel = TripsResponseModel.fromJson(data);
        return Right(tripsResponseModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SettingsDashboardEntityResponse>> getSettings() async {
    try {
      final response = await _apiConsumer.get(EndPoints.getSettingsDashboard);

      return response.fold((failure) => Left(failure), (data) {
        SettingsDashboardResponseModel settingsResponseModel = SettingsDashboardResponseModel.fromJson(data);
        return Right(settingsResponseModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateSettings(UpdateSettingsDashboardUsecaseParam params) async {
    try {
      final response = await _apiConsumer.put(EndPoints.getSettingsDashboard, data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> acceptTrip(String params) async {
    try {
      final response = await _apiConsumer.put(EndPoints.acceptTripRider(params));

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']??false);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createNewOffer(CreateNewOfferDashboardUsecaseParam params) async {
    try {
      final response = await _apiConsumer.post(EndPoints.createNewOffer(params.tripId), data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createNewOfferNonSocket(CreateNewOfferDashboardUsecaseParam params) async {
    try {
      final response = await _apiConsumer.post(EndPoints.createNewOfferNonSocket(params.tripId), data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createDriverRating(CreateUpdateDriverRatingUsecaseParam params) async {
    try {
      final response = await _apiConsumer.post(EndPoints.createDriverRating, data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateDriverRating(CreateUpdateDriverRatingUsecaseParam params) async {
    try {
      final response = await _apiConsumer.put(EndPoints.updateDriverRating(params.tripId), data: params.toJson()['newComment']);

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, UpdateTripAutoAcceptEntity>> listenToUpdateTripAutoAccept() {
  //   try {
  //     CliLogger.info('Listen To Update Trip Auto Accept');
  //     final completer = Completer<Either<Failure, UpdateTripAutoAcceptEntity>>();
  //
  //     // Set up the listener
  //     SharedWebSocket.socket!.on(SocketIOListeners.updateTripAutoAccept, (data) {
  //       CliLogger.info("trip data: $data");
  //       // Complete the future with the data
  //       //{updatedTripAutoAccept: {id: 67f2e169c8affd04aa6fca91, autoAccept: true}}
  //       completer.complete(Right(UpdateTripAutoAcceptModel.fromJson(data['updatedTripAutoAccept'])));
  //
  //       // Optionally remove the listener after first event
  //       SharedWebSocket.socket!.off(SocketIOListeners.updateTripAutoAccept);
  //     });
  //
  //     CliLogger.info("Listening to socket event: ${SocketIOListeners.updateTripAutoAccept}");
  //
  //     // Return the future that will complete when the event is received
  //     return completer.future;
  //   } catch (e) {
  //     CliLogger.error('Can\'t listen to trip auto accept updates: $e');
  //     return Future.value(const Left(ServerFailure(message: "Can't listen to trip auto accept updates")));
  //   }
  // }

  @override
  void listenToUpdateTripAutoAccept(Function(UpdateTripAutoAcceptEntity trip) params) {
    try {
      CliLogger.info("trip listenToUpdateTripAutoAccept ");
      SharedWebSocket.socket!.on(SocketIOListeners.updateTripAutoAccept, (data) {
        // // final decodedData = jsonDecode(data);
        // CliLogger.info("offer data :  $decodedData");
        // params(RideOfferModel.fromJson(decodedData));
        CliLogger.info("trip data :  $data");
        params(UpdateTripAutoAcceptModel.fromJson(data['updatedTripAutoAccept']));
      });
    } catch (e) {
      CliLogger.info("can't listen to offer error $e");
    }
  }

  @override
  void listenToPartialPaymentDriver(Function(num amountPaidCash) params) {
    try {
      CliLogger.info("trip listenToPartialPaymentDriver ");
      SharedWebSocket.socket!.on(SocketIOListeners.partialPaymentDriver, (data) {
        // // final decodedData = jsonDecode(data);
        // CliLogger.info("offer data :  $decodedData");
        // params(RideOfferModel.fromJson(decodedData));
        CliLogger.info("listenToPartialPaymentDriver data :  $data");
        params(data['amountPaidCash']??0);
      });
    } catch (e) {
      CliLogger.info("can't listen to offer error $e");
    }
  }

  @override
  void listenToAcceptOffer(Function(AcceptOfferEntity trip) params) {
    try {
      CliLogger.info("trip Listen To Accept Offer");
      SharedWebSocket.socket!.on(SocketIOListeners.acceptDriverOffer, (data) {
        // // final decodedData = jsonDecode(data);
        // CliLogger.info("offer data :  $decodedData");
        // params(RideOfferModel.fromJson(decodedData));
        CliLogger.info("trip offer data :  $data");
        params(AcceptOfferModel.fromJson(data['acceptedTrip']));
      });
    } catch (e) {
      CliLogger.info("can't listen to offer error $e");
    }
  }

  @override
  void listenToUpdateTripPrice(Function(UpdateTripPriceEntity trip) params) {
    try {
      CliLogger.info("trip listenToUpdateTripPrice ");
      log("trip listenToUpdateTripPrice ");
      SharedWebSocket.socket!.on(SocketIOListeners.updateTripPrice, (data) {
        // final decodedData = jsonDecode(data);
        // CliLogger.info("offer data :  $decodedData");
        // params(RideOfferModel.fromJson(decodedData));
        CliLogger.info("trip price data :  $data");
        log("trip price data :  $data");
        params(UpdateTripPriceModel.fromJson(data['updatedTripPrice']));
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  void listenToNewTrip(Function(AvailableRideTripEntity trip) params) {
    try {
      CliLogger.info("trip NewTrip ");
      log("trip NewTrip ");
      SharedWebSocket.socket!.on(SocketIOListeners.newAvailableTrip, (data) {
        // final decodedData = jsonDecode(data);
        // CliLogger.info("offer data :  $decodedData");
        // params(RideOfferModel.fromJson(decodedData));
        CliLogger.info("New Trip data :  $data");
        log("New Trip data :  $data");
        log("New Trip data['newAvailableTrip'] :  ${data['newAvailableTrip']}");
        params(AvailableRideTripModel.fromJson(data['newAvailableTrip']));
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  void listenToRemoveTrip(Function(String tripId) params) {
    try {
      CliLogger.info("Listen to Remove Trip ");
      log("Listen to Remove Trip ");
      SharedWebSocket.socket!.on(SocketIOListeners.removeTrip, (data) {
        CliLogger.info("Remove Trip data :  $data");
        log("Remove Trip data :  $data");
        params(data['removedTrip']['id']);
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  void listenToEndTrip(Function(String tripId) params) {
    try {
      CliLogger.info("Listen to End Trip ");
      log("Listen to End Trip ");
      SharedWebSocket.socket!.on(SocketIOListeners.endTrip, (data) {
        CliLogger.info("End Trip data :  $data");
        log("End Trip data :  $data");
        params('');
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  void listenToClientComing(Function(String tripId) params) {
    try {
      CliLogger.info("Listen to Client Coming ");
      log("Listen to Client Coming ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToClientComing, (data) {
        CliLogger.info("Client Coming data :  $data");
        log("Client Coming data :  $data");
        params(data['message']);
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  void listenToCancelRoute(Function(ListenToCancelRouteParams params) params) {
    try {
      CliLogger.info("Listen to Cancel Route ");
      log("Listen to Cancel Route ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToCancelRoute, (data) {
        CliLogger.info("Cancel Route data :  $data");
        log("Cancel Route data :  $data");
        params(ListenToCancelRouteParams.fromJson(data['routeCancelled']));
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }


  @override
  void listenToUpdateRoute(Function(MyBookingEntity route) params) {
    try {
      CliLogger.info("Listen to Update Route ");
      log("Listen to Update Route ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToUpdateRoute, (data) {
        CliLogger.info("Update Route data :  ${data['updatedRoute']['formattedResponse']}");
        log("Update Route data :  ${data['updatedRoute']['formattedResponse']}");
        MyBookingModel model = MyBookingModel.fromJson(data['updatedRoute']['formattedResponse']);
        log("model.pricePerSeat :  ${model.pricePerSeat}");
        log("Update Route data :  ${MyBookingModel.fromJson(data['updatedRoute']['formattedResponse'])}");
        params(MyBookingModel.fromJson(data['updatedRoute']['formattedResponse']));
      });
    } catch (e) {
      CliLogger.info("can't listen to Update Route error $e");
    }
  }


  @override
  void listenToAcceptRoute(Function(MyBookingEntity route) params) {
    try {
      CliLogger.info("Listen to Accepted Route ");
      log("Listen to Accepted Route ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToAcceptRoute, (data) {
        CliLogger.info("Accepted Route data :  $data");
        log("Accepted Route data :  $data");
        params(MyBookingModel.fromJson(data['acceptedRoute']));
      });
    } catch (e) {
      CliLogger.info("can't listen to Accepted Route error $e");
    }
  }



  @override
  void listenToDriverTheOnWay(Function(MyBookingEntity route) params) {
    try {
      CliLogger.info("Listen to Driver on the way ");
      log("Listen to Driver on the way ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToDriverTheOnWay, (data) {
        CliLogger.info("Driver on the way data :  $data");
        log("Driver on the way data :  $data");
        params(MyBookingModel.fromJson(data['data']));
      });
    } catch (e) {
      CliLogger.info("can't listen to Driver on the way error $e");
    }
  }



  @override
  Future<Either<Failure, bool>> listenToJoinAvailableRoutes(
      Function(bool isJoined) params) async {
    try {
      CliLogger.info("Join Available Route ");
      log("Join Available Route ");
      SharedWebSocket.socket!.emit(SocketIOEvents.joinAvailableRoutes);
      CliLogger.info(
          "SocketIOEvents.leaveAvailableRoutes ${SocketIOEvents.joinAvailableRoutes}");

      return const Right(true);
    } catch (e) {
      CliLogger.error('can\'t Join Available error $e');
      return const Left(ServerFailure(message: "can't Join Available "));
    }
  }



  @override
  Future<Either<Failure, bool>> listenToLeaveAvailableRoutes(
      Function(String tripId) params) async {
    try {
      CliLogger.info("Leave Available Route ");
      log("Leave Available Route ");
      SharedWebSocket.socket!.emit(SocketIOEvents.leaveAvailableRoutes);
      CliLogger.info(
          "SocketIOEvents.leaveAvailableRoutes${SocketIOEvents.leaveAvailableRoutes}");

      return const Right(true);
    } catch (e) {
      CliLogger.error('can\'t Leave Available error $e');
      return const Left(ServerFailure(message: "can't Leave Available "));
    }
  }


  @override
  void listenToNewRoute(Function(MyBookingEntity newBooking) params) {
    try {
      CliLogger.info("Listen to New Route ");
      log("Listen to New Route ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToNewRoute, (data) {
        CliLogger.info("New Route data :  $data");
        log("New Route data :  $data");
        params(MyBookingModel.fromJson(data['newAllowedRoute']));
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  void listenToComingClient(Function(ListenToClientComingParams params) params) {
    try {
      CliLogger.info("Listen to Coming Client ");
      log("Listen to Coming Client ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToComingClient, (data) {
        CliLogger.info("Coming Client data :  $data");
        log("Coming Client data1 : ${data['passengerIamComing']?['newDriverWaitingTime'] ?? 'N/A'}");
        // log("New Route data :  $data");
        ListenToClientComingParams result = ListenToClientComingParams (
          clientId: data['passengerIamComing']?['clientId']??'',
          remainingTime: data['passengerIamComing']?['newDriverWaitingTime']??''
        );
        params(result);
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  void listenToNewRouteDriver(Function(MyBookingEntity newBooking) params) {
    try {
      CliLogger.info("Listen to New Route Driver");
      log("Listen to New Route ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToNewRouteDriver, (data) {
        CliLogger.info("New Route Driver data :  $data");
        log("New Route data :  $data");
        params(MyBookingModel.fromJson(data['formattedResponse']));
      });
    } catch (e) {
      CliLogger.info("can't listen to New Route Driver error $e");
    }
  }

  @override
  Future<Either<Failure, RunningTripEntity>> getRunningTrip() async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getActiveTrip,
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(RunningTripModel.fromJson(data['data']['activeTrip']));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RunningTripEntity>> goingToClient(String id) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.goingToClient(id),
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(RunningTripModel.fromJson(data['data']['driverIsArrivingIn']));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> arrivedToClient(ArrivedToClientEntity params) async {
    try {
      final response = await _apiConsumer.put(EndPoints.arrivedToClient(params.tripId), data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> startDriverTrip(StartDriverTripParams params) async {
    try {
      final response = await _apiConsumer.put(EndPoints.startDriverTrip(params.tripId), data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['data']['tripStartedAt']??'');
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AvailableRideNonSocketTripEntity>>> getAvailableNonSocketTrips(ClientPendingTripParams params) async {
    final url = "${EndPoints.getAvailableRideNonSocketTrip}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        final tripsData = (data['data']['trips'] as List).map((e) => GetAvailableRideNonSocketTripModel.fromJson(e as Map<String, dynamic>)).toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, List<AcceptedRideNonSocketTripEntity>>> getAcceptedNonSocketTrips(ClientPendingTripParams params) async {
    final url = "${EndPoints.getAcceptedRideNonSocketTrip}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        final tripsData = (data['data']['acceptedTrips'] as List).map((e) => AcceptedRideNonSocketTripModel.fromJson(e as Map<String, dynamic>)).toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, List<HistoryTripEntity>>> getPastNonSocketTrips(ClientPendingTripParams params) async {
    final url = "${EndPoints.getPastRideNonSocketTrip}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
      (l) => Left(l),
      (data) {
        final tripsData = (data['data']['historyTrips'] as List).map((e) => HistoryTripModel.fromJson(e as Map<String, dynamic>)).toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> completeDriverTrip(StartDriverTripParams params) async {
    try {
      final response = await _apiConsumer.put(EndPoints.completeDriverTrip(params.tripId));

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }


  @override
  Future<Either<Failure, bool>> completeDriverTripWithRemainingMoney(CompleteDriverTripWithRemainingMoneyParams params) async {
    try {
      final response = await _apiConsumer.put(EndPoints.completeDriverTrip(params.tripId),data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> driverRateClient(DriverRateClientParams params) async {
    try {
      final response = await _apiConsumer.post(EndPoints.createDriverRating, data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateDriverRateClient(DriverRateClientParams params) async {
    try {
      final response = await _apiConsumer.put(EndPoints.createDriverRating, data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> emergencySupport(EmergencySupportParams params) async {
    try {
      final response = await _apiConsumer.post(EndPoints.emergencySupport, data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportDetailsEntity>> getSupportDetails(GetSupportDetailsParams params) async {
    try {
      final response = await _apiConsumer.get(EndPoints.supportDetails, queryParameters: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(SupportDetailsModel.fromJson(data['data']));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EmergencyContactEntity>>> getEmergencyContacts() async {
    final response = await _apiConsumer.get(EndPoints.getEmergencyContacts);
    return response.fold(
      (l) => Left(l),
      (data) => Right((data['data'] as List).map((e) => EmergencyContactModel.fromJson(e as Map<String, dynamic>)).toList()),
    );
  }

  @override
  Future<Either<Failure, EmergencyContactEntity>> addEmergencyContacts(EmergencyContactEntity params) async {
    final response = await _apiConsumer.post(EndPoints.addEmergencyContacts,
      data:params.toJson(),
    );
    return response.fold(
          (l) => Left(l),
          (data) => Right(EmergencyContactModel.fromJson(data['data']),
    ));
  }

  @override
  Future<Either<Failure, EmergencyContactEntity>> editEmergencyContacts(EmergencyContactEntity params) async {
    final response = await _apiConsumer.put(EndPoints.editEmergencyContacts(params.id),
      data:params.toJson(),
    );
    return response.fold(
          (l) => Left(l),
          (data) => Right(EmergencyContactModel.fromJson(data['data']),
    ));
  }

  @override
  Future<Either<Failure, DriverSettingsEntity>> getDriverSettings()async {
    final url = EndPoints.getDriverSettings;

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final driverSettings = DriverSettingsModel .fromJson(data['data']['driverSettings']);
        return Right(driverSettings);
      },
    );
  }

  @override
  void listenToRemoveUntrackedTrip(Function(String tripId) params) {
    try {
      CliLogger.info("Listen to Remove Trip ");
      log("Listen to Remove Trip ");
      SharedWebSocket.socket!.on(SocketIOListeners.removeUntrackedTrip, (data) {
        CliLogger.info("Remove Trip data :  $data");
        log("Remove Trip data :  $data");
        params(data['tripsCanceled']['ids'][0]);
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  Future<Either<Failure, bool>> deleteEmergencyContact(EmergencyContactEntity params) async {
    final response = await _apiConsumer.delete(EndPoints.deleteEmergencyContact(params.id),
      data:params.toJson(),
    );
    return response.fold(
          (l) => Left(l),
          (data) => Right(data['status'],
    ));
  }

  @override
  void listenToAcceptUntrackedTripOffer(Function(String tripId) params) {
    try {
      CliLogger.info("Listen to Remove Trip ");
      log("Listen to Remove Trip ");
      SharedWebSocket.socket!.on(SocketIOListeners.acceptUntrackedTripOffer, (data) {
        CliLogger.info("Remove Trip data :  $data");
        log("Remove Trip data :  $data");
        params(data['acceptedTripOffer']['tripId']);
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  void listenToAvailableUntrackedTrip(Function(AvailableRideNonSocketTripEntity trip) params) {
    try {
      CliLogger.info("Listen to  New Trip Trip ");
      log("Listen to New Trip Trip ");
      SharedWebSocket.socket!.on(SocketIOListeners.rideUpdateUntrackedTrip, (data) {
        CliLogger.info(" New Trip Trip data :  $data");
        log(" New Trip Trip data :  $data");
        print(" New Trip Trip data :  $data");
        params(GetAvailableRideNonSocketTripModel.fromJson(data["tripsUpdated"]));
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  Future<Either<Failure, RateResponseEntity>> addRateWithDriver(AddRateWithDriverParams params) async{
    final url = EndPoints.addRateToClientWithDriverNonSocket;

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
  Future<Either<Failure, List<GetLoadingAcceptedEntity>>> getAcceptedNonSocketLoading(ClientPendingTripParams params) async{
    final url = "${EndPoints.getAcceptedRideNonSocketLoading}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripsData = (data['data']['acceptedTrips'] as List).map((e) => GetLoadingAcceptedModel.fromJson(e as Map<String, dynamic>)).toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity>> createOfferLoading(CreateNonTrackOfferParams params)async {
    final url = "${EndPoints.createOfferLoading}${params.tripId}";
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


  @override
  Future<Either<Failure, List<GetLoadingAvailableEntity>>> getAvailableNonSocketLoading(ClientPendingTripParams params) async {
    final url = "${EndPoints.getAvailableRideNonSocketLoading}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripsList = (data['data']['trips'] ?? []) as List;
        final tripsData = tripsList
            .map((e) => GetLoadingAvailableModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, List<GetLoadingHistoryEntity>>> getHistoryNonSocketLoading(ClientPendingTripParams params)async {
    final url = "${EndPoints.getHistoryRideNonSocketLoading}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripsList = (data['data']['historyTrips'] ?? []) as List;
        final tripsData = tripsList
            .map((e) => GetLoadingHistoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity>> updateDriverRateNonSocket(UpdateClientRateParams params) async{
    final url = EndPoints.updateDriverRatingNonSocket;

    final response = await _apiConsumer.put(url,data: params.toJson());

    return response.fold(
          (l) => Left(l),
          (data) {
        final rateData = CreateNonTrackOfferModel.fromJson(data);
        return Right(rateData);
      },
    );
  }

  @override
  Future<Either<Failure, DriverSettingLoadingEntity>> getDriverLoadingSettings() async{
    final url = EndPoints.getDriverLoadingSettings;

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final driverSettings = DriverSettingLoadingModel.fromJson(data['data']);
        return Right(driverSettings);
      },
    );
  }

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity>> updateDriverLoadingSettings(UpdateDriverSettingsLoadingParams params) async{
    final url = EndPoints.updateDriverLoadingSettings;

    final response = await _apiConsumer.put(url,data: params.toJson());

    return response.fold(
          (l) => Left(l),
          (data) {
        final rateData = CreateNonTrackOfferModel.fromJson(data);
        return Right(rateData);
      },
    );
  }

  @override
  void listenToRemoveLoading(Function(String tripId) params) {
    try {
      CliLogger.info("Listen to Remove Loading ");
      log("Listen to Remove Trip ");
      SharedWebSocket.socket!.on(SocketIOListeners.removeLoading, (data) {
        CliLogger.info("Remove Loading data :  $data");
        log("Remove Loading data :  $data");
        params(data['tripsCanceled']['ids'][0]);
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  void listenToAvailableLoading(Function(GetLoadingAvailableEntity trip) params) {
    try {
      CliLogger.info("Listen to  New Loading  ");
      log("Listen to New Loading ");
      SharedWebSocket.socket!.on(SocketIOListeners.newLoadingTrip, (data) {
        CliLogger.info(" New Loading  data :  $data");
        log(" New Loading  data :  $data");
        print(" New Loading  data :  $data");
        params(GetLoadingAvailableModel.fromJson(data["tripsUpdated"]));
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  void listenToDriverArrived(Function(String waitingTime) params) {
    try {
      CliLogger.info("Listen to Driver Arrived");
      log("Listen to Driver Arrived ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToDriverArrived, (data) {
        CliLogger.info(" Driver Arrived :  $data");
        log(" Driver Arrived  data :  $data");
        print(" Driver Arrived  data :  $data");
        params(data['driverArrival']["time"]??'');
      });
    } catch (e) {
      CliLogger.info("can't listen to driver arrived error $e");
    }
  }

  @override
  void listenToTripAccept(Function(String waitingTime) params) {
    try {
      CliLogger.info("Listen to Trip Accepted");
      log("Listen to Trip Accepted ");
      log("SharedWebSocket.socket ${SharedWebSocket.socket == null} ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToTripAccept, (data) {
        CliLogger.info(" Trip Accepted :  $data");
        log(" Trip Accepted  data :  $data");
        print(" Trip Accepted  data :  $data");
        params(data['driverAcceptedTTrip']["yourStatus"]??'');
      });
    } catch (e) {
      CliLogger.info("can't listen to driver arrived error $e");
    }
  }

  @override
  void listenToDriverOnTheWay(Function(String message) params) {
    try {
      CliLogger.info("Listen to Driver On The Way");
      log("Listen to Driver On The Way ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToDriverOnTheWay, (data) {
        CliLogger.info(" Driver On The Way :  $data");
        log(" Driver On The Way  data :  $data");
        print(" Driver On The Way  data :  $data");
        params(data["message"]);
      });
    } catch (e) {
      CliLogger.info("can't listen to driver on the way error $e");
    }
  }

  @override
  void listenToRouteCancelled(Function(String message) params) {
    try {
      CliLogger.info("Listen to Route Cancelled");
      log("Listen to Route Cancelled ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToRouteCancelled, (data) {
        CliLogger.info(" Route Cancelled :  $data");
        log(" Route Cancelled  data :  $data");
        print(" Route Cancelled  data :  $data");
        params(data["message"]);
      });
    } catch (e) {
      CliLogger.info("can't listen to route cancelled error $e");
    }
  }

  @override
  void listenToDriverNoShowClient(Function(String waitingTime) params) {
    try {
      CliLogger.info("Listen to Driver No Show Client");
      log("Listen to Driver No Show Client ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToDriverNoShowClient, (data) {
        CliLogger.info(" Driver No Show Client :  $data");
        log(" Driver No Show Client  data :  $data");
        print(" Driver No Show Client  data :  $data");
        params(data['driverNotShowPassenger']["waitingTime"]??'');
      });
    } catch (e) {
      CliLogger.info("can't listen to driver no show client error $e");
    }
  }

  @override
  void listenToPassengerPickedUp(Function(String message) params) {
    try {
      CliLogger.info("Listen to Passenger Picked Up");
      log("Listen to Passenger Picked Up ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToPassengerPickedUp, (data) {
        CliLogger.info(" Passenger Picked Up :  $data");
        log(" Passenger Picked Up  data :  $data");
        print(" Passenger Picked Up  data :  $data");
        params(data["message"]);
      });
    } catch (e) {
      CliLogger.info("can't listen to driver no passenger picked up error $e");
    }
  }

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity>> updateDriverRateLoadingNonSocket(UpdateClientRateParams params)async {
    final url = EndPoints.updateDriverLoadingRatingNonSocket;

    final response = await _apiConsumer.put(url,data: params.toJson());

    return response.fold(
          (l) => Left(l),
          (data) {
        final rateData = CreateNonTrackOfferModel.fromJson(data);
        return Right(rateData);
      },
    );
  }

  @override
  Future<Either<Failure, RateResponseEntity>> addRateWithDriverLoading(AddRateWithDriverLoadingParams params) async{
    final url = "${EndPoints.addRateToClientWithDriverLoadingNonSocket}${params.tripId}/driver";

    final response = await _apiConsumer.post(url,data: params.toJson());

    return response.fold(
          (l) => Left(l),
          (data) {
        final rateData = RateResponseModel.fromJson(data);
        return Right(rateData);
      },
    );
  }

}
