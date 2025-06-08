import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/socket/socket_data_source.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/accept_offer_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/available_ride_trip_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/energency_contact_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/running_trip_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/support_details_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/trip_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/update_trip_auto_accept_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/update_trip_price_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/accept_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/arrived_to_client_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/emergency_contact_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/support_details_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trips_response_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_auto_accept_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/driver_rate_client_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/emergency_support_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_past_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_support_details_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/start_ride_trip_usecase.dart';
import 'package:fourtyninehub/shared_web_socket.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';
import '../../../food_feature/restaurants_list/data/models/rate_response_model.dart';
import '../../../food_feature/restaurants_list/domain/entities/rate_response_entity.dart';
import '../../domain/entities/create_no_track_trip_entity.dart';
import '../../domain/entities/dashboards/create_non_track_offer_entity.dart';
import '../../domain/entities/dashboards/driver_settings_entity.dart';
import '../../domain/entities/dashboards/get_accepted_ride_non_socket_trip_entity.dart';
import '../../domain/entities/dashboards/get_available_ride_non_socket_trip_entity.dart';
import '../../domain/entities/dashboards/get_past_ride_non_socket_trip_entity.dart';
import '../../domain/entities/dashboards/settings_dashboard_entity.dart';
import '../../domain/entities/loading/get_loading_accepted_entity.dart';
import '../../domain/entities/loading/get_loading_avaliable_entity.dart';
import '../../domain/entities/loading/get_loading_history_entity.dart';
import '../../domain/usecases/client_trips/update_client_rate_non_socket_use_case.dart';
import '../../domain/usecases/dashboards/add_rate_with_driver_use_case.dart';
import '../../domain/usecases/dashboards/create_driver_rating_usecase.dart';
import '../../domain/usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import '../../domain/usecases/dashboards/create_non_track_offer_use_case.dart';
import '../../domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import '../../domain/usecases/dashboards/update_settings_dashboard_usecase.dart';
import '../../domain/usecases/get_client_pending_untracked_trips_use_case.dart';
import '../models/create_no_track_trip_model.dart';
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

abstract class TripRemoteDataSource {
  Future<Either<Failure, TripsResponseModel>> getAvailableTrips(AvailableRideTripsUseCaseParams params);

  Future<Either<Failure, TripsResponseModel>> getPastTrips(GetPastTripsParams type);

  Future<Either<Failure, SettingsDashboardEntityResponse>> getSettings();

  Future<Either<Failure, bool>> updateSettings(UpdateSettingsDashboardUsecaseParam params);

  Future<Either<Failure, bool>> createNewOffer(CreateNewOfferDashboardUsecaseParam params);
  Future<Either<Failure, RunningTripEntity>> getRunningTrip();
  Future<Either<Failure, bool>> goingToClient(String id);
  Future<Either<Failure, bool>> arrivedToClient(ArrivedToClientEntity params);
  Future<Either<Failure, List<EmergencyContactEntity>>> getEmergencyContacts();
  Future<Either<Failure, EmergencyContactEntity>> addEmergencyContacts(EmergencyContactEntity params);
  Future<Either<Failure, EmergencyContactEntity>> editEmergencyContacts(EmergencyContactEntity params);
  Future<Either<Failure, bool>> deleteEmergencyContact(EmergencyContactEntity params);
  Future<Either<Failure, bool>> startDriverTrip(StartDriverTripParams params);
  Future<Either<Failure, bool>> completeDriverTrip(StartDriverTripParams params);
  Future<Either<Failure, bool>> driverRateClient(DriverRateClientParams params);
  Future<Either<Failure, bool>> emergencySupport(EmergencySupportParams params);
  Future<Either<Failure, SupportDetailsEntity>> getSupportDetails(GetSupportDetailsParams params);
  Future<Either<Failure, bool>> createNewOfferNonSocket(CreateNewOfferDashboardUsecaseParam params);

  Future<Either<Failure, bool>> createDriverRating(CreateUpdateDriverRatingUsecaseParam params);

  Future<Either<Failure, bool>> updateDriverRating(CreateUpdateDriverRatingUsecaseParam params);

  Future<Either<Failure, bool>> acceptTrip(String params);

  void listenToUpdateTripAutoAccept(Function(UpdateTripAutoAcceptEntity trip) params);

  void listenToAcceptOffer(Function(AcceptOfferEntity trip) params);

  void listenToUpdateTripPrice(Function(UpdateTripPriceEntity trip) params);

  void listenToNewTrip(Function(AvailableRideTripEntity trip) params);

  void listenToRemoveTrip(Function(String tripId) params);
  void listenToEndTrip(Function(String tripId) params);
  void listenToClientComing(Function(String tripId) params);
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
        return Right(data['status']);
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
      CliLogger.info("Listen to End Trip ");
      log("Listen to End Trip ");
      SharedWebSocket.socket!.on(SocketIOListeners.listenToClientComing, (data) {
        CliLogger.info("End Trip data :  $data");
        log("End Trip data :  $data");
        params(data['trip']['_id']);
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
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
  Future<Either<Failure, bool>> goingToClient(String id) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.goingToClient(id),
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
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
  Future<Either<Failure, bool>> startDriverTrip(StartDriverTripParams params) async {
    try {
      final response = await _apiConsumer.put(EndPoints.startDriverTrip(params.tripId), data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
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
        print(" New Trip Trip data :  ${data}");
        params(GetAvailableRideNonSocketTripModel.fromJson(data["tripsUpdated"]));
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  Future<Either<Failure, RateResponseEntity>> addRateWithDriver(AddRateWithDriverParams params) async{
    final url = "${EndPoints.addRateToClientWithDriverNonSocket}";

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
    final url = "${EndPoints.updateDriverRatingNonSocket}";

    final response = await _apiConsumer.put(url,data: params.toJson());

    return response.fold(
          (l) => Left(l),
          (data) {
        final rateData = CreateNonTrackOfferModel.fromJson(data);
        return Right(rateData);
      },
    );
  }

}
