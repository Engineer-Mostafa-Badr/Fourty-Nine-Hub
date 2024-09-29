part of 'restaurant_details_cubit.dart';

enum RestaurantDetailsStates { loading, error, initState }

extension RestaurantDetailsStateX on RestaurantDetailsState {
  bool get isInitial => status == RestaurantDetailsStates.initState;

  bool get isLoading => status == RestaurantDetailsStates.loading;

  bool get isError => status == RestaurantDetailsStates.error;
}

class RestaurantDetailsState {
  final RestaurantDetailsStates? status;
  final Failure? failure;
  final List<RestaurantMenu>? meals;
  final Restaurant? restaurant;
  final Cart? cart;
  final List<SelectedMealModel>? selectedMeals;

  const RestaurantDetailsState(
      {this.status,
      this.cart,
      this.failure,
      this.meals,
      this.restaurant,
      this.selectedMeals});

  RestaurantDetailsState copyWith({
    RestaurantDetailsStates? status,
    Failure? failure,
    List<RestaurantMenu>? meals,
    Restaurant? restaurant,
    Cart? cart,
    List<SelectedMealModel>? selectedMeals,
  }) {
    return RestaurantDetailsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      meals: meals ?? this.meals,
      restaurant: restaurant ?? this.restaurant,
      cart: cart ?? this.cart,
      selectedMeals: selectedMeals ?? this.selectedMeals,
    );
  }
}
