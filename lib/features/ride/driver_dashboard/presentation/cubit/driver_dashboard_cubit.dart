import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';

import '../../../../../core/error/failure.dart';
import '../../../history_ride/data/models/trip_model.dart';
import '../../data/models/driver_statistics_model.dart';
import '../../domain/usecases/get_driver_new_trips_usecase.dart';
import '../../domain/usecases/get_driver_statistics_usecase.dart';

part 'driver_dashboard_state.dart';

class DriverDashboardCubit extends Cubit<DriverDashboardState> {
  final GetDriverStatisticsUseCase _getDriverStatisticsUseCase;
  final GetDriverNewTripsUseCase _getDriverNewTripsUseCase;
  DriverDashboardCubit(
    this._getDriverNewTripsUseCase,
    this._getDriverStatisticsUseCase,
  ) : super(const DriverDashboardState());

  void loadData() async {
    final response = await _getDriverNewTripsUseCase.call(const NoParams());
    response.fold(
        (l) => emit(state.copyWith(
              failure: l,
              status: DriverDashboardStates.error,
            )), (trips) async {
      final statisticsResponse =
          await _getDriverStatisticsUseCase.call(const NoParams());
      statisticsResponse.fold(
          (l) => emit(state.copyWith(
                failure: l,
                status: DriverDashboardStates.error,
              )),
          (statistics) => emit(state.copyWith(
              trips: trips,
              statistics: statistics,
              status: DriverDashboardStates.initState)));
    });
  }

  void changeConnectState({required bool v}) {

    emit(state.copyWith(connected: v));
    
    
  }
}
