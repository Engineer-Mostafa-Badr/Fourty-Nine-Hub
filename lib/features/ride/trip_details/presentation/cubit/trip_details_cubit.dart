import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../requests_history/data/models/trip_model.dart';
import '../../data/models/cancel_reason_model.dart';
import '../../domain/usecases/get_cancel_reason_use_case.dart';
import '../../domain/usecases/get_trip_details_use_case.dart';

part 'trip_details_state.dart';

class TripDetailsCubit extends Cubit<TripDetailsState> {
  final GetTripDetailsUseCase _getTripDetailsUseCase;
  final GetCancelReasonUseCase _getCancelReasonUseCase;
  TripDetailsCubit(this._getTripDetailsUseCase, this._getCancelReasonUseCase)
      : super(TripDetailsInitial());
  void getCancelReasons() async {
    final response = await _getCancelReasonUseCase.call(const NoParams());
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(status: TripDetailsStates.error, failure: failure));
    },
        (response) => emit(state.copyWith(
            cancelReasons: response, status: TripDetailsStates.initState)));
  }

  void getTripDetails() async {
    final response = await _getTripDetailsUseCase.call(0);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(status: TripDetailsStates.error, failure: failure));
    },
        (response) => emit(state.copyWith(
            trip: response, status: TripDetailsStates.initState)));
  }

  void loadData() async {
    getTripDetails();
    getCancelReasons();
  }
}
