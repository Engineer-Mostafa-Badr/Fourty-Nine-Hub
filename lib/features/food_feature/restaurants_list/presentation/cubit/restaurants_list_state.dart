part of 'restaurants_list_cubit.dart';

enum RestaurantsListStates { initState, loading, error }

extension RestaurantsListStateX on RestaurantsListState {
  bool get isInitial => status == RestaurantsListStates.initState;
  bool get isLoading => status == RestaurantsListStates.loading;
  bool get isError => status == RestaurantsListStates.error;
}

@immutable
class RestaurantsListState {
  final RestaurantsListStates status;
  final Failure? failure;
  final List<RestaurantEntity>? nearByRestaurants;
  final Banner? banner;
  final int? numOfRestaurants;
  final List<RestaurantEntity>? trendingRestaurants;
  final List<SubCategoryEntity>? categories;
  const RestaurantsListState({
    this.status = RestaurantsListStates.loading,
    this.failure,
    this.numOfRestaurants,
    this.nearByRestaurants,
    this.banner,
    this.trendingRestaurants,
    this.categories,
  });
  RestaurantsListState copyWith({
    RestaurantsListStates? status,
    Failure? failure,
    List<RestaurantEntity>? nearByRestaurants,
    int? numOfRestaurants,
    Banner? banner,
    List<RestaurantEntity>? trendingRestaurants,
    List<SubCategoryEntity>? categories,
  }) {
    return RestaurantsListState(
      status: status ?? this.status,
      numOfRestaurants: numOfRestaurants ?? this.numOfRestaurants,
      failure: failure ?? this.failure,
      nearByRestaurants: nearByRestaurants ?? this.nearByRestaurants,
      banner: banner ?? this.banner,
      trendingRestaurants: trendingRestaurants ?? this.trendingRestaurants,
      categories: categories ?? this.categories,
    );
  }
}
