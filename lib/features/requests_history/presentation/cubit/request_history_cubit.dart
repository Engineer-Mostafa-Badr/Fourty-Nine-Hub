import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/data/models/shipping_request_model/shipping_request_model.dart';
import 'package:fourtyninehub/features/requests_history/data/models/trip_model.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../health_feature/health/domain/entities/appointment_booking_entity.dart';
import '../../../health_feature/health/domain/usecases/get_my_appointment_bookings_usecase.dart';
import '../../data/models/food_order_model.dart';
import '../../domain/usecases/get_food_history_usecase.dart';
import '../../domain/usecases/get_shipping_requests_usecase.dart';

part 'request_history_state.dart';

class RequestHistoryCubit extends Cubit<RequestHistoryState> {
  final GetShippingRequestsUseCase _getShippingRequestsUseCase;
  // final GetHistoryRideUseCase _getHistoryRideUseCase;
  final GetFoodHistoryUseCase _getFoodHistoryUseCase;
  final GetMyAppointmentBookingsHistoryUseCase _getMyAppointmentBookingsUseCase;

  RequestHistoryCubit(this._getFoodHistoryUseCase,
      this._getShippingRequestsUseCase, this._getMyAppointmentBookingsUseCase)
      : super(const RequestHistoryState());

  void loadData() async {
    await getHealthBookings();
    // await getRideTrips();
    await getFoodOrders();
    await getShippingRequests();
  }

  // Future<void> getRideTrips() async {
  //   final response = await _getHistoryRideUseCase.call(const NoParams());
  //   response.fold(
  //       (failure) => emit(state.copyWith(
  //           status: RequestHistoryStates.error, failure: failure)),
  //       (response) => emit(state.copyWith(
  //           trips: response, status: RequestHistoryStates.initState)));
  // }

  Future<void> getFoodOrders() async {
    final response = await _getFoodHistoryUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
            status: RequestHistoryStates.error, failure: failure)),
        (response) => emit(state.copyWith(
            foodOrders: response, status: RequestHistoryStates.initState)));
  }

  Future<void> getHealthBookings() async {
    final response =
        await _getMyAppointmentBookingsUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
            status: RequestHistoryStates.error, failure: failure)),
        (data) => emit(state.copyWith(
            healthBookings: data, status: RequestHistoryStates.initState)));
  }

  Future<void> getShippingRequests() async {
    debugPrint("Fetching shipping requests...");
    final response = await _getShippingRequestsUseCase.call(const NoParams());
    response.fold((failure) {
      debugPrint("Failed to fetch shipping requests: ${failure.toString()}");
      emit(
          state.copyWith(status: RequestHistoryStates.error, failure: failure));
    }, (response) {
      debugPrint("Successfully fetched shipping requests: $response");
      emit(state.copyWith(
          shippingRequests: response, status: RequestHistoryStates.initState));
    });
  }
}
