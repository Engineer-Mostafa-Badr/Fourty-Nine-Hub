import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';

import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/error/failure.dart';

import '../../../../../core/utils/shared_pref.dart';
import '../../../../../res/style/app_colors.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/selected_meal_model.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/get_meals_usecase.dart';
import '../../domain/usecases/get_restaurant_details_usecase.dart';
import 'package:http/http.dart' as http;

part 'restaurant_details_state.dart';

class RestaurantDetailsCubit extends Cubit<RestaurantDetailsState> {
  final ApiConsumer apiConsumer;

  final AddToCartUseCase _addToCartUseCase;
  final GetMealsUseCase _getMealsUseCase;
  final GetRestaurantDetailsUseCase _getRestaurantDetailsUseCase;

  RestaurantDetailsCubit(this._addToCartUseCase, this._getMealsUseCase,
      this._getRestaurantDetailsUseCase, this.apiConsumer)
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
      {required String restaurantId,
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
    // addToCart(
    //     restaurantId: meal.restaurantId ?? "",
    //     foodId: meal.id ?? "",
    //     quantity: qty.toString());
    log("added: ${state.selectedMeals?.length}");
  }

  void removeMeal({required RestaurantMenu meal}) {
    List<SelectedMealModel> selectedMeals = state.selectedMeals ?? [];
    selectedMeals.removeWhere((element) => element.meal == meal);
    emit(state.copyWith(selectedMeals: selectedMeals));
    log("removed: ${state.selectedMeals?.length}");
  }

  Future<void> fetchCart() async {
    emit(state.copyWith(status: RestaurantDetailsStates.loading, cart: null));

    const url = 'https://49dev.com/api/v1/food/getCart';

    try {
      final response = await apiConsumer.get(url);

      log('Failed;;;; ${response.toString()}');

      response.fold(
        (failure) {
          emit(state.copyWith(status: RestaurantDetailsStates.error));
          log('Failed to load cart: ${failure.toString()}');
        },
        (data) {
          final cartData = data; // Adjust based on your API response structure
          final cart = Cart.fromJson(cartData);
          log("${cart.subTotal}------------------------------------");
          emit(state.copyWith(
              cart: cart, status: RestaurantDetailsStates.initState));
        },
      );
    } catch (e) {
      emit(state.copyWith(status: RestaurantDetailsStates.error));
      log('An unexpected error occurred: $e');
    }
  }

  Future<void> deleteFromCart(
    context, {
    required String restaurantId,
    required String foodId,
  }) async {
    emit(state.copyWith(status: RestaurantDetailsStates.loading));

    const url = 'https://49dev.com/api/v1/food/deleteFromCart';

    final data = {
      "restaurantId": restaurantId,
      "foodId": foodId,
    };

    try {
      final response = await apiConsumer.delete(
        url,
        data: data,
      );

      response.fold(
        (failure) {
          emit(state.copyWith(
            status: RestaurantDetailsStates.error,
            failure: failure,
          ));
          showErrorMessage(context, getFailureMessage(failure, context));
        },
        (data) {
          // Optionally update the cart items in the state
          emit(state.copyWith(
            status: RestaurantDetailsStates.initState,
            // message: data['message'] ?? 'Item deleted successfully',
          ));
          showSuccessMessage(context, data['data']);
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: RestaurantDetailsStates.error,
      ));
    }
  }

  Future<void> createPremiumOrder(
    context, {
    required String cartId,
    required String address,
    required String phone,
  }) async {
    emit(state.copyWith(status: RestaurantDetailsStates.loading));

    const url = 'https://49dev.com/api/v1/food/make-order-premium';

    final data = {
      "cartId": cartId,
      // "address": address,
      "phone": phone,
    };

    final response = await apiConsumer.post(
      url,
      data: data,
    );

    response.fold(
      (failure) {
        emit(state.copyWith(status: RestaurantDetailsStates.error));
        log('Failed to create order:---------- ${failure}');

        showErrorMessage(context, getFailureMessage(failure, context));
      },
      (data) async {
        // Handle the successful response
        // For example, parse the order data and emit a success state
        final orderData =
            data['data']; // Adjust based on your API response structure
        // final order = Order.fromJson(orderData);
        log(data['message'].toString() + "ssssssasssssssssssssssssssss");
        Navigator.pop(context);
        showSuccessMessage(context, data['message']);
        // WidgetsBinding.instance.addPostFrameCallback(
        //   (_) => ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       content: Row(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Expanded(
        //             child: Text(
        //               data['message'],
        //               textScaleFactor: 1.0,
        //               style: const TextStyle(
        //                 fontWeight: FontWeight.w500,
        //                 color: AppColors.QUANTITY_COLOR,
        //               ),
        //             ),
        //           ),
        //           const SizedBox(width: 10),
        //           const Icon(
        //             Icons.check_circle_outline,
        //             color: AppColors.WHATS_APP_COLOR,
        //           ),
        //         ],
        //       ),
        //       backgroundColor: Colors.white,
        //       behavior: SnackBarBehavior.floating,
        //       padding: EdgeInsets.symmetric(
        //         vertical: 20.h,
        //         horizontal: 20,
        //       ),
        //       margin: const EdgeInsets.only(
        //         bottom: 25,
        //         right: 20,
        //         left: 20,
        //       ),
        //     ),
        //   ),
        // );

        emit(state.copyWith(status: RestaurantDetailsStates.initState));
      },
    );
  }

  Future<void> createNormalOrder(
    context, {
    required String cartId,
    required String address,
    required String phone,
  }) async {
    emit(state.copyWith(status: RestaurantDetailsStates.loading));

    const url = 'https://49dev.com/api/v1/food/make-order';

    final data = {
      "cartId": cartId,
      // "address": address,
      "phone": phone,
    };

    final response = await apiConsumer.post(
      url,
      data: data,
    );

    response.fold(
      (failure) {
        emit(state.copyWith(status: RestaurantDetailsStates.error));
        log('Failed to create order:---------- ${failure}');

        showErrorMessage(context, getFailureMessage(failure, context));
      },
      (data) async {
        // Handle the successful response
        // For example, parse the order data and emit a success state
        final orderData =
            data['data']; // Adjust based on your API response structure
        // final order = Order.fromJson(orderData);
        log(data['message'].toString() +
            "    const url = 'https://49dev.com/api/v1/food/make-order';");
        Navigator.pop(context);
        showSuccessMessage(context, data['message']);
        // WidgetsBinding.instance.addPostFrameCallback(
        //   (_) => ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       content: Row(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Expanded(
        //             child: Text(
        //               data['message'],
        //               textScaleFactor: 1.0,
        //               style: const TextStyle(
        //                 fontWeight: FontWeight.w500,
        //                 color: AppColors.QUANTITY_COLOR,
        //               ),
        //             ),
        //           ),
        //           const SizedBox(width: 10),
        //           const Icon(
        //             Icons.check_circle_outline,
        //             color: AppColors.WHATS_APP_COLOR,
        //           ),
        //         ],
        //       ),
        //       backgroundColor: Colors.white,
        //       behavior: SnackBarBehavior.floating,
        //       padding: EdgeInsets.symmetric(
        //         vertical: 20.h,
        //         horizontal: 20,
        //       ),
        //       margin: const EdgeInsets.only(
        //         bottom: 25,
        //         right: 20,
        //         left: 20,
        //       ),
        //     ),
        //   ),
        // );

        emit(state.copyWith(status: RestaurantDetailsStates.initState));
      },
    );
  }

  Future<void> addRestaurantToFavorites(context, String restaurantId) async {
    emit(state.copyWith(status: RestaurantDetailsStates.loading));

    // Construct the full URL with the restaurantId
    final url =
        'https://49dev.com/api/v1/food/favorite-restaurant/$restaurantId';

    final response = await apiConsumer.post(url);

    response.fold(
      (failure) {
        // Handle the failure case
        emit(state.copyWith(
          status: RestaurantDetailsStates.error,
          failure: failure,
        ));
      },
      (data) {
        // Handle the success case
        emit(state.copyWith(
          status: RestaurantDetailsStates.initState,
          // message: data['message'] ?? 'Restaurant added to favorites',
        ));
        // showSuccessMessage(context, data['message'] ?? 'Restaurant added to favorites');
      },
    );
  }
}
