import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_meal_categories_with_count_restaurants_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/search_restaurants_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_cities.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_governorates.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/routes/pages.dart';

part 'search_state.dart';

class SearchRestaurantsCubit extends Cubit<SearchRestaurantState> {
  final GetMealCategoriesWithCountRestaurantsUseCase
      _getMealCategoriesWithCountRestaurantsUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final SearchRestaurantsUseCase _searchRestaurantsUseCase;

  SearchRestaurantsCubit(
    super.initialState,
    this._getMealCategoriesWithCountRestaurantsUseCase,
    this._getCitiesUseCase,
    this._getGovernoratesUseCase,
    this._searchRestaurantsUseCase,
  );

  UserEntity? user;
  String? selectedMealCategory;
  String? selectedGovernment;
  String? selectedCity;

  Future<void> selectGovernorate(GovernorateEntity value) async {
    selectedGovernment = value.id;
    emit(state.copyWith(
      selectedGovernment: value.id,
      status: SearchRestaurantStates.loading,
    ));
    _getCities(value.id);
  }

  void selectCity(CityEntity value) {
    selectedCity = value.id;
    emit(state.copyWith(
      selectedCity: value.id,
      status: SearchRestaurantStates.loading,
    ));
    _searchRestaurants();
  }

  void selectSubcategory(FoodCategoryEntity subCategoryModel) {
    selectedMealCategory = subCategoryModel.id ?? "";
    emit(state.copyWith(
        selectedMealCategory: subCategoryModel,
        status: SearchRestaurantStates.loading));
    _getGovernorates();
  }

  loadData() async {
    await AppPages.router.routerDelegate.navigatorKey.currentContext!
        .read<UserCubit>()
        .getUser();
    if (AppPages.router.routerDelegate.navigatorKey.currentContext!
            .read<UserCubit>()
            .state
            .data !=
        null) {
      user = UserCubit.to.state.data;
    } else {}

    await _getMealCategoriesWithCountRestaurants();
  }

  Future<void> _getCities(String governorateId) async {
    final response = await _getCitiesUseCase.call(governorateId);

    response.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchRestaurantStates.error,
        ),
      ),
      (data) => emit(state.copyWith(
          status: SearchRestaurantStates.loadingCities, cities: data)),
    );
  }

  Future<void> _getGovernorates() async {
    final response = await _getGovernoratesUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
              status: SearchRestaurantStates.error,
            )), (data) {
      emit(state.copyWith(
          status: SearchRestaurantStates.loadingGovernorates,
          governorates: data));
    });
  }

  Future<void> _getMealCategoriesWithCountRestaurants() async {
    if (user != null) {
      final response = await _getMealCategoriesWithCountRestaurantsUseCase(
          params: PostCommentsParams(
        page: 1,
        userId: user?.id,
      ));
      response.fold(
          (failure) => emit(state.copyWith(
              failure: failure, status: SearchRestaurantStates.error)), (data) {
        emit(state.copyWith(
            mealCategories: data,
            status: SearchRestaurantStates.loadingSubCategories));
      });
    }
  }

  _searchRestaurants() async {
    final response = await _searchRestaurantsUseCase(
        city: selectedCity ?? "",
        government: selectedGovernment ?? "",
        subCategory: selectedMealCategory ?? "",
        params: const PostCommentsParams(page: 1, limit: 20));
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: SearchRestaurantStates.error)), (data) {
      emit(state.copyWith(
          allRestaurant: data, status: SearchRestaurantStates.loadingResult));
    });
  }
}
