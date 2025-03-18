import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_trips_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/dashboards/trip_entity.dart';
import '../../../domain/entities/dashboards/trips_response_entity.dart';
import '../../../domain/usecases/dashboards/get_past_trips_usecase.dart';

part 'dashboards_state.dart';

class DashboardsCubit extends Cubit<DashboardsState> {
  final GetAvailableTripsUsecase getAvailableTripsUsecase;
  final GetPastTripsUsecase getPastTripsUsecase;
  DashboardsCubit(this.getAvailableTripsUsecase, this.getPastTripsUsecase)
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
