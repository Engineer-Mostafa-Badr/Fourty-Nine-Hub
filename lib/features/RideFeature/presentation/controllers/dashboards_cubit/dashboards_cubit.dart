import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_trips_usecase.dart';
import 'package:fourtyninehub/features/ride/driver_dashboard/domain/usecases/create_rider_offer_usecase.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/dashboards/settings_dashboard_entity.dart';
import '../../../domain/entities/dashboards/trip_entity.dart';
import '../../../domain/entities/dashboards/trips_response_entity.dart';
import '../../../domain/usecases/dashboards/create_driver_rating_usecase.dart';
import '../../../domain/usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import '../../../domain/usecases/dashboards/get_past_trips_usecase.dart';
import '../../../domain/usecases/dashboards/get_settings_dashboard_usecase.dart';
import '../../../domain/usecases/dashboards/update_driver_rating_usecase.dart';
import '../../../domain/usecases/dashboards/update_settings_dashboard_usecase.dart';

part 'dashboards_state.dart';

class DashboardsCubit extends Cubit<DashboardsState> {
  final GetAvailableTripsUsecase getAvailableTripsUsecase;
  final AvailableRideTripsUseCase availableRideTripsUseCase;
  final GetPastTripsUsecase getPastTripsUsecase;
  final GetSettingsDashboardUsecase getSettingsDashboardUsecase;
  final UpdateSettingsDashboardUsecase updateSettingsDashboardUsecase;
  final CreateNewOfferDashboardUsecase createNewOfferDashboardUsecase;
  final CreateDriverRatingUsecase createDriverRatingUsecase;
  final UpdateDriverRatingUsecase updateDriverRatingUsecase;
  final CreateRiderOfferUseCase createRiderOfferUseCase;
  DashboardsCubit(
    this.getAvailableTripsUsecase,
    this.getPastTripsUsecase,
    this.availableRideTripsUseCase,
    this.getSettingsDashboardUsecase,
    this.updateSettingsDashboardUsecase,
    this.createNewOfferDashboardUsecase,
    this.createDriverRatingUsecase,
    this.updateDriverRatingUsecase,
    this.createRiderOfferUseCase,
  ) : super(const DashboardsState());
  List<TripEntity> availableTripsNonSocket = [];
  Future<void> getAvailableTrips(BuildContext context) async {
    // if (isClosed) {
    //   return;
    // }
    if (!hasMoreData || isLoadingMore) return;
  // DashboardsCubit(this.getAvailableTripsUsecase, this.getPastTripsUsecase, this.availableRideTripsUseCase, this.getSettingsDashboardUsecase, this.updateSettingsDashboardUsecase,
  //     this.createRiderOfferUseCase)
  //     : super(const DashboardsState());

  Future<void> getAvailableTrips(String subCateoryId, BuildContext context) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingAvailable));
    isLoadingMore = true;
    final Either<Failure, TripsResponseEntity> result =
        await getAvailableTripsUsecase(AvailableRideTripsUseCaseParams(
            page: currentPage, limit: pageSize));


    // if (isClosed) return;
    result.fold(
      (failure) {
        showErrorMessage(context, getFailureMessage(failure, context));
        isLoadingMore = false;
        log("objectavailableRideTripsEEEE");
        log("Failure");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (availableTrips) {
        log("Suzccess");
        List<TripEntity> availableRideTrips = [];
        availableRideTrips.addAll(state.availableTrips ?? []);
        availableRideTrips.addAll(availableTrips.data.trips);
        if (availableTrips.data.trips.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }
        isLoadingMore = false;
        availableTripsNonSocket = availableRideTrips;
        emit(state.copyWith(
            status: DashboardsStates.success,
            availableTrips: availableRideTrips));
        // emit(state.copyWith(status: DashboardsStates.success, availableTrips: availableTrips.data.trips));
      },
    );
  }
  }

  void loadAvailableRideTrips(BuildContext context) async {
    print("loadAvailableRideTrips1");
    emit(state.copyWith(availableRideTrips: []));
    currentPage = 1;
    hasMoreData = true;
    await getAvailableRideTrips(context);
    print("loadAvailableRideTrips2");
  }

  // List<AvailableRideTripEntity> availableRideTrips = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  Future<void> getAvailableRideTrips(BuildContext context) async {
    if (!hasMoreData || isLoadingMore) return;
    emit(state.copyWith(status: DashboardsStates.loading));
    isLoadingMore = true;
    final response = await availableRideTripsUseCase(
      AvailableRideTripsUseCaseParams(page: currentPage, limit: pageSize),
    );
    response.fold(
      (failure) {
        showErrorMessage(context, getFailureMessage(failure, context));
        isLoadingMore = false;
        print("objectavailableRideTripsEEEE");
        print("Failure");

        emit(state.copyWith(failure: failure, status: DashboardsStates.error));
      },
      (data) {
        print("objectavailableRideTrips");
        List<AvailableRideTripEntity> availableRideTrips = [];
        availableRideTrips.addAll(state.availableRideTrips ?? []);
        availableRideTrips.addAll(data);
        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }
        isLoadingMore = false;
        emit(state.copyWith(
            status: DashboardsStates.success,
            availableRideTrips: availableRideTrips));
      },
    );
  }

  Future<void> getPastTrips(BuildContext context, String type) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, TripsResponseEntity> result =
        await getPastTripsUsecase(type);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (pastTrips) {
        log("Suzccess");
        emit(state.copyWith(status: DashboardsStates.success, pastTrips: pastTrips.data.trips));
      },
    );
  }

  Future<void> getSettings(BuildContext context) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingSettings));

    final Either<Failure, SettingsDashboardEntityResponse> result =
        await getSettingsDashboardUsecase(const NoParams());

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (settings) {
        log("Suzccess");
        emit(state.copyWith(status: DashboardsStates.success, settings: settings.data));
      },
    );
  }

  Future<void> updateSettings(BuildContext context, UpdateSettingsDashboardUsecaseParam param) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingSettings));

    final Either<Failure, bool> result =
        await updateSettingsDashboardUsecase(param);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (settings) {
        log("Suzccess");
        // emit(state.copyWith(status: DashboardsStates.success));
        // if (settings) {
        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text('Updated Successful.'),
        //   ));
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text('Some thing went error!'),
        //   ));
        // }
        getSettings(context);
      },
    );
  }

  Future<void> createNewOffer(
      BuildContext context, CreateNewOfferDashboardUsecaseParam param) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingCreateOffer));

    final Either<Failure, bool> result =
        await createNewOfferDashboardUsecase(param);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (settings) {
        log("Suzccess");
        emit(state.copyWith(status: DashboardsStates.successOffer));
      },
    );
  }

  Future<void> createOffer({required String tripId, required num price}) async {
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final response = await createRiderOfferUseCase(CreateRiderOfferParams(tripId: tripId, price: price, lat: currentPosition.latitude, lng: currentPosition.longitude));
    response.fold((l) => emit(state.copyWith(failure: l, status: DashboardsStates.error)), (data) {
      emit(state.copyWith(status: DashboardsStates.success));
    });
  }

  Future<void> createDriverRating(
      BuildContext context, CreateUpdateDriverRatingUsecaseParam param) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingRating));

    final Either<Failure, bool> result = await createDriverRatingUsecase(param);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (settings) {
        log("Suzccess");
        emit(state.copyWith(status: DashboardsStates.successRating));
      },
    );
  }

  Future<void> updateDriverRating(
      BuildContext context, CreateUpdateDriverRatingUsecaseParam param) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingRating));

    final Either<Failure, bool> result = await updateDriverRatingUsecase(param);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (settings) {
        log("Suzccess");
        emit(state.copyWith(status: DashboardsStates.successRating));
      },
    );
  }

  Future<void> refuseTrip(BuildContext context, String id) async {
    emit(state.copyWith(status: DashboardsStates.loadingAvailable));
    availableTripsNonSocket
        .removeWhere((element) => element.tripDetails!.id == id);
    emit(state.copyWith(
        status: DashboardsStates.successOffer,
        availableTrips: availableTripsNonSocket));
  }
}
