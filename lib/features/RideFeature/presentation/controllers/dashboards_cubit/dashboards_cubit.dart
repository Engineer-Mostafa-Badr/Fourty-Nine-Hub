import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_trips_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/dashboards/trip_entity.dart';
import '../../../domain/entities/dashboards/trips_response_entity.dart';
import '../../../domain/usecases/dashboards/get_past_trips_usecase.dart';

part 'dashboards_state.dart';

class DashboardsCubit extends Cubit<DashboardsState> {
  final GetAvailableTripsUsecase getAvailableTripsUsecase;
  final AvailableRideTripsUseCase availableRideTripsUseCase;
  final GetPastTripsUsecase getPastTripsUsecase;
  DashboardsCubit(this.getAvailableTripsUsecase, this.getPastTripsUsecase, this.availableRideTripsUseCase)
      : super(const DashboardsState());

  Future<void> getAvailableTrips(
      String subCateoryId, BuildContext context) async {
    if (isClosed) {
      return; // Prevents state emission if the cubit is already disposed.
    }
    emit(state.copyWith(status: DashboardsStates.loading));

    final Either<Failure, TripsResponseEntity> result =
        await getAvailableTripsUsecase(subCateoryId);

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (availableTrips) {
        log("Suzccess");
        emit(state.copyWith(
            status: DashboardsStates.success,
            availableTrips: availableTrips.trips));
      },
    );
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
      AvailableRideTripsUseCaseParams(
          page: currentPage, limit: pageSize),
    );
    response.fold(
          (failure) {
            showErrorMessage(context, getFailureMessage(failure, context));
            isLoadingMore = false;
            print("objectavailableRideTripsEEEE");
            print("Failure");

            emit(
          state.copyWith(failure: failure, status: DashboardsStates.error));
          },
          (data) {
            print("objectavailableRideTrips");
            List<AvailableRideTripEntity> availableRideTrips = [];
            availableRideTrips.addAll(state.availableRideTrips??[]);
            availableRideTrips.addAll(data);
        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }
        isLoadingMore = false;
        emit(state.copyWith(status: DashboardsStates.success,availableRideTrips: availableRideTrips));
      },
    );
  }

  Future<void> getPastTrips(BuildContext context) async {
    if (isClosed) {
      return; // Prevents state emission if the cubit is already disposed.
    }
    emit(state.copyWith(status: DashboardsStates.loading));

    final Either<Failure, TripsResponseEntity> result =
        await getPastTripsUsecase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (pastTrips) {
        log("Suzccess");
        emit(state.copyWith(
            status: DashboardsStates.success, pastTrips: pastTrips.trips));
      },
    );
  }
}
