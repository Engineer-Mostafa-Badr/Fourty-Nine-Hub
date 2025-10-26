part of 'cusine_restaurants_cubit.dart';
enum CuisineRestaurantsStates { initState, loading, error }

extension CuisineRestaurantsStateX on CuisineRestaurantsState {
  bool get isInitial => status == CuisineRestaurantsStates.initState;
  bool get isLoading => status == CuisineRestaurantsStates.loading;
  bool get isError => status == CuisineRestaurantsStates.error;
}

@immutable
class CuisineRestaurantsState {
  final CuisineRestaurantsStates? status;
  final Failure? failure;
  final List<GetAllRestaurantEntity>? cusineRestaurants;

  const CuisineRestaurantsState({
    this.status,
    this.failure,
    this.cusineRestaurants,
  });
  CuisineRestaurantsState copyWith({
    CuisineRestaurantsStates? status,
    Failure? failure,
    List<GetAllRestaurantEntity>? cusineRestaurants,
  }) {
    return CuisineRestaurantsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      cusineRestaurants: cusineRestaurants ?? this.cusineRestaurants,
    );
  }
}
