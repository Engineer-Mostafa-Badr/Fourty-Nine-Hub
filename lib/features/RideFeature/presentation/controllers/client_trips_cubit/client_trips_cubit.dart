import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:go_router/go_router.dart';

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
  final GetClientPendingUntrackedTripsUseCase getClientPendingUntrackedTripsUseCase;
  final CancelNonTrackTripUseCase cancelNonTrackTripUseCase;
  final GetClientAcceptedUntrackedTripsUseCase getClientAcceptedUntrackedTripsUseCase;
  final GetClientOfferUntrackedTripsUseCase getClientOfferUntrackedTripsUseCase;
  final AcceptNonTrackTripUseCase acceptNonTrackTripUseCase;
  final RefuseNonTrackTripUseCase refuseNonTrackTripUseCase;
  final GetClientPastUntrackedTripsUseCase getClientPastUntrackedTripsUseCase;
  ClientTripsCubit(
    this.makeNonTrackingRequestTripUsecase,
    this.getClientOffersUseCase,
    this.getLoadingOffersUsecase,
    this._getCitiesUseCase,
    this._getGovernoratesUseCase,
    this.makeLoadingRequestTripUsecase,
    this.createNonTrackTripUseCase, this.getClientPendingUntrackedTripsUseCase, this.cancelNonTrackTripUseCase, this.getClientAcceptedUntrackedTripsUseCase, this.getClientOfferUntrackedTripsUseCase, this.acceptNonTrackTripUseCase, this.refuseNonTrackTripUseCase, this.getClientPastUntrackedTripsUseCase,
  ) : super(const ClientTripsState());



  List<ClientPastTripEntity> clientPastTripsData = [];
  bool hasMoreClientPastTrips = true;
  int currentPageClientPastTrips = 1;
  bool isLoadingMoreClientPastTrips = false;

  void loadInitialClientPastTrips() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    clientPastTripsData.clear();
    currentPageClientPastTrips = 1;
    hasMoreClientPastTrips = true;
    await getClientPastTrips();
    emit(state.copyWith(status: ClientTripsStates.success));
  }

  Future<void> getClientPastTrips() async {
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

  Future<void> refuseClientTrip(String tripId) async {
    emit(state.copyWith(status: ClientTripsStates.loading));
    final response = await refuseNonTrackTripUseCase(
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
        loadInitialClientPendingTrips();
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
        context.goNamed(Routes.rideOffer);
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
