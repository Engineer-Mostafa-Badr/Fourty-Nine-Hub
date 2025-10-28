import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../restaurants_list/domain/entities/restaurant_menu.dart';
import '../../../restaurants_list/domain/usecases/toggle_restaurant_favourite_use_case.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/selected_meal_model.dart';
import '../../domain/repositories/restaurant_details_repo.dart';
import '../../domain/usecases/add_food_usecase.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/change_quantity_usecase.dart';
import '../../domain/usecases/delete_cart_usecase.dart';
import '../../domain/usecases/delete_food_from_cart_usecase.dart';
import '../../domain/usecases/delete_food_usecase.dart';
import '../../domain/usecases/get_meals_usecase.dart';
import '../../domain/usecases/get_restaurant_details_usecase.dart';

part 'restaurant_details_state.dart';

class RestaurantDetailsCubit extends Cubit<RestaurantDetailsState> {
  final RestaurantDetailsRepo _repository;

  final AddToCartUseCase _addToCartUseCase;
  final DeleteFoodUseCase _deleteFoodUseCase;
  final AddFoodUseCase _addFoodUseCase;
  final ToggleRestaurantFavouriteUseCase _toggleRestaurantFavouriteUseCase;
  final GetMealsUseCase _getMealsUseCase;
  final GetRestaurantDetailsUseCase _getRestaurantDetailsUseCase;
  final ChangeQuantityUseCase _changeQuantityUseCase;
  final DeleteCartUseCase _deleteCartUseCase;
  final DeleteFoodFromCartUseCase _deleteFoodFromCartUseCase;

  bool isLoadingMore = false;

  bool isFav = false;

  bool hasMoreData = true;

  int currentPage = 1;
  int pageSize = 10;
  List<RestaurantMenu> menu = [];
  RestaurantDetailsCubit(
      this._addToCartUseCase,
      this._getMealsUseCase,
      this._getRestaurantDetailsUseCase,
      this._repository,
      this._deleteFoodUseCase,
      this._addFoodUseCase,
      this._changeQuantityUseCase,
      this._deleteCartUseCase,
      this._deleteFoodFromCartUseCase,
      this._toggleRestaurantFavouriteUseCase)
      : super(const RestaurantDetailsState());
  addToCart(context,
      {required String restaurantId,
      required String foodId,
      required int quantity}) async {
    bool result = false;
    emit(state.copyWith(status: RestaurantDetailsStates.addCart));
    final response = await _addToCartUseCase(
        restaurantId: restaurantId, foodId: foodId, quantity: quantity);
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
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

  Future<void> createNormalOrder(
    context, {
    required String cartId,
    required String address,
    required String phone,
  }) async {
    emit(state.copyWith(status: RestaurantDetailsStates.loading));

    final response = await _repository.createNormalOrder(
      cartId: cartId,
      phone: phone,
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(status: RestaurantDetailsStates.error));
        log('Failed to create order:---------- $failure');

        showErrorMessage(context, getFailureMessage(failure, context));
      },
      (data) async {
        final orderData = data['data'];
        log("${data['message']} - Order created successfully");
        Navigator.pop(context);
        showSuccessMessage(
            context, LocaleKeys.orderCreatedSuccessfully.localize);

        emit(state.copyWith(status: RestaurantDetailsStates.initState));
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

    final response = await _repository.createPremiumOrder(
      cartId: cartId,
      phone: phone,
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(status: RestaurantDetailsStates.error));
        log('Failed to create order:---------- $failure');

        showErrorMessage(context, getFailureMessage(failure, context));
      },
      (data) async {
        final orderData = data['data'];
        log("${data['message']} - Premium order created");
        Navigator.pop(context);
        showSuccessMessage(context, data['message']);

        emit(state.copyWith(status: RestaurantDetailsStates.initState));
      },
    );
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
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      showErrorMessage(context, getFailureMessage(l, context));
      emit(state.copyWith(failure: l, status: RestaurantDetailsStates.error));
    }, (data) {
      result = true;
      emit(state.copyWith(status: RestaurantDetailsStates.success));
    });
    return result;
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
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
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

  Future<void> fetchCart({bool? first = false}) async {
    if (first == true) {
      emit(state.copyWith(status: RestaurantDetailsStates.loading, cart: null));
    }

    try {
      final response = await _repository.getCart();

      log('Cart response: ${response.toString()}');

      response.fold(
        (failure) {
          // Check if cart is empty (cart not found is a normal state)
          if (failure is ServerFailure &&
              (failure.message.toLowerCase().contains('cart not found'))) {
            // Cart is empty, emit empty cart state
            log('Cart is empty (not found)');
            emit(state.copyWith(
              cart: null,
              status: RestaurantDetailsStates.initState,
            ));
          } else {
            // Real error, show message
            var currentContext =
                AppPages.router.configuration.navigatorKey.currentContext!;
            showErrorMessage(
                currentContext, getFailureMessage(failure, currentContext));
            emit(state.copyWith(status: RestaurantDetailsStates.error));

            log('Failed to load cart: ${failure.toString()}');
          }
        },
        (data) {
          final cart = Cart.fromJson(data);
          log("Cart subtotal: ${cart.subTotal}");

          emit(state.copyWith(
              cart: cart, status: RestaurantDetailsStates.initState));
        },
      );
    } catch (e) {
      emit(state.copyWith(status: RestaurantDetailsStates.error));
      log('An unexpected error occurred: $e');
    }
  }

  Future<void> getMeals({
    required String id,
  }) async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getMealsUseCase(
        GetMealsParams(restaurantId: id, page: currentPage, limit: pageSize));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: RestaurantDetailsStates.error));
      },
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

  void loadData({required String id}) async {
    emit(state.copyWith(status: RestaurantDetailsStates.loading));
    menu.clear();
    currentPage = 1;
    hasMoreData = true;
    await getMeals(id: id);
  }

  loadInitialData({required String id}) async {
    await getMeals(id: id);
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
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
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

  void removeMeal({required RestaurantMenu meal}) {
    List<SelectedMealModel> selectedMeals = state.selectedMeals ?? [];
    selectedMeals.removeWhere((element) => element.meal == meal);
    emit(state.copyWith(selectedMeals: selectedMeals));
    log("removed: ${state.selectedMeals?.length}");
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

  Future<bool> toggleFavoriteRestaurant(String id, BuildContext context) async {
    print("ggggg");
    final response = await _toggleRestaurantFavouriteUseCase(id);
    bool result = false;
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
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
