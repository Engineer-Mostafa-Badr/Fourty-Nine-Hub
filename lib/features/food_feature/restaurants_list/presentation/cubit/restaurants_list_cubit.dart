import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_num_of_resturant_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/getsubcategory_restaurants_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/is_resturant_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/banner.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_banner_by_id_use_case.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/get_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_subcategory.dart';
import '../../../../../core/enums/main_services_enum.dart';

part 'restaurants_list_state.dart';

class RestaurantsListCubit extends Cubit<RestaurantsListState> {
  final GetSubCategoriesUseCase _getFoodCategoriesUseCase;
  final GetMainCategoryDetailsUseCase _getMainCategoryDetailsUseCase;
  final GetNearByRestaurantsUseCase _getNearByRestaurantsUseCase;
  // final GetTrendingRestaurantsUseCase _getTrendingRestaurantsUseCase;
  final GetBannerByIdUseCase _getBannerByIdUseCase;
  final GetNumOfResturantUseCase _getNumOfResturantUseCase;
  final GetSubCategoryRestaurantsUseCases _getSubCategoryRestaurantsUseCases;
  final ToggleFavoriteSubcategoryUseCase _toggleFavoriteSubcategoryUseCase;
  final IsResturantUsecase _isResturantUseCase;
  RestaurantsListCubit(
    this._getFoodCategoriesUseCase,
    this._getBannerByIdUseCase,
    this._isResturantUseCase,
    this._getNearByRestaurantsUseCase,
    // this._getTrendingRestaurantsUseCase,
    this._toggleFavoriteSubcategoryUseCase,
    this._getSubCategoryRestaurantsUseCases,
    this._getMainCategoryDetailsUseCase,
    this._getNumOfResturantUseCase,
  ) : super(const RestaurantsListState());
  final service = MainServicesEnum.food;

  void loadData() async {
    Future.wait([
      _getMainCategoryDetails(),
      _isDoctor(),
      getFoodCategories(),
      getNearByRestaurants(),
      // getNearByRestaurants(),
      getNumOfRestaurants(),
    ]);
  }

  Future<void> toggleFavoriteSubcategory(String subcategoryId) async {
    final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantsListStates.error)),
        (data) => getFoodCategories());
  }

  Future<void> _isDoctor() async {
    final response = await _isResturantUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantsListStates.error)),
        (data) => emit(state.copyWith(isResturant: data)));
  }

  Future<void> getNearByRestaurants() async {
    final response =
        await _getNearByRestaurantsUseCase.call(LocationParams(lat: 0, lng: 0));
    log("response failure: ${jsonEncode(response)}");

    response.fold((failure) {
      log("response failure: ${jsonEncode(response)}");
      emit(state.copyWith(
          failure: failure, status: RestaurantsListStates.error));
    }, (data) {
      log("response data: ${jsonEncode(response)}");
      emit(state.copyWith(
          nearByRestaurants: data, status: RestaurantsListStates.initState));
    });
  }

  Future<void> getBannerById() async {
    final response = await _getBannerByIdUseCase.call(id: service.id);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantsListStates.error)),
        (data) => emit(state.copyWith(
            banner: data, status: RestaurantsListStates.initState)));
  }

  Future<void> getNumOfRestaurants() async {
    final response = await _getNumOfResturantUseCase.call();
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantsListStates.error)),
        (data) => emit(state.copyWith(
            numOfRestaurants: data, status: RestaurantsListStates.initState)));
  }

  Future<void> getSubCategoryRestaurants({required String id}) async {
    final response = await _getSubCategoryRestaurantsUseCases(id);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantsListStates.error)), (data) {
      emit(state.copyWith(
          subCategories: data, status: RestaurantsListStates.initState));
    });
  }

  Future<void> getFoodCategories() async {
    final response = await _getFoodCategoriesUseCase(GetSubCategoriesParams(
        mainCategoryId: service.id,
        paginationParams: PaginationParams.basic()));
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantsListStates.error)), (data) {
      emit(state.copyWith(
          categories: data, status: RestaurantsListStates.initState));
      if (state.categories?.isNotEmpty ?? false) {
        getSubCategoryRestaurants(id: state.categories!.first.id);
      }
    });
  }

  Future<void> _getMainCategoryDetails() async {
    final response = await _getMainCategoryDetailsUseCase(service.id);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantsListStates.error)),
        (data) => emit(state.copyWith(mainCategory: data)));
  }
}
