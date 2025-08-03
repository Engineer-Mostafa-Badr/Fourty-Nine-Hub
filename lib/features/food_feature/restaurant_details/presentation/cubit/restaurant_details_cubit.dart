import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/messages/messages.dart';
import '../../domain/usecases/add_food_usecase.dart';
import '../../domain/usecases/change_quantity_usecase.dart';
import '../../domain/usecases/delete_cart_usecase.dart';
import '../../domain/usecases/delete_food_from_cart_usecase.dart';
import '../../domain/usecases/delete_food_usecase.dart';
import '../../../restaurants_list/domain/entities/restaurant_mneu.dart';
import '../../../restaurants_list/domain/usecases/toggle_restaurant_favourite_use_case.dart';

import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/error/failure.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/selected_meal_model.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/get_meals_usecase.dart';
import '../../domain/usecases/get_restaurant_details_usecase.dart';

part 'restaurant_details_state.dart';

class RestaurantDetailsCubit extends Cubit<RestaurantDetailsState> {
  final ApiConsumer apiConsumer;

  final AddToCartUseCase _addToCartUseCase;
  final DeleteFoodUseCase _deleteFoodUseCase;
  final AddFoodUseCase _addFoodUseCase;
  final ToggleRestaurantFavouriteUseCase _toggleRestaurantFavouriteUseCase;
  final GetMealsUseCase _getMealsUseCase;
  final GetRestaurantDetailsUseCase _getRestaurantDetailsUseCase;
  final ChangeQuantityUseCase _changeQuantityUseCase;
  final DeleteCartUseCase _deleteCartUseCase;
  final DeleteFoodFromCartUseCase _deleteFoodFromCartUseCase;

  RestaurantDetailsCubit(
      this._addToCartUseCase,
      this._getMealsUseCase,
      this._getRestaurantDetailsUseCase,
      this.apiConsumer,
      this._deleteFoodUseCase,
      this._addFoodUseCase,
      this._changeQuantityUseCase,
      this._deleteCartUseCase,
      this._deleteFoodFromCartUseCase,
      this._toggleRestaurantFavouriteUseCase)
      : super(const RestaurantDetailsState());

  loadInitialData({required String id}) async {
    await getMeals(id: id);
  }

  void loadData({required String id}) async {
    emit(state.copyWith(status: RestaurantDetailsStates.loading));
    menu.clear();
    currentPage = 1;
    hasMoreData = true;
    await getMeals(id: id);
  }

  bool isLoadingMore = false;
  bool isFav = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;
  List<RestaurantMenu> menu = [];

  Future<void> getMeals({
    required String id,
  }) async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getMealsUseCase(
        GetMealsParams(restaurantId: id, page: currentPage, limit: pageSize));

    response.fold(
      (failure) => emit(state.copyWith(
          failure: failure, status: RestaurantDetailsStates.error)),
      (data) {
        menu.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(
            status: RestaurantDetailsStates.initState, meals: data));
      },
    );
  }

  addToCart(context,
      {required String restaurantId,
      required String foodId,
      required int quantity}) async {
    bool result = false;
    emit(state.copyWith(status: RestaurantDetailsStates.addCart));
    final response = await _addToCartUseCase(
        restaurantId: restaurantId, foodId: foodId, quantity: quantity);
    response.fold((l) {
      showErrorMessage(context, getFailureMessage(l, context));
      emit(state.copyWith(failure: l, status: RestaurantDetailsStates.error));
    }, (data) {
      result = true;
      showCustomSnackBar(
        context,
        // "Cart Update Successfully",
        LocaleKeys.cartUpdated.localize,
        Icon(Icons.done_all_outlined, color: AppColors.CHECK_MARK_COLOR),
      );
      emit(state.copyWith(status: RestaurantDetailsStates.success));
    });
    return result;
  }

  decrement(context,
      {required String restaurantId,
      required String foodId,
      required int quantity}) async {
    bool result = false;
    emit(state.copyWith(status: RestaurantDetailsStates.addCart));
    final response = await _changeQuantityUseCase(ChangeQuantityParams(
        restaurantId: restaurantId, foodId: foodId, quantity: quantity));
    response.fold((l) {
      showErrorMessage(context, getFailureMessage(l, context));
      emit(state.copyWith(failure: l, status: RestaurantDetailsStates.error));
    }, (data) {
      result = true;
      emit(state.copyWith(status: RestaurantDetailsStates.success));
    });
    return result;
  }

  void removeFromCart({required int index}) {
    emit(state.copyWith(status: RestaurantDetailsStates.addCart));
    List<SelectedMealModel> selectedMeals = state.selectedMeals ?? [];
    selectedMeals.removeAt(index);
    emit(state.copyWith(
        status: RestaurantDetailsStates.success, selectedMeals: selectedMeals));
  }

  Future<bool> removeItem(
      {required String foodId, required BuildContext context}) async {
    final res = await _deleteFoodUseCase(foodId);
    bool result = false;
    res.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(LocaleKeys.failedDeleteItem.localize)),
        );
      },
      (r) async {
        result = true;
      },
    );

    return result;
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

  Future<void> fetchCart({bool? first = false}) async {
    if (first == true) {
      emit(state.copyWith(status: RestaurantDetailsStates.loading, cart: null));
    }

    const url = 'https://49backend.com/api/v1/food/getCart';

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
    final response = await _deleteFoodFromCartUseCase(
        DeleteFoodFromCartParams(restaurantId: restaurantId, foodId: foodId));

    response.fold(
      (failure) {
        emit(state.copyWith(
          status: RestaurantDetailsStates.error,
          failure: failure,
        ));
        showErrorMessage(context, getFailureMessage(failure, context));
      },
      (data) {
        emit(state.copyWith(
          status: RestaurantDetailsStates.initState,
        ));
      },
    );
  }

  Future<void> createPremiumOrder(
    context, {
    required String cartId,
    required String address,
    required String phone,
  }) async {
    emit(state.copyWith(status: RestaurantDetailsStates.loading));

    const url = 'https://49backend.com/api/v1/food/make-order-premium';

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
        log('Failed to create order:---------- $failure');

        showErrorMessage(context, getFailureMessage(failure, context));
      },
      (data) async {
        // Handle the successful response
        // For example, parse the order data and emit a success state
        final orderData =
            data['data']; // Adjust based on your API response structure
        // final order = Order.fromJson(orderData);
        log("${data['message']}ssssssasssssssssssssssssssss");
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
        //               ,
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

    const url = 'https://49backend.com/api/v1/food/make-order';

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
        log('Failed to create order:---------- $failure');

        showErrorMessage(context, getFailureMessage(failure, context));
      },
      (data) async {
        // Handle the successful response
        // For example, parse the order data and emit a success state
        final orderData =
            data['data']; // Adjust based on your API response structure
        // final order = Order.fromJson(orderData);
        log("${data['message']}    const url = 'https://49backend.com/api/v1/food/make-order';");
        Navigator.pop(context);
        showSuccessMessage(context,LocaleKeys.orderCreatedSuccessfully.localize);
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
        //               ,
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

  Future<bool> toggleFavoriteRestaurant(String id, BuildContext context) async {
    print("ggggg");
    final response = await _toggleRestaurantFavouriteUseCase(id);
    bool result = false;
    response.fold((failure) {
      showCustomSnackBar(
        context,
        LocaleKeys.failedUpdateFavorites.localize,
        Icon(Icons.warning_amber_rounded, color: AppColors.PRIMARY_COLOR_DARK),
      );
    }, (data) {
      showCustomSnackBar(
        context,
        LocaleKeys.favoritesUpdated.localize,
        Icon(Icons.done_all_outlined, color: AppColors.CHECK_MARK_COLOR),
      );
      result = data;
    });
    return result;
  }
}

showCustomSnackBar(BuildContext context, String message, Icon icon) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating, // اجعل الـSnackbar عائمًا
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Row(
        spacing: 10,
        children: [
          icon,
          16.verticalSpace,
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.getTextColor(context),
                fontWeight: FontWeight.w500,
                fontSize: 30.sp,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
