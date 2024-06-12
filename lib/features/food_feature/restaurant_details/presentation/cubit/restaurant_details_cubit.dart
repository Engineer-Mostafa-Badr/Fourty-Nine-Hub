import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failure.dart';
import '../../../restaurants_list/data/models/restaurant_model.dart';
import '../../data/models/meal_model.dart';
import '../../data/models/selected_meal_model.dart';
import '../../domain/usecases/get_meals_usecase.dart';
import '../../domain/usecases/get_restaurant_details_usecase.dart';

part 'restaurant_details_state.dart';

class RestaurantDetailsCubit extends Cubit<RestaurantDetailsState> {
  final GetMealsUseCase _getMealsUseCase;
  final GetRestaurantDetailsUseCase _getRestaurantDetailsUseCase;
  RestaurantDetailsCubit(
      this._getMealsUseCase, this._getRestaurantDetailsUseCase)
      : super(const RestaurantDetailsState());

  void loadData() async {
    await getRestaurantDetails();
    await getMeals();
  }

  Future<void> getRestaurantDetails() async {
    final response = await _getRestaurantDetailsUseCase.call(0);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantDetailsStates.error)),
        (data) => emit(state.copyWith(
            status: RestaurantDetailsStates.initState, restaurant: data)));
  }

  Future<void> getMeals() async {
    final response = await _getMealsUseCase.call(0);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantDetailsStates.error)),
        (data) => emit(state.copyWith(
            status: RestaurantDetailsStates.initState, meals: data)));
  }

  void addToCart(
      {required BuildContext context,
      required SelectedMealModel selectedMeal}) {
    List<SelectedMealModel> selectedMeals = state.selectedMeals ?? [];
    selectedMeals.add(selectedMeal);
    emit(state.copyWith(selectedMeals: selectedMeals));
    Navigator.pop(context);
  }

  void removeFromCart({required int index}) {
    List<SelectedMealModel> selectedMeals = state.selectedMeals ?? [];
    selectedMeals.removeAt(index);
    emit(state.copyWith(selectedMeals: selectedMeals));
  }
}
