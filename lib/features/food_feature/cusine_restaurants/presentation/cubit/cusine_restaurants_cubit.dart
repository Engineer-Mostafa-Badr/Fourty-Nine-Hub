import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../restaurants_list/domain/entities/restaurant.dart';
import '../../../restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';

part 'cusine_restaurants_state.dart';

class CusineRestaurantsCubit extends Cubit<CusineRestaurantsState> {
  final GetNearByRestaurantsUseCase _getNearByRestaurantsUseCase;

  CusineRestaurantsCubit(this._getNearByRestaurantsUseCase)
      : super(const CusineRestaurantsState());

  Future<void> getNearByRestaurants() async {
    final response =
        await _getNearByRestaurantsUseCase.call(LocationParams(lat: 0, lng: 0));
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(
          failure: failure, status: CusineRestaurantsStates.error));
    },
        (data) => emit(state.copyWith(
            cusineRestaurants: data,
            status: CusineRestaurantsStates.initState)));
  }

  void loadData() async {
    await getNearByRestaurants();
  }
}
