import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/driver_dashboard/domain/usecases/create_rider_offer_usecase.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../requests_history/data/models/trip_model.dart';
import '../../data/models/driver_statistics_model.dart';
import '../../domain/usecases/accept_ride_usecase.dart';
import '../../domain/usecases/get_driver_new_trips_usecase.dart';
import '../../domain/usecases/get_driver_statistics_usecase.dart';

part 'driver_dashboard_state.dart';

class DriverDashboardCubit extends Cubit<DriverDashboardState> {
  final GetDriverStatisticsUseCase _getDriverStatisticsUseCase;
  final GetDriverNewTripsUseCase _getDriverNewTripsUseCase;
  final AcceptRideUseCase _acceptRideUseCase;
  final CreateRiderOfferUseCase _createRiderOfferUseCase;
  DriverDashboardCubit(
      this._getDriverNewTripsUseCase,
      this._getDriverStatisticsUseCase,
      this._acceptRideUseCase,
      this._createRiderOfferUseCase)
      : super(const DriverDashboardState());

  void acceptRide({required String id}) async {
    final response = await _acceptRideUseCase(id);
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: DriverDashboardStates.error));
    }, (data) {});
  }

  void changeConnectState({required bool v}) {
    emit(state.copyWith(connected: v));
  }

  void createOffer({required CreateRiderOfferParams params}) async {
    final response = await _createRiderOfferUseCase(params);
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: DriverDashboardStates.error));
    }, (data) {
      emit(state.copyWith(status: DriverDashboardStates.success));
    });
  }

  void loadData() async {
    final response = await _getDriverNewTripsUseCase.call(const NoParams());
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(
        failure: l,
        status: DriverDashboardStates.error,
      ));
    }, (trips) async {
      emit(state.copyWith(trips: trips));
    });
  }
}
