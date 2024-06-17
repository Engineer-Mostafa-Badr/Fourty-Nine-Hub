import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/data/models/trip_model.dart';

import '../../../../core/abstract/use_case.dart';
import '../../data/models/food_order_model.dart';
import '../../data/models/shipping_request_model.dart';
import '../../domain/usecases/get_food_history_usecase.dart';
import '../../domain/usecases/get_history_ride_use_case.dart';
import '../../domain/usecases/get_shipping_requests_usecase.dart';

part 'request_history_state.dart';

class RequestHistoryCubit extends Cubit<RequestHistoryState> {
  final GetShippingRequestsUseCase _getShippingRequestsUseCase;
  final GetHistoryRideUseCase _getHistoryRideUseCase;
  final GetFoodHistoryUseCase _getFoodHistoryUseCase;
  RequestHistoryCubit(this._getHistoryRideUseCase, this._getFoodHistoryUseCase,
      this._getShippingRequestsUseCase)
      : super(const RequestHistoryState());

  void loadData() async {
    await getRideTrips();
    await getFoodOrders();
    await getShippingRequests();
  }

  Future<void> getRideTrips() async {
    final response = await _getHistoryRideUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
            status: RequestHistoryStates.error, failure: failure)),
        (response) => emit(state.copyWith(
            trips: response, status: RequestHistoryStates.initState)));
  }

  Future<void> getFoodOrders() async {
    final response = await _getFoodHistoryUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
            status: RequestHistoryStates.error, failure: failure)),
        (response) => emit(state.copyWith(
            foodOrders: response, status: RequestHistoryStates.initState)));
  }

  Future<void> getShippingRequests() async {
    final response = await _getShippingRequestsUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
            status: RequestHistoryStates.error, failure: failure)),
        (response) => emit(state.copyWith(
            shippingRequests: response,
            status: RequestHistoryStates.initState)));
  }
}
