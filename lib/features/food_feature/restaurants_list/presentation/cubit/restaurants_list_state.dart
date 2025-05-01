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
  final bool? isLoadingUserOrdersMore;
  final int? numOfRestaurants;
  final String? selectedSubCategoryId;
  final FoodCategoryEntity? selectedCategory;
  final MainCategoryEntity? mainCategory;
  final IsRestaurantModel? isResturant;
  final List<UserOrderEntity>? userOrderEntity;
  final List<GetAllRestaurantEntity>?
      allRestaurant; // Using Restaurant2Model for consistency
  final List<RestaurantEntity>? trendingRestaurants;
  final List<GetAllRestaurantEntity>? subCategories;
  final List<FoodCategoryEntity>? mealCategories;
  final List<SubCategoryEntity>? categories;
  final List<LogsRequestLogsEntity>? logsEntity;
  final bool? isLoadingMoreLogs;
  final RateResponseEntity? rateResponseEntity;
  final RequestLogCountEntity? reqCount;
  final SetRequestSeenEntity? setRequestLogSeenEntity;
  final List<GetAllRestaurantEntity>? foodAdEntity;

  const RestaurantsListState({
    this.expiredRequestsResponse,
    this.status = RestaurantsListStates.loading,
    this.mealCategories,
    this.failure,
    this.subCategories,
    this.numOfRestaurants,
    this.mainCategory,
    this.allRestaurant,
    this.isLoadingMore = false,
    this.isLoadingExpiredOrdersMore = false,
    this.isLoadingUserOrdersMore = false,
    this.isLoadingMoreLogs = false,
    this.selectedCategory,
    this.selectedSubCategoryId = '',
    this.isLoadingRestaurantsMore,
    this.isResturant,
    this.nearByRestaurants,
    this.banner,
    this.trendingRestaurants,
    this.categories,
    this.userOrderEntity,
    this.logsEntity,
    this.rateResponseEntity,
    this.reqCount,
    this.setRequestLogSeenEntity,
    this.foodAdEntity,
  });

  RestaurantsListState copyWith({
    RestaurantsListStates? status,
    ExpiredRequestsResponse? expiredRequestsResponse,
    Failure? failure,
    bool? isLoadingMore,
    bool? isLoadingExpiredOrdersMore,
    bool? isLoadingMoreLogs,
    bool? isLoadingUserOrdersMore,
    bool? isLoadingRestaurantsMore,
    List<RestaurantEntity>? nearByRestaurants,
    List<GetAllRestaurantEntity>? subCategories,
    String? selectedSubCategoryId,
    FoodCategoryEntity? selectedCategory,
    List<GetAllRestaurantEntity>?
        allRestaurant, // Using Restaurant2Model for consistency
    int? numOfRestaurants,
    Banner? banner,
    MainCategoryEntity? mainCategory,
    IsRestaurantModel? isRestaurant,
    List<RestaurantEntity>? trendingRestaurants,
    List<SubCategoryEntity>? categories,
    List<FoodCategoryEntity>? mealCategories,
    List<UserOrderEntity>? userOrderEntity,
    List<LogsRequestLogsEntity>? logsEntity,
    RateResponseEntity? rateResponseEntity,
    RequestLogCountEntity? reqCount,
    SetRequestSeenEntity? setRequestLogSeenEntity,
    List<GetAllRestaurantEntity>? foodAdEntity,
  }) {
    return RestaurantsListState(
      status: status ?? this.status,
      expiredRequestsResponse:
          expiredRequestsResponse ?? this.expiredRequestsResponse,
      mealCategories: mealCategories ?? this.mealCategories,
      numOfRestaurants: numOfRestaurants ?? this.numOfRestaurants,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadingExpiredOrdersMore:
          isLoadingExpiredOrdersMore ?? this.isLoadingExpiredOrdersMore,
      isLoadingUserOrdersMore:
          isLoadingUserOrdersMore ?? this.isLoadingUserOrdersMore,
      isLoadingRestaurantsMore:
          isLoadingRestaurantsMore ?? this.isLoadingRestaurantsMore,
      allRestaurant: allRestaurant ?? this.allRestaurant,
      failure: failure ?? this.failure,
      mainCategory: mainCategory ?? this.mainCategory,
      isResturant: isRestaurant ?? isResturant,
      subCategories: subCategories ?? this.subCategories,
      nearByRestaurants: nearByRestaurants ?? this.nearByRestaurants,
      banner: banner ?? this.banner,
      trendingRestaurants: trendingRestaurants ?? this.trendingRestaurants,
      categories: categories ?? this.categories,
      selectedSubCategoryId:
          selectedSubCategoryId ?? this.selectedSubCategoryId,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      userOrderEntity: userOrderEntity ?? this.userOrderEntity,
      logsEntity: logsEntity ?? this.logsEntity,
      isLoadingMoreLogs: isLoadingMoreLogs ?? this.isLoadingMoreLogs,
      rateResponseEntity: rateResponseEntity ?? this.rateResponseEntity,
      reqCount: reqCount ?? this.reqCount,
      setRequestLogSeenEntity: setRequestLogSeenEntity ?? this.setRequestLogSeenEntity,
      foodAdEntity: foodAdEntity ?? this.foodAdEntity,
    );
  }
}
