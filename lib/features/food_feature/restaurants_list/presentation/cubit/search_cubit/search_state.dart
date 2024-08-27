part of 'search_cubit.dart';

enum SearchRestaurantStates {
  initState,
  loading,
  loadingSubCategories,
  loadingSearchSubCategory,
  loadingSearchGevnorates,
  loadingSearchResult,
  loadingSearchCities,
  loadingGovernorates,
  loadingCities,
  loadingResult,
  error,
  success,
}

extension SearchRestaurantStateX on SearchRestaurantState {
  bool get isInitial => status == SearchRestaurantStates.initState;
  bool get isSearchGovernorates =>
      status == SearchRestaurantStates.loadingGovernorates;
  bool get isSearchCities => status == SearchRestaurantStates.loadingCities;
  bool get isSearchResult =>
      status == SearchRestaurantStates.loadingSearchResult;
  bool get isLoadingSearch =>
      status == SearchRestaurantStates.loadingSearchSubCategory;
  bool get isLoading => status == SearchRestaurantStates.loading;
  bool get isLoadingSubCategories =>
      status == SearchRestaurantStates.loadingSubCategories;
  bool get isloadingGovernorates =>
      status == SearchRestaurantStates.loadingGovernorates;
  bool get isloadingCities => status == SearchRestaurantStates.loadingCities;
  bool get isloadingResult => status == SearchRestaurantStates.loadingResult;
  bool get isError => status == SearchRestaurantStates.error;
  bool get isSuccess => status == SearchRestaurantStates.success;
}

@immutable
class SearchRestaurantState {
  final SearchRestaurantStates status;
  final Failure? failure;
  final MainCategoryEntity? mainCategory;
  final List<Restaurant>? allRestaurant;
  final List<Restaurant>? searchRestaurant;
  final List<RestaurantEntity>? subCategories;
  final List<SubCategoryEntity>? categories;
  final List<FoodCategoryEntity>? mealCategories;
  final List<FoodCategoryEntity>? searchMealCategories;
  final List<GovernorateEntity>? searchGovernorates;
  final List<CityEntity>? searchCities;
  final List<CityEntity>? cities;
  final List<GovernorateEntity>? governorates;
  final FoodCategoryEntity? selectedMealCategory;
  final String? selectedGovernment;
  final String? selectedCity;

  const SearchRestaurantState({
    this.status = SearchRestaurantStates.loading,
    this.failure,
    this.mainCategory,
    this.allRestaurant,
    this.searchRestaurant,
    this.subCategories,
    this.categories,
    this.mealCategories,
    this.searchMealCategories,
    this.searchGovernorates,
    this.searchCities,
    this.cities,
    this.governorates,
    this.selectedMealCategory,
    this.selectedGovernment,
    this.selectedCity,
  });
  SearchRestaurantState copyWith({
    SearchRestaurantStates? status,
    Failure? failure,
    MainCategoryEntity? mainCategory,
    List<Restaurant>? allRestaurant,
    List<Restaurant>? searchResultRestaurants,
    List<RestaurantEntity>? subCategories,
    List<SubCategoryEntity>? categories,
    List<FoodCategoryEntity>? mealCategories,
    List<FoodCategoryEntity>? searchMealCategories,
    List<GovernorateEntity>? searchGovernorates,
    List<CityEntity>? searchCities,
    List<CityEntity>? cities,
    List<GovernorateEntity>? governorates,
    FoodCategoryEntity? selectedMealCategory,
    String? selectedGovernment,
    String? selectedCity,
  }) {
    return SearchRestaurantState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      mainCategory: mainCategory ?? this.mainCategory,
      allRestaurant: allRestaurant ?? this.allRestaurant,
      searchRestaurant: searchResultRestaurants ?? this.searchRestaurant,
      subCategories: subCategories ?? this.subCategories,
      categories: categories ?? this.categories,
      mealCategories: mealCategories ?? this.mealCategories,
      searchMealCategories: searchMealCategories ?? this.searchMealCategories,
      searchGovernorates: searchGovernorates ?? this.searchGovernorates,
      searchCities: searchCities ?? this.searchCities,
      cities: cities ?? this.cities,
      governorates: governorates ?? this.governorates,
      selectedMealCategory: selectedMealCategory ?? this.selectedMealCategory,
      selectedGovernment: selectedGovernment ?? this.selectedGovernment,
      selectedCity: selectedCity ?? this.selectedCity,
    );
  }
}
