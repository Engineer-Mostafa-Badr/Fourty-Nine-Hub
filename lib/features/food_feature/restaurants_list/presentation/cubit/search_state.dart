part of 'search_cubit.dart';

enum SearchRestaurantStates {
  initState,
  loading,
  loadingSubCategories,
  loadingGovernorates,
  loadingCities,
  loadingResult,
  error,
  success,
}

extension SearchRestaurantStateX on SearchRestaurantState {
  bool get isInitial => status == SearchRestaurantStates.initState;
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
  final List<RestaurantEntity>? subCategories;
  final List<SubCategoryEntity>? categories;
  final List<FoodCategoryEntity>? mealCategories;
  final List<CityEntity>? cities;
  final List<GovernorateEntity>? governorates;
  final FoodCategoryEntity? selectedMealCategory;
  final String? selectedGovernment;
  final String? selectedCity;

  const SearchRestaurantState({
    this.status = SearchRestaurantStates.loading,
    this.failure,
    this.cities,
    this.governorates,
    this.selectedMealCategory,
    this.selectedGovernment,
    this.selectedCity,
    this.subCategories,
    this.mainCategory,
    this.allRestaurant,
    this.categories,
    this.mealCategories,
  });
  SearchRestaurantState copyWith({
    SearchRestaurantStates? status,
    Failure? failure,
    List<CityEntity>? cities,
    List<GovernorateEntity>? governorates,
    List<RestaurantEntity>? subCategories,
    List<Restaurant>? allRestaurant,
    MainCategoryEntity? mainCategory,
    List<SubCategoryEntity>? categories,
    List<FoodCategoryEntity>? mealCategories,
    FoodCategoryEntity? selectedMealCategory,
    String? selectedGovernment,
    String? selectedCity,
  }) {
    return SearchRestaurantState(
      status: status ?? this.status,
      allRestaurant: allRestaurant ?? this.allRestaurant,
      mealCategories: mealCategories ?? this.mealCategories,
      selectedMealCategory: selectedMealCategory ?? this.selectedMealCategory,
      selectedGovernment: selectedGovernment ?? this.selectedGovernment,
      selectedCity: selectedCity ?? this.selectedCity,
      failure: failure ?? this.failure,
      cities: cities ?? this.cities,
      governorates: governorates ?? this.governorates,
      mainCategory: mainCategory ?? this.mainCategory,
      subCategories: subCategories ?? this.subCategories,
      categories: categories ?? this.categories,
    );
  }
}
