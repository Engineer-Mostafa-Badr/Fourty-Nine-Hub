part of 'restaurants_list_cubit.dart';

enum RestaurantsListStates {
  initState,
  allRestaurants,
  loadingAllRestaurants,
  loading,
  loadingSubCategories,
  error,
  success
}

extension RestaurantsListStateX on RestaurantsListState {
  bool get isInitial => status == RestaurantsListStates.initState;
  bool get isLoading => status == RestaurantsListStates.loading;
  bool get allRestaurants => status == RestaurantsListStates.allRestaurants;
  bool get loadingAllRestaurants =>
      status == RestaurantsListStates.loadingAllRestaurants;
  bool get isError => status == RestaurantsListStates.error;
  bool get loadingSubCategories =>
      status == RestaurantsListStates.loadingSubCategories;
  bool get isSuccess => status == RestaurantsListStates.success;
}

@immutable
class RestaurantsListState {
  final RestaurantsListStates status;
  final Failure? failure;
  final List<RestaurantEntity>? nearByRestaurants;
  final Banner? banner;
  final int? numOfRestaurants;
  final MainCategoryEntity? mainCategory;
  final IsRestaurantModel? isResturant;
  final List<Restaurant>? allRestaurant;
  final List<RestaurantEntity>? trendingRestaurants;
  final List<RestaurantEntity>? subCategories;
  final List<FoodCategoryEntity>? mealCategories;
  final List<SubCategoryEntity>? categories;
  const RestaurantsListState({
    this.status = RestaurantsListStates.loading,
    this.mealCategories,
    this.failure,
    this.subCategories,
    this.numOfRestaurants,
    this.mainCategory,
    this.allRestaurant,
    this.isResturant,
    this.nearByRestaurants,
    this.banner,
    this.trendingRestaurants,
    this.categories,
  });
  RestaurantsListState copyWith({
    RestaurantsListStates? status,
    Failure? failure,
    List<RestaurantEntity>? nearByRestaurants,
    List<RestaurantEntity>? subCategories,
    List<Restaurant>? allRestaurant,
    int? numOfRestaurants,
    Banner? banner,
    MainCategoryEntity? mainCategory,
    IsRestaurantModel? isRestaurant,
    List<RestaurantEntity>? trendingRestaurants,
    List<SubCategoryEntity>? categories,
    List<FoodCategoryEntity>? mealCategories,
  }) {
    return RestaurantsListState(
      status: status ?? this.status,
      mealCategories: mealCategories ?? this.mealCategories,
      numOfRestaurants: numOfRestaurants ?? this.numOfRestaurants,
      allRestaurant: allRestaurant ?? this.allRestaurant,
      failure: failure ?? this.failure,
      mainCategory: mainCategory ?? this.mainCategory,
      isResturant: isRestaurant ?? isResturant,
      subCategories: subCategories ?? this.subCategories,
      nearByRestaurants: nearByRestaurants ?? this.nearByRestaurants,
      banner: banner ?? this.banner,
      trendingRestaurants: trendingRestaurants ?? this.trendingRestaurants,
      categories: categories ?? this.categories,
    );
  }
}
