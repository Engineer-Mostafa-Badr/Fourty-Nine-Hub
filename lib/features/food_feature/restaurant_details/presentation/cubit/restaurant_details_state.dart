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
  final List<MealEntity>? meals;
  final RestaurantEntity? restaurant;
  final List<SelectedMealModel>? selectedMeals;
  const RestaurantDetailsState(
      {this.status,
      this.failure,
      this.meals,
      this.restaurant,
      this.selectedMeals});

  RestaurantDetailsState copyWith({
    RestaurantDetailsStates? status,
    Failure? failure,
    List<MealEntity>? meals,
    RestaurantEntity? restaurant,
    List<SelectedMealModel>? selectedMeals,
  }) {
    return RestaurantDetailsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      meals: meals ?? this.meals,
      restaurant: restaurant ?? this.restaurant,
      selectedMeals: selectedMeals ?? this.selectedMeals,
    );
  }
}
