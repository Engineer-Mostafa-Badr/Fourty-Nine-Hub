import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_num_of_resturant_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/getsubcategory_restaurants_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/banner.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_banner_by_id_use_case.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import '../../../../../core/enums/main_services_enum.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/usecases/get_trending_restaurants_usecase.dart';

part 'restaurants_list_state.dart';

class RestaurantsListCubit extends Cubit<RestaurantsListState> {
  final GetSubCategoriesUseCase _getFoodCategoriesUseCase;
  final GetNearByRestaurantsUseCase _getNearByRestaurantsUseCase;
  final GetTrendingRestaurantsUseCase _getTrendingRestaurantsUseCase;
  final GetBannerByIdUseCase _getBannerByIdUseCase;
  final GetNumOfResturantUseCase _getNumOfResturantUseCase;
  final GetSubCategoryRestaurantsUseCases _getSubCategoryRestaurantsUseCases;
  RestaurantsListCubit(
    this._getFoodCategoriesUseCase,
    this._getBannerByIdUseCase,
    this._getNearByRestaurantsUseCase,
    this._getTrendingRestaurantsUseCase,
    this._getSubCategoryRestaurantsUseCases,
    this._getNumOfResturantUseCase,
  ) : super(const RestaurantsListState());
  final service = MainServicesEnum.food;

  void loadData() async {
    Future.wait([
      getSubCategories(),
      getBannerById(),
      getNearByRestaurants(),
      getNumOfRestaurants(),
    ]);
  }

  Future<void> getNearByRestaurants() async {
    final response =
        await _getNearByRestaurantsUseCase.call(LocationParams(lat: 0, lng: 0));
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: RestaurantsListStates.error)),
        (data) => emit(state.copyWith(
            nearByRestaurants: data, status: RestaurantsListStates.initState)));
  }

  Future<void> getBannerById() async {
    final response = await _getBannerByIdUseCase.call(id: service.value());
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
          nearByRestaurants: data, status: RestaurantsListStates.initState));
    });
  }

  Future<void> getSubCategories() async {
    final response = await _getFoodCategoriesUseCase(service.value());
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
}
