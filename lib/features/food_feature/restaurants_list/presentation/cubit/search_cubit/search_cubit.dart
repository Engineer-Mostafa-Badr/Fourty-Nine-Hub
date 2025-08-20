import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../authentication/domain/entities/user_entity.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../fourty_nine/domain/entities/main_category_entity.dart';
import '../../../../../health_feature/create_doctor/domain/entities/city.dart';
import '../../../../../health_feature/create_doctor/domain/entities/governorate_entity.dart';
import '../../../../../health_feature/create_doctor/domain/usecases/get_cities.dart';
import '../../../../../health_feature/create_doctor/domain/usecases/get_governorates.dart';
import '../../../../../social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import '../../../../../subcategories/domain/entities/sub_category_entity.dart';
import '../../../domain/entities/food_category_entity.dart';
import '../../../domain/entities/restaurant.dart';
import '../../../domain/usecases/get_meal_categories_with_count_restaurants_use_case.dart';
import '../../../domain/usecases/search_restaurants_use_case.dart';

part 'search_state.dart';

class SearchRestaurantsCubit extends Cubit<SearchRestaurantState> {
  final GetMealCategoriesWithCountRestaurantsUseCase
      _getMealCategoriesWithCountRestaurantsUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final SearchRestaurantsUseCase _searchRestaurantsUseCase;

  UserEntity? user;

  String? selectedMealCategory;
  String? selectedGovernment;
  String? selectedCity;
  SearchRestaurantsCubit(
    this._getMealCategoriesWithCountRestaurantsUseCase,
    this._getCitiesUseCase,
    this._getGovernoratesUseCase,
    this._searchRestaurantsUseCase,
  ) : super(const SearchRestaurantState());

  back() {
    if (state.status == SearchRestaurantStates.loadingGovernorates ||
        state.status == SearchRestaurantStates.loadingSearchGevnorates) {
      emit(state.copyWith(
        status: SearchRestaurantStates.loadingSubCategories,
      ));
    } else if (state.status == SearchRestaurantStates.loadingCities ||
        state.status == SearchRestaurantStates.loadingSearchCities) {
      emit(state.copyWith(status: SearchRestaurantStates.loadingGovernorates));
    } else if (state.status == SearchRestaurantStates.loadingResult ||
        state.status == SearchRestaurantStates.loadingSearchResult) {
      emit(state.copyWith(status: SearchRestaurantStates.loadingCities));
    } else {
      AppPages.router.routerDelegate.navigatorKey.currentContext!.pop();
    }
  }

  loadData() async {
    // await AppPages.router.routerDelegate.navigatorKey.currentContext!
    //     .read<UserCubit>()
    //     .getUser();
    if (AppPages.router.routerDelegate.navigatorKey.currentContext!
            .read<UserCubit>()
            .state
            .data !=
        null) {
      user = UserCubit.to.state.data;
    } else {}

    await _getMealCategoriesWithCountRestaurants();
    refreshState();
  }

  void refreshState() {
    emit(state.copyWith(status: SearchRestaurantStates.loadingSubCategories));
  }

  void searchCities(String value) {
    if (value.isNotEmpty) {
      List<CityEntity>? filteredCities = [];
      filteredCities = state.cities?.where((category) {
        return category.nameAr.toLowerCase().contains(value.toLowerCase()) ||
            category.nameEn.toLowerCase().contains(value.toLowerCase());
      }).toList();
      emit(state.copyWith(
        searchCities: filteredCities,
        status: SearchRestaurantStates.loadingSearchCities,
      ));
    } else {
      emit(state.copyWith(
        searchCities: state.cities,
        status: SearchRestaurantStates.loadingCities,
      ));
    }
  }

  void searchGovernorates(String value) {
    if (value.isNotEmpty) {
      List<GovernorateEntity>? filteredGovernorates = [];
      filteredGovernorates = state.governorates?.where((category) {
        return category.nameAr.toLowerCase().contains(value.toLowerCase()) ||
            category.nameEn.toLowerCase().contains(value.toLowerCase());
      }).toList();
      emit(state.copyWith(
        searchGovernorates: filteredGovernorates,
        status: SearchRestaurantStates.loadingSearchGevnorates,
      ));
    } else {
      emit(state.copyWith(
        searchMealCategories: state.mealCategories,
        status: SearchRestaurantStates.loadingGovernorates,
      ));
    }
  }

  void searchResult(String value) {
    if (value.isNotEmpty) {
      List<GetAllRestaurantEntity>? filteredRestaurants = [];
      filteredRestaurants = state.allRestaurant?.where((category) {
        return category.name!.toLowerCase().contains(value.toLowerCase());
      }).toList();
      emit(state.copyWith(
        searchResultRestaurants: state.allRestaurant,
        status: SearchRestaurantStates.loadingSearchResult,
      ));
    } else {
      emit(state.copyWith(
        searchResultRestaurants: state.allRestaurant,
        status: SearchRestaurantStates.loadingResult,
      ));
    }
  }

  void searchSubCategories(String value) {
    if (value.isNotEmpty) {
      List<FoodCategoryEntity>? filteredCategories = [];
      filteredCategories = state.mealCategories?.where((category) {
        return category.nameAr!.toLowerCase().contains(value.toLowerCase()) ||
            category.nameEn!.toLowerCase().contains(value.toLowerCase());
      }).toList();
      emit(state.copyWith(
        searchMealCategories: filteredCategories,
        status: SearchRestaurantStates.loadingSearchSubCategory,
      ));
    } else {
      emit(state.copyWith(
        searchGovernorates: state.searchGovernorates,
        status: SearchRestaurantStates.loadingSubCategories,
      ));
    }
  }

  void selectCity(CityEntity? value) {
    if (value == null) {
      return;
    }
    selectedCity = value.id;
    emit(state.copyWith(
      selectedCity: value.id,
      status: SearchRestaurantStates.loading,
    ));
    _searchRestaurants();
  }

  Future<void> selectGovernorate(GovernorateEntity? value) async {
    if (value == null) {
      return;
    }
    selectedGovernment = value.id;
    emit(state.copyWith(
      selectedGovernment: value.id,
      status: SearchRestaurantStates.loading,
    ));
    _getCities(value.id);
  }

  void selectSubcategory(FoodCategoryEntity? subCategoryModel) {
    if (subCategoryModel == null) {
      return;
    }
    selectedMealCategory = subCategoryModel.id ?? "";
    emit(state.copyWith(
        selectedMealCategory: subCategoryModel,
        status: SearchRestaurantStates.loading));
    _getGovernorates();
  }

  Future<void> _getCities(String governorateId) async {
    final response = await _getCitiesUseCase.call(governorateId);

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
          state.copyWith(
            status: SearchRestaurantStates.error,
          ),
        );
      },
      (data) => emit(state.copyWith(
          status: SearchRestaurantStates.loadingCities, cities: data)),
    );
  }

  Future<void> _getGovernorates() async {
    final response = await _getGovernoratesUseCase.call(const NoParams());
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(
        status: SearchRestaurantStates.error,
      ));
    }, (data) {
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
      response.fold((failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: SearchRestaurantStates.error));
      }, (data) {
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
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(
          failure: failure, status: SearchRestaurantStates.error));
    }, (data) {
      emit(state.copyWith(
          allRestaurant: data, status: SearchRestaurantStates.loadingResult));
    });
  }
}
