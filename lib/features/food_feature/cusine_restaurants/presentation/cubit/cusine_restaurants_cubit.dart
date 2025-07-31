import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';

import '../../../../../core/error/failure.dart';
import '../../../restaurants_list/domain/entities/restaurant.dart';
import '../../../restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';

part 'cusine_restaurants_state.dart';

class CusineRestaurantsCubit extends Cubit<CusineRestaurantsState> {
  final GetNearByRestaurantsUseCase _getNearByRestaurantsUseCase;

  CusineRestaurantsCubit(this._getNearByRestaurantsUseCase)
      : super(const CusineRestaurantsState());

  void loadData() async {
    await getNearByRestaurants();
  }

  Future<void> getNearByRestaurants() async {
    final response =
        await _getNearByRestaurantsUseCase.call(LocationParams(lat: 0, lng: 0));
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: CusineRestaurantsStates.error)),
        (data) => emit(state.copyWith(
            cusineRestaurants: data,
            status: CusineRestaurantsStates.initState)));
  }
}
