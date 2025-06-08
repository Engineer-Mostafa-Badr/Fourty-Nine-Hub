import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/create_loading_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/accept_shipping_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_shipping_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/client_trips/listen_to_offer_update_client_shipping_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/create_loading_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_client_accepted_shipping_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_client_offer_shipping_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_client_past_shipping_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_client_pending_shipping_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/refuse_shipping_trip_use_case.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../routes/routes.dart';
import '../../../../health_feature/create_doctor/domain/entities/city.dart';
import '../../../../health_feature/create_doctor/domain/entities/governorate_entity.dart';
import '../../../../health_feature/create_doctor/domain/usecases/get_cities.dart';
import '../../../../health_feature/create_doctor/domain/usecases/get_governorates.dart';
import '../../../domain/entities/create_no_track_trip_entity.dart';
import '../../../domain/entities/dashboards/trip_entity.dart';
import '../../../domain/entities/get_client_accepted_trips_entity.dart';
import '../../../domain/entities/get_client_offer_trips_entity.dart';
import '../../../domain/entities/get_client_past_trips_entity.dart';
import '../../../domain/entities/get_client_pending_trips_entity.dart';
import '../../../domain/entities/get_offers_entity.dart';
import '../../../domain/usecases/accept_non_track_trip_use_case.dart';
import '../../../domain/usecases/cancel_non_track_trip_use_case.dart';
import '../../../domain/usecases/client_trips/listen_to_offer_update_client_untracked_trip_use_case.dart';
import '../../../domain/usecases/create_non_track_trip_use_case.dart';
import '../../../domain/usecases/get_client_accepted_untracked_trips_use_case.dart';
import '../../../domain/usecases/get_client_offer_untracked_trips_use_case.dart';
import '../../../domain/usecases/get_client_offers_usecase.dart';
import '../../../domain/usecases/get_client_past_untracked_trips_use_case.dart';
import '../../../domain/usecases/get_client_pending_untracked_trips_use_case.dart';
import '../../../domain/usecases/get_loading_offers_usecase.dart';
import '../../../domain/usecases/make_loading_request_trip_usecase.dart';
import '../../../domain/usecases/make_non_tracking_request_trip_usecase.dart';
import '../../../domain/usecases/refuse_non_track_trip_use_case.dart';

part 'client_trips_state.dart';

class ClientTripsCubit extends Cubit<ClientTripsState> {
  final MakeNonTrackingRequestTripUsecase makeNonTrackingRequestTripUsecase;
  final MakeLoadingRequestTripUsecase makeLoadingRequestTripUsecase;
  final GetClientOffersUsecase getClientOffersUseCase;
  final GetLoadingOffersUsecase getLoadingOffersUsecase;
  final GetCitiesUseCase _getCitiesUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final CreateNonTrackTripUseCase createNonTrackTripUseCase;
  final CreateLoadingTripUseCase createLoadingTripUseCase;
  final GetClientPendingUntrackedTripsUseCase getClientPendingUntrackedTripsUseCase;
  final GetClientPendingShippingTripsUseCase getClientPendingShippingTripsUseCase;
  final CancelNonTrackTripUseCase cancelNonTrackTripUseCase;
  final CancelShippingTripUseCase cancelShippingTripUseCase;
  final GetClientAcceptedUntrackedTripsUseCase getClientAcceptedUntrackedTripsUseCase;
  final GetClientAcceptedShippingTripsUseCase getClientAcceptedShippingTripsUseCase;
  final GetClientOfferUntrackedTripsUseCase getClientOfferUntrackedTripsUseCase;
  final GetClientOfferShippingTripsUseCase getClientOfferShippingTripsUseCase;
  final AcceptNonTrackTripUseCase acceptNonTrackTripUseCase;
  final AcceptShippingTripUseCase acceptShippingTripUseCase;
  final RefuseNonTrackTripUseCase refuseNonTrackTripUseCase;
  final RefuseShippingTripUseCase refuseShippingTripUseCase;
  final GetClientPastUntrackedTripsUseCase getClientPastUntrackedTripsUseCase;
  final GetClientPastShippingTripsUseCase getClientPastShippingTripsUseCase;
  final ListenToOfferUpdateUntrackedTripUseCase listenToOfferUpdateUntrackedTripUseCase;
  final ListenToOfferUpdateShippingTripUseCase listenToOfferUpdateShippingTripUseCase;

  ClientTripsCubit(
    this.makeNonTrackingRequestTripUsecase,
    this.getClientOffersUseCase,
    this.getLoadingOffersUsecase,
    this._getCitiesUseCase,
    this._getGovernoratesUseCase,
    this.makeLoadingRequestTripUsecase,
    this.getClientAcceptedShippingTripsUseCase,
    this.getClientOfferShippingTripsUseCase,
    this.createLoadingTripUseCase,
    this.cancelShippingTripUseCase,
    this.listenToOfferUpdateShippingTripUseCase,
    this.refuseShippingTripUseCase,
    this.acceptShippingTripUseCase,
    this.getClientPastShippingTripsUseCase,
    this.createNonTrackTripUseCase, this.getClientPendingUntrackedTripsUseCase,this.getClientPendingShippingTripsUseCase, this.cancelNonTrackTripUseCase, this.getClientAcceptedUntrackedTripsUseCase, this.getClientOfferUntrackedTripsUseCase, this.acceptNonTrackTripUseCase, this.refuseNonTrackTripUseCase, this.getClientPastUntrackedTripsUseCase, this.listenToOfferUpdateUntrackedTripUseCase,
  ) : super(const ClientTripsState());


  void listenToUpdateOfferTripShipping() {
    CliLogger.info('Listen To New Offer Trip');
    listenToOfferUpdateShippingTripUseCase((trip) {
      CliLogger.info('Listen To New Offer Trip111');
      clientOfferTripsData.removeWhere((e) => e.id == trip.id);
      final updatedTrip = ClientOfferTripEntity(
        id: trip.id,
        status: trip.status,
        price: trip.price,
        passengers: trip.passengers,
        newOfferPrice: trip.newOfferPrice,
        driverDetails: trip.driverDetails,
        tripDetails: trip.tripDetails,
        isFromSocket: true,
      );
      clientOfferTripsData.insert(0, updatedTrip);
      emit(state.copyWith(status: ClientTripsStates.success));
    });
  }
  void listenToUpdateOfferTripNonSocket() {
    CliLogger.info('Listen To New Trip');

    listenToOfferUpdateUntrackedTripUseCase((trip) {
      if (isClosed) return;

      final updatedTrip = ClientOfferTripEntity(
        id: trip.id,
        status: trip.status,
        price: trip.price,
        passengers: trip.passengers,
        newOfferPrice: trip.newOfferPrice,
        driverDetails: trip.driverDetails,
        tripDetails: trip.tripDetails,
        isFromSocket: true,
      );

      List<ClientOfferTripEntity> list = List.from(clientOfferTripsData ?? []);

      // Debug: Log current state
      CliLogger.info('Current list length: ${list.length}');
      CliLogger.info('Current list IDs: ${list.map((e) => e.id).toList()}');
      CliLogger.info('New trip ID: ${updatedTrip.id}');

      // Check if trip already exists in the list
      final existingIndex = list.indexWhere((item) => item.id == updatedTrip.id);

      if (existingIndex != -1) {
        // Item exists - replace it at the same position
        list[existingIndex] = updatedTrip;
        CliLogger.info('Replaced existing offer at index $existingIndex');
      } else {
        // Item doesn't exist - add it as new item
        list.add(updatedTrip);
        CliLogger.info('Added new offer to list. New length: ${list.length}');
      }

      // Debug: Log state before emitting
      CliLogger.info('About to emit state with list length: ${list.length}');
      CliLogger.info('List IDs after update: ${list.map((e) => e.id).toList()}');

      emit(state.copyWith(clientOfferTripData: list));

      // Debug: Log state after emitting
      CliLogger.info('State emitted. Current state list length: ${state.clientOfferTripData?.length}');
      log('Final list count: ${list.length}');
      log(updatedTrip.toString());
    });
  }


  void listenToUpdateOfferTripNonSocket2() {
    CliLogger.info('Listen To New Trip');

    listenToOfferUpdateUntrackedTripUseCase((trip) {
      if (isClosed) return;

      final updatedTrip = ClientOfferTripEntity(
        id: trip.id,
        status: trip.status,
        price: trip.price,
        passengers: trip.passengers,
        newOfferPrice: trip.newOfferPrice,
        driverDetails: trip.driverDetails,
        tripDetails: trip.tripDetails,
        isFromSocket: true,
      );

      List<ClientOfferTripEntity> list = List.from(clientOfferTripsData ?? []);

      // Check if list is empty or if trip doesn't exist
      if (list.isEmpty) {
        // If no data exists, add the new offer
        list.add(updatedTrip);
        CliLogger.info('Added new offer to empty list');
      } else {
        // Remove any existing trip with the same ID
        final removedCount = list.length;
        list.removeWhere((item) => item.id == updatedTrip.id);

        if (list.length < removedCount) {
          CliLogger.info('Replaced existing offer');
        } else {
          CliLogger.info('Added new offer to existing list');
        }

        // Insert updated trip at the beginning
        list.insert(0, updatedTrip);
      }

      emit(state.copyWith(clientOfferTripData: list));
      log('Final list count: ${list.length}');
      log(updatedTrip.toString());
    });
  }



  void listenToUpdateOfferTripNonSocket1() {
    CliLogger.info('Listen To New Trip');
    // TripsResponseEntity
    listenToOfferUpdateUntrackedTripUseCase((trip) {
      List<ClientOfferTripEntity> list = clientOfferTripsData ?? [];
      list.insert(0, trip);
      emit(state.copyWith(clientOfferTripData: list));
      log(trip.toString());
    });
  }

/*
    void listenToNewTripNonSocket() {
      CliLogger.info('Listen To New Trip');
      // TripsResponseEntity
      listenToAvailableUntrackedTripUseCase((trip) {
        List<AvailableRideNonSocketTripEntity> list = availableRideNonSocketData ?? [];
        list.insert(0, trip);
        emit(state.copyWith(availableRideNonSocketTrips: list));
        log(trip.toString());
      });
    }
 */



  List<ClientPastTripEntity> clientPastTripsData = [];
  bool hasMoreClientPastTrips = true;
  int currentPageClientPastTrips = 1;
  bool isLoadingMoreClientPastTrips = false;

  void loadInitialClientPastTrips() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    clientPastTripsData.clear();
    currentPageClientPastTrips = 1;
    hasMoreClientPastTrips = true;
    isLoadingMoreClientPastTrips = false;
    await getClientPastTrips();
    emit(state.copyWith(status: ClientTripsStates.success));
  }
  void loadInitialClientPastShippingTrips() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    clientPastTripsData.clear();
    currentPageClientPastTrips = 1;
    hasMoreClientPastTrips = true;
    isLoadingMoreClientPastTrips = false;
    await getClientPastShippingTrips();
    emit(state.copyWith(status: ClientTripsStates.success));
  }

  Future<void> getClientPastTrips() async {
    print("hasMoreClientPastTrips $hasMoreClientPastTrips");
    print("isLoadingMoreClientPastTrips $isLoadingMoreClientPastTrips");
    if (!hasMoreClientPastTrips || isLoadingMoreClientPastTrips) return;
    isLoadingMoreClientPastTrips = true;
    emit(state.copyWith(status: ClientTripsStates.loading));
    final response = await getClientPastUntrackedTripsUseCase(
        ClientPendingTripParams(page: currentPageClientPastTrips, limit: 5));
    response.fold(
          (failure) {
        isLoadingMoreClientPastTrips = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: ClientTripsStates.error));
      },
          (data) {
        clientPastTripsData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreClientPastTrips = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: ClientTripsStates.loading));

        } else {
          currentPageClientPastTrips++;
        }

        isLoadingMoreClientPastTrips = false;
        emit(state.copyWith(clientPastTripData: data,));
      },
    );
  }

  Future<void> getClientPastShippingTrips() async {
    if (!hasMoreClientPastTrips || isLoadingMoreClientPastTrips) return;
    isLoadingMoreClientPastTrips = true;
    emit(state.copyWith(status: ClientTripsStates.loading));
    final response = await getClientPastShippingTripsUseCase(
        ClientPendingTripParams(page: currentPageClientPastTrips, limit: 5));
    response.fold(
          (failure) {
        isLoadingMoreClientPastTrips = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: ClientTripsStates.error));
      },
          (data) {
        clientPastTripsData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreClientPastTrips = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: ClientTripsStates.loading));

        } else {
          currentPageClientPastTrips++;
        }

        isLoadingMoreClientPastTrips = false;
        emit(state.copyWith(clientPastTripData: data,));
      },
    );
  }

  Future<void> cancelClientTrip(String tripId) async {
    emit(state.copyWith(status: ClientTripsStates.loading));

    final response = await cancelNonTrackTripUseCase(
      CancelNonTrackTripParams(tripsIds: [tripId]),
    );

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: ClientTripsStates.error));
      },
          (cancelTrip) {
        emit(state.copyWith(
          createNonTrackTripEntity: cancelTrip,
          status: ClientTripsStates.success,
          showSnackbar: true,
        ));
        loadInitialClientPendingTrips();
      },
    );
  }

  Future<void> cancelClientShippingTrip(String tripId) async {
    emit(state.copyWith(status: ClientTripsStates.loading));

    final response = await cancelShippingTripUseCase(
      CancelNonTrackTripParams(tripsIds: [tripId]),
    );

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: ClientTripsStates.error));
      },
          (cancelTrip) {
        emit(state.copyWith(
          createNonTrackTripEntity: cancelTrip,
          status: ClientTripsStates.success,
          showSnackbar: true,
        ));
        loadInitialClientPendingTrips();
      },
    );
  }


  Future<void> acceptClientTrip(String tripId) async {
    emit(state.copyWith(status: ClientTripsStates.loading));

    final response = await acceptNonTrackTripUseCase(
      AcceptNonTrackTripParams(tripsId: tripId),
    );

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: ClientTripsStates.error));
      },
          (cancelTrip) {
        emit(state.copyWith(
          createNonTrackTripEntity: cancelTrip,
          status: ClientTripsStates.success,
          showSnackbar: true,
        ));
        loadInitialClientOfferTrips();
        loadInitialClientAcceptedTrips();
        loadInitialClientPendingTrips();
      },
    );
  }

  Future<void> acceptClientShippingTrip(String tripId) async {
    emit(state.copyWith(status: ClientTripsStates.loading));

    final response = await acceptShippingTripUseCase(
      AcceptNonTrackTripParams(tripsId: tripId),
    );

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: ClientTripsStates.error));
      },
          (cancelTrip) {
            clientOfferTripsData.removeWhere((e)=>e.id==tripId);
        emit(state.copyWith(
          createNonTrackTripEntity: cancelTrip,
          status: ClientTripsStates.success,
          showSnackbar: true,
        ));
      },
    );
  }

  Future<bool> refuseClientTrip(String tripId) async {
    emit(state.copyWith(status: ClientTripsStates.loading));
    final response = await refuseNonTrackTripUseCase(
      AcceptNonTrackTripParams(tripsId: tripId),
    );
    bool result = false;
    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: ClientTripsStates.error));
        result= false;
      },
          (cancelTrip) {
            result= true;
        emit(state.copyWith(
          createNonTrackTripEntity: cancelTrip,
          status: ClientTripsStates.success,
          showSnackbar: true,
        ));
        loadInitialClientOfferTrips();
        loadInitialClientPendingTrips();
      },
    );
    return result;
  }
  Future<void> refuseClientShippingTrip(String tripId,BuildContext context) async {
    showLoadingDialog(context);
    final response = await refuseShippingTripUseCase(
      AcceptNonTrackTripParams(tripsId: tripId),
    );
    clientOfferTripsData.removeWhere((e)=>e.id==tripId);
    emit(state.copyWith(status: ClientTripsStates.success));
    response.fold(
          (failure) {
            context.pop();
        emit(state.copyWith(failure: failure, status: ClientTripsStates.error));
      },
          (cancelTrip) {
            context.pop();
            clientOfferTripsData.removeWhere((e)=>e.id==tripId);
        emit(state.copyWith(
          createNonTrackTripEntity: cancelTrip,
          status: ClientTripsStates.success,
          showSnackbar: true,
        ));
      },
    );
  }

  List<ClientOfferTripEntity> clientOfferTripsData = [];
  bool hasMoreClientOfferTrips = true;
  int currentPageClientOfferTrips = 1;
  bool isLoadingMoreClientOfferTrips = false;

  void loadInitialClientOfferTrips() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    clientOfferTripsData.clear();
    currentPageClientOfferTrips = 1;
    hasMoreClientOfferTrips = true;
    await getClientOfferTrips();
    emit(state.copyWith(status: ClientTripsStates.success));
  }

  void loadInitialClientOfferShippingTrips() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    clientOfferTripsData.clear();
    currentPageClientOfferTrips = 1;
    hasMoreClientOfferTrips = true;
    await getClientOfferShippingTrips();
    emit(state.copyWith(status: ClientTripsStates.success));
  }

  Future<void> getClientOfferTrips() async {
    if (!hasMoreClientOfferTrips || isLoadingMoreClientOfferTrips) return;
    isLoadingMoreClientOfferTrips = true;
    emit(state.copyWith(status: ClientTripsStates.loading));
    final response = await getClientOfferUntrackedTripsUseCase(
        ClientPendingTripParams(page: currentPageClientOfferTrips, limit: 5));
    response.fold(
          (failure) {
        isLoadingMoreClientOfferTrips = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: ClientTripsStates.error));
      },
          (data) {
        clientOfferTripsData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreClientOfferTrips = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: ClientTripsStates.loading));

        } else {
          currentPageClientOfferTrips++;
        }

        isLoadingMoreClientOfferTrips = false;
        emit(state.copyWith(clientOfferTripData: data,));
      },
    );
  }
  Future<void> getClientOfferShippingTrips() async {
    if (!hasMoreClientOfferTrips || isLoadingMoreClientOfferTrips) return;
    isLoadingMoreClientOfferTrips = true;
    emit(state.copyWith(status: ClientTripsStates.loading));
    final response = await getClientOfferShippingTripsUseCase(
        ClientPendingTripParams(page: currentPageClientOfferTrips, limit: 5));
    response.fold(
          (failure) {
        isLoadingMoreClientOfferTrips = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: ClientTripsStates.error));
      },
          (data) {
        clientOfferTripsData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreClientOfferTrips = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: ClientTripsStates.loading));

        } else {
          currentPageClientOfferTrips++;
        }

        isLoadingMoreClientOfferTrips = false;
        emit(state.copyWith(clientOfferTripData: data,));
      },
    );
  }


  List<ClientPendingTripEntity> clientPendingTripsData = [];
  bool hasMoreClientPendingTrips = true;
  int currentPageClientPendingTrips = 1;
  bool isLoadingMoreClientPendingTrips = false;

  void loadInitialClientPendingTrips() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    clientPendingTripsData.clear();
    currentPageClientPendingTrips = 1;
    hasMoreClientPendingTrips = true;
    await getClientPendingTrips();
    emit(state.copyWith(status: ClientTripsStates.success));
  }
  void loadInitialClientPendingShippingTrips() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    clientPendingTripsData.clear();
    currentPageClientPendingTrips = 1;
    hasMoreClientPendingTrips = true;
    await getClientPendingShippingTrips();
    emit(state.copyWith(status: ClientTripsStates.success));
  }

  Future<void> getClientPendingTrips() async {
    if (!hasMoreClientPendingTrips || isLoadingMoreClientPendingTrips) return;
    isLoadingMoreClientPendingTrips = true;
    emit(state.copyWith(status: ClientTripsStates.loading));
    final response = await getClientPendingUntrackedTripsUseCase(
         ClientPendingTripParams(page: currentPageClientPendingTrips, limit: 5));
    response.fold(
          (failure) {
        isLoadingMoreClientPendingTrips = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: ClientTripsStates.error));
      },
          (data) {
            clientPendingTripsData.addAll(data);
        if ((data.length) < 5) {
          hasMoreClientPendingTrips = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: ClientTripsStates.loading));

        } else {
          currentPageClientPendingTrips++;
        }

        isLoadingMoreClientPendingTrips = false;
        emit(state.copyWith(clientPendingTripData: data,));
      },
    );
  }
  Future<void> getClientPendingShippingTrips() async {
    if (!hasMoreClientPendingTrips || isLoadingMoreClientPendingTrips) return;
    isLoadingMoreClientPendingTrips = true;
    emit(state.copyWith(status: ClientTripsStates.loading));
    final response = await getClientPendingShippingTripsUseCase(
         ClientPendingTripParams(page: currentPageClientPendingTrips, limit: 5));
    response.fold(
          (failure) {
        isLoadingMoreClientPendingTrips = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: ClientTripsStates.error));
      },
          (data) {
            clientPendingTripsData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreClientPendingTrips = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: ClientTripsStates.loading));

        } else {
          currentPageClientPendingTrips++;
        }

        isLoadingMoreClientPendingTrips = false;
        emit(state.copyWith(clientPendingTripData: data,));
      },
    );
  }


  List<ClientAcceptedTripEntity> clientAcceptedTripsData = [];
  bool hasMoreClientAcceptedTrips = true;
  int currentPageClientAcceptedTrips = 1;
  bool isLoadingMoreClientAcceptedTrips = false;

  void loadInitialClientAcceptedTrips() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    clientAcceptedTripsData.clear();
    currentPageClientAcceptedTrips = 1;
    hasMoreClientAcceptedTrips = true;
    await getClientAcceptedTrips();
    emit(state.copyWith(status: ClientTripsStates.success));
  }
  void loadInitialClientAcceptedShippingTrips() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    clientAcceptedTripsData.clear();
    currentPageClientAcceptedTrips = 1;
    hasMoreClientAcceptedTrips = true;
    await getClientAcceptedShippingTrips();
    emit(state.copyWith(status: ClientTripsStates.success));
  }

  Future<void> getClientAcceptedTrips() async {
    if (!hasMoreClientAcceptedTrips || isLoadingMoreClientAcceptedTrips) return;
    isLoadingMoreClientAcceptedTrips = true;
    emit(state.copyWith(status: ClientTripsStates.loading));
    final response = await getClientAcceptedUntrackedTripsUseCase(
        ClientPendingTripParams(page: currentPageClientAcceptedTrips, limit: 5));
    response.fold(
          (failure) {
        isLoadingMoreClientAcceptedTrips = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: ClientTripsStates.error));
      },
          (data) {
        clientAcceptedTripsData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreClientAcceptedTrips = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: ClientTripsStates.loading));

        } else {
          currentPageClientAcceptedTrips++;
        }

        isLoadingMoreClientAcceptedTrips = false;
        emit(state.copyWith(clientAcceptedTripData: data,));
      },
    );
  }
  Future<void> getClientAcceptedShippingTrips() async {
    if (!hasMoreClientAcceptedTrips || isLoadingMoreClientAcceptedTrips) return;
    isLoadingMoreClientAcceptedTrips = true;
    emit(state.copyWith(status: ClientTripsStates.loading));
    final response = await getClientAcceptedShippingTripsUseCase(
        ClientPendingTripParams(page: currentPageClientAcceptedTrips, limit: 5));
    response.fold(
          (failure) {
        isLoadingMoreClientAcceptedTrips = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: ClientTripsStates.error));
      },
          (data) {
        clientAcceptedTripsData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreClientAcceptedTrips = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: ClientTripsStates.loading));

        } else {
          currentPageClientAcceptedTrips++;
        }

        isLoadingMoreClientAcceptedTrips = false;
        emit(state.copyWith(clientAcceptedTripData: data,));
      },
    );
  }



  Future<void> createNonTrackTrip({
    required CreateNonTrackTripParams params,
    required BuildContext context,
  }) async {
    emit(state.copyWith(status: ClientTripsStates.loading));

    final response = await createNonTrackTripUseCase(params);

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: ClientTripsStates.error));
      },
          (trip) {
        emit(state.copyWith(
          createNonTrackTripEntity: trip,
          status: ClientTripsStates.successCreateTrip,
        ));

        // ✅ Always navigate to the loading request screen
        context.goNamed(Routes.rideOffer,extra: 'ride');
      },
    );
  }

  Future<void> createShippingTrip({
    required CreateLoadingTripParams params,
    required BuildContext context,
  }) async {
    emit(state.copyWith(status: ClientTripsStates.loading));

    final response = await createLoadingTripUseCase(params);

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: ClientTripsStates.error));
      },
          (trip) {
        emit(state.copyWith(
          status: ClientTripsStates.successCreateTrip,
        ));

        // ✅ Always navigate to the loading request screen
        context.goNamed(Routes.rideOffer,extra: 'shipping');
      },
    );
  }


  // Future<void> createNonTrackTrip({required CreateNonTrackTripParams params}) async {
  //   emit(state.copyWith(status: ClientTripsStates.loading));
  //
  //   final response = await createNonTrackTripUseCase(params);
  //
  //   response.fold(
  //         (failure) {
  //       emit(state.copyWith(failure: failure, status: ClientTripsStates.error,));
  //     },
  //         (createNonTrackTripEntity) {
  //       emit(state.copyWith(
  //           createNonTrackTripEntity: createNonTrackTripEntity,
  //           status: ClientTripsStates.success,
  //       ));
  //     },
  //   );
  // }


  Future<void> getCities(String governorateId) async {
    emit(state.copyWith(status: ClientTripsStates.loadingCities));
    final response = await _getCitiesUseCase.call(governorateId);

    response.fold(
      (failure) => emit(
        state.copyWith(
          status: ClientTripsStates.error,
        ),
      ),
      (data) =>
          emit(state.copyWith(status: ClientTripsStates.success, cities: data)),
    );
  }

  Future<void> getGovernorates() async {
    emit(state.copyWith(status: ClientTripsStates.loadingGovernorates));
    final response = await _getGovernoratesUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
              status: ClientTripsStates.error,
            )), (data) {
      emit(state.copyWith(
          status: ClientTripsStates.successGovernorates, governorates: data));
    });
  }

  Future<void> getClientOffers(BuildContext context) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: ClientTripsStates.loading));

    final Either<Failure, GetOffersResponseEntity> result =
        await getClientOffersUseCase();

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: ClientTripsStates.error, failure: failure));
      },
      (offers) {
        log("Suzccess");
        emit(state.copyWith(
            status: ClientTripsStates.success, offers: offers.data.offers));
        showSuccessMessage(
            context,
            context.isArabic
                ? "تم استرجاع العروض بنجاح"
                : "Offers retrieved successfully");
      },
    );
  }

  Future<void> getLoadingOffers(BuildContext context) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: ClientTripsStates.loading));

    final Either<Failure, GetOffersResponseEntity> result =
        await getLoadingOffersUsecase();

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: ClientTripsStates.error, failure: failure));
      },
      (offers) {
        log("Suzccess");
        emit(state.copyWith(
            status: ClientTripsStates.success, offers: offers.data.offers));
        showSuccessMessage(
            context,
            context.isArabic
                ? "تم استرجاع العروض بنجاح"
                : "Offers retrieved successfully");
      },
    );
  }

  MakeNonTrackingRequestTripUsecaseParam makeNonTrackingTripParam =
      MakeNonTrackingRequestTripUsecaseParam();

  Future<void> makeNonTrackingRequestTrip(BuildContext context) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: ClientTripsStates.loadingSubmit));

    final Either<Failure, bool> result =
        await makeNonTrackingRequestTripUsecase(makeNonTrackingTripParam);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(
            status: ClientTripsStates.errorCreateTrip, failure: failure));
      },
      (settings) {
        log("Suzccess");
        emit(state.copyWith(status: ClientTripsStates.successCreateTrip));
      },
    );
  }

  MakeLoadingRequestTripUsecaseParam makeLoadingTripParam =
      MakeLoadingRequestTripUsecaseParam();

  // Future<void> makeLoadingRequestTrip(BuildContext context) async {
  //   if (isClosed) {
  //     return;
  //   }
  //   emit(state.copyWith(status: ClientTripsStates.loadingSubmit));
  //
  //   final Either<Failure, bool> result =
  //       await makeLoadingRequestTripUsecase(makeLoadingTripParam);
  //
  //   if (isClosed) return;
  //   result.fold(
  //     (failure) {
  //       log("Failure ${getFailureMessage(failure, context)}");
  //       emit(state.copyWith(
  //           status: ClientTripsStates.errorCreateTrip, failure: failure));
  //     },
  //     (settings) {
  //       log("Suzccess");
  //       emit(state.copyWith(status: ClientTripsStates.successCreateTrip));
  //     },
  //   );
  // }


}
