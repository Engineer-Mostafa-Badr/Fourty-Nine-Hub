import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';

import '../../../../../core/error/failure.dart';

import '../../../restaurants_list/domain/entities/restaurant.dart';
import '../../../restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';

part 'cusine_restaurants_state.dart';

class CuisineRestaurantsCubit extends Cubit<CuisineRestaurantsState> {
  final GetNearByRestaurantsUseCase _getNearByRestaurantsUseCase;

  CuisineRestaurantsCubit(this._getNearByRestaurantsUseCase)
      : super(const CuisineRestaurantsState());

  Future<void> getNearByRestaurants() async {
    final response =
        await _getNearByRestaurantsUseCase.call(LocationParams(lat: 0, lng: 0));
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(
          failure: failure, status: CuisineRestaurantsStates.error));
    },
        (data) => emit(state.copyWith(
            cusineRestaurants: data,
            status: CuisineRestaurantsStates.initState)));
  }

  void loadData() async {
    await getNearByRestaurants();
  }
}
