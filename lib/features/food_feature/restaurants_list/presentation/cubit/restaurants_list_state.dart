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
  final ExpiredRequestsResponse? expiredRequestsResponse;
  final Failure? failure;
  final List<RestaurantEntity>? nearByRestaurants;
  final Banner? banner;
  final bool? isLoadingMore;
  final bool? isLoadingRestaurantsMore;
  final bool? isLoadingExpiredOrdersMore;
  final int? numOfRestaurants;
  final String? selectedSubCategoryId;
  final FoodCategoryEntity? selectedCategory;
  final MainCategoryEntity? mainCategory;
  final IsRestaurantModel? isResturant;
  final List<Restaurant2Model>?
      allRestaurant; // Using Restaurant2Model for consistency
  final List<RestaurantEntity>? trendingRestaurants;
  final List<Restaurant2Model>? subCategories;
  final List<FoodCategoryEntity>? mealCategories;
  final List<SubCategoryEntity>? categories;

  const RestaurantsListState({
    this.expiredRequestsResponse,
    this.status = RestaurantsListStates.loading,
    this.mealCategories,
    this.failure,
    this.subCategories,
    this.numOfRestaurants,
    this.mainCategory,
    this.allRestaurant,
    this.isLoadingMore=false,
    this.isLoadingExpiredOrdersMore=false,
    this.selectedCategory,
    this.selectedSubCategoryId='',
    this.isLoadingRestaurantsMore,
    this.isResturant,
    this.nearByRestaurants,
    this.banner,
    this.trendingRestaurants,
    this.categories,
  });

  RestaurantsListState copyWith({
    RestaurantsListStates? status,
    ExpiredRequestsResponse? expiredRequestsResponse,
    Failure? failure,
    bool? isLoadingMore,
    bool? isLoadingExpiredOrdersMore,
    bool? isLoadingRestaurantsMore,
    List<RestaurantEntity>? nearByRestaurants,
    List<Restaurant2Model>? subCategories,
    String? selectedSubCategoryId,
    FoodCategoryEntity? selectedCategory,
    List<Restaurant2Model>?
        allRestaurant, // Using Restaurant2Model for consistency
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
      expiredRequestsResponse:
          expiredRequestsResponse ?? this.expiredRequestsResponse,
      mealCategories: mealCategories ?? this.mealCategories,
      numOfRestaurants: numOfRestaurants ?? this.numOfRestaurants,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadingExpiredOrdersMore: isLoadingExpiredOrdersMore ?? this.isLoadingExpiredOrdersMore,
      isLoadingRestaurantsMore: isLoadingRestaurantsMore ?? this.isLoadingRestaurantsMore,
      allRestaurant: allRestaurant ?? this.allRestaurant,
      failure: failure ?? this.failure,
      mainCategory: mainCategory ?? this.mainCategory,
      isResturant: isRestaurant ?? isResturant,
      subCategories: subCategories ?? this.subCategories,
      nearByRestaurants: nearByRestaurants ?? this.nearByRestaurants,
      banner: banner ?? this.banner,
      trendingRestaurants: trendingRestaurants ?? this.trendingRestaurants,
      categories: categories ?? this.categories,
      selectedSubCategoryId: selectedSubCategoryId ?? this.selectedSubCategoryId,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
