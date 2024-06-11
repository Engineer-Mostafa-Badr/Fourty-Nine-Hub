part of 'restaurants_list_cubit.dart';

enum RestaurantsListStates { initState, loading, error }

extension RestaurantsListStateX on RestaurantsListState {
  bool get isInitial => status == RestaurantsListStates.initState;
  bool get isLoading => status == RestaurantsListStates.loading;
  bool get isError => status == RestaurantsListStates.error;
}

@immutable
class RestaurantsListState {
  final RestaurantsListStates? status;
  final Failure? failure;
  final List<RestaurantModel>? nearByRestaurants;
  final List<RestaurantModel>? trendingRestaurants;
  final List<FoodCategoryModel>? categories;
  const RestaurantsListState({
    this.status,
    this.failure,
    this.nearByRestaurants,
    this.trendingRestaurants,
    this.categories,
  });
  RestaurantsListState copyWith({
    RestaurantsListStates? status,
    Failure? failure,
    List<RestaurantModel>? nearByRestaurants,
    List<RestaurantModel>? trendingRestaurants,
    List<FoodCategoryModel>? categories,
  }) {
    return RestaurantsListState(
      status: status ?? this.status,
      failure: failure?? this.failure,
      nearByRestaurants: nearByRestaurants ?? this.nearByRestaurants,
      trendingRestaurants: trendingRestaurants ?? this.trendingRestaurants,
      categories: categories ?? this.categories,
    );
  }
}
