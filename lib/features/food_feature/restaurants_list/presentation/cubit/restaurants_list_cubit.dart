import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';


import '../../data/models/food_category_model.dart';
import '../../data/models/restaurant_model.dart';
import '../../domain/usecases/get_food_categories_usecase.dart';
import '../../domain/usecases/get_nearby_restaurants_usecase.dart';
import '../../domain/usecases/get_trending_restaurants_usecase.dart';

part 'restaurants_list_state.dart';

class RestaurantsListCubit extends Cubit<RestaurantsListState> {
  final GetFoodCategoriesUseCase _getFoodCategoriesUseCase;
  final GetNearByRestaurantsUseCase _getNearByRestaurantsUseCase;
  final GetTrendingRestaurantsUseCase _getTrendingRestaurantsUseCase;
  RestaurantsListCubit(
    this._getFoodCategoriesUseCase,
    this._getNearByRestaurantsUseCase,
    this._getTrendingRestaurantsUseCase,
  ) : super(const RestaurantsListState());

  void loadData() async {
    await getNearByRestaurants();
    await getTrendingRestaurants();
    await getSubCategories();
  }

  Future<void> getNearByRestaurants() async {
    final response =
        await _getNearByRestaurantsUseCase.call(LocationParams(lat: 0, lng: 0));
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantsListStates.error)),
        (data) => emit(state.copyWith(
            nearByRestaurants: data, status: RestaurantsListStates.initState)));
  }

  Future<void> getTrendingRestaurants() async {
    final response = await _getTrendingRestaurantsUseCase
        .call(LocationParams(lat: 0, lng: 0));
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantsListStates.error)), (data) {
      emit(state.copyWith(
          trendingRestaurants: data, status: RestaurantsListStates.initState));
    });
  }

  Future<void> getSubCategories() async {
    final response = await _getFoodCategoriesUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantsListStates.error)),
        (data) => emit(state.copyWith(
            categories: data, status: RestaurantsListStates.initState)));
  }
}
