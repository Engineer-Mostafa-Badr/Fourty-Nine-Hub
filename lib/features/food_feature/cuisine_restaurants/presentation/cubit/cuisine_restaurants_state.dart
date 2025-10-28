part of 'cuisine_restaurants_cubit.dart';

enum CuisineRestaurantsStates { initState, loading, error }

extension CuisineRestaurantsStateX on CuisineRestaurantsState {
  bool get isInitial => status == CuisineRestaurantsStates.initState;
  bool get isLoading => status == CuisineRestaurantsStates.loading;
  bool get isError => status == CuisineRestaurantsStates.error;
}

class CuisineRestaurantsState {
  final CuisineRestaurantsStates? status;
  final Failure? failure;
  final List<GetAllRestaurantEntity>? cuisineRestaurants;

  const CuisineRestaurantsState({
    this.status,
    this.failure,
    this.cuisineRestaurants,
  });
  CuisineRestaurantsState copyWith({
    CuisineRestaurantsStates? status,
    Failure? failure,
    List<GetAllRestaurantEntity>? cuisineRestaurants,
  }) {
    return CuisineRestaurantsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      cuisineRestaurants: cuisineRestaurants ?? this.cuisineRestaurants,
    );
  }
}
