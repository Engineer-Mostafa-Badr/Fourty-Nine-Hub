import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/history_ride/data/models/trip_model.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../domain/usecases/get_history_ride_use_case.dart';

part 'history_ride_state.dart';

class HistoryRideCubit extends Cubit<HistoryRideState> {
  final GetHistoryRideUseCase _getHistoryRideUseCase;
  HistoryRideCubit(this._getHistoryRideUseCase)
      : super(const HistoryRideState());

  void loadData() async {
    final response = await _getHistoryRideUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(
            state.copyWith(status: HistoryRideStates.error, failure: failure)),
        (response) => emit(state.copyWith(
            trips: response, status: HistoryRideStates.initState)));
  }
}
