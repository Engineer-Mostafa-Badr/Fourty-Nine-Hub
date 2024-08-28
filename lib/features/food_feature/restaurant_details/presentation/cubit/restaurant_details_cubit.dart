import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';

import '../../../../../core/error/failure.dart';

import '../../data/models/selected_meal_model.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/get_meals_usecase.dart';
import '../../domain/usecases/get_restaurant_details_usecase.dart';

part 'restaurant_details_state.dart';

class RestaurantDetailsCubit extends Cubit<RestaurantDetailsState> {
  final AddToCartUseCase _addToCartUseCase;
  final GetMealsUseCase _getMealsUseCase;
  final GetRestaurantDetailsUseCase _getRestaurantDetailsUseCase;
  RestaurantDetailsCubit(this._addToCartUseCase, this._getMealsUseCase,
      this._getRestaurantDetailsUseCase)
      : super(const RestaurantDetailsState());

  void loadData({required String id}) async {
    await getRestaurantDetails(id: id);
    await getMeals(id: id);
  }

  Future<void> getRestaurantDetails({required String id}) async {
    final response = await _getRestaurantDetailsUseCase(id);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantDetailsStates.error)),
        (data) => emit(state.copyWith(
            status: RestaurantDetailsStates.initState, restaurant: data)));
  }

  Future<void> getMeals({required String id}) async {
    final response = await _getMealsUseCase(id);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantDetailsStates.error)),
        (data) => emit(state.copyWith(
            status: RestaurantDetailsStates.initState, meals: data)));
  }

  addToCart(
      {required BuildContext context,
      required String restaurantId,
      required String foodId,
      required String quantity}) async {
    final response = await _addToCartUseCase(
        restaurantId: restaurantId, foodId: foodId, quantity: quantity);
    response.fold(
        (l) => emit(
            state.copyWith(failure: l, status: RestaurantDetailsStates.error)),
        (data) {
      if (data) {}
    });
  }

  void removeFromCart({required int index}) {
    List<SelectedMealModel> selectedMeals = state.selectedMeals ?? [];
    selectedMeals.removeAt(index);
    emit(state.copyWith(selectedMeals: selectedMeals));
  }

  void selectMeal({required RestaurantMenu meal, required int qty}) {
    List<SelectedMealModel> selectedMeals = state.selectedMeals ?? [];
    selectedMeals.add(
      SelectedMealModel(
        qty: qty,
        price: meal.price ?? 0.0,
        meal: meal,
        restaurantId: meal.restaurantId ?? "",
        selectedAddOn: [],
        selectedVariations: [],
      ),
    );
    emit(state.copyWith(selectedMeals: selectedMeals));

    log("added: ${state.selectedMeals?.length}");
  }

  void removeMeal({required RestaurantMenu meal}) {
    List<SelectedMealModel> selectedMeals = state.selectedMeals ?? [];
    selectedMeals.removeWhere((element) => element.meal == meal);
    emit(state.copyWith(selectedMeals: selectedMeals));
    log("removed: ${state.selectedMeals?.length}");
  }
}
