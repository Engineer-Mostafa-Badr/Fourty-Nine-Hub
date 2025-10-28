part of 'restaurant_details_cubit.dart';

enum RestaurantDetailsStates { loading, error, success, initState, addCart }

extension RestaurantDetailsStateX on RestaurantDetailsState {
  bool get isInitial => status == RestaurantDetailsStates.initState;
  bool get isSuccess => status == RestaurantDetailsStates.success;
  bool get isAddToCart => status == RestaurantDetailsStates.addCart;

  bool get isLoading => status == RestaurantDetailsStates.loading;

  bool get isError => status == RestaurantDetailsStates.error;
}

class RestaurantDetailsState {
  final RestaurantDetailsStates? status;
  final Failure? failure;
  final List<RestaurantMenu>? meals;
  // final Restaurant? restaurant;
  final Cart? cart;
  final List<SelectedMealModel>? selectedMeals;

  const RestaurantDetailsState(
      {this.status,
      this.cart,
      this.failure,
      this.meals,
      // this.restaurant,
      this.selectedMeals});

  RestaurantDetailsState copyWith({
    RestaurantDetailsStates? status,
    Failure? failure,
    List<RestaurantMenu>? meals,
    // Restaurant? restaurant,
    Object? cart = _undefined,
    List<SelectedMealModel>? selectedMeals,
  }) {
    return RestaurantDetailsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      meals: meals ?? this.meals,
      // restaurant: restaurant ?? this.restaurant,
      cart: cart == _undefined ? this.cart : cart as Cart?,
      selectedMeals: selectedMeals ?? this.selectedMeals,
    );
  }
}

// Sentinel value for copyWith
const Object _undefined = Object();
