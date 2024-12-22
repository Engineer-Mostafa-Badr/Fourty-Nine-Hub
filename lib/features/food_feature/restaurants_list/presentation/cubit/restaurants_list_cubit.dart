import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/is_restaurant_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/change_connectivity_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_all_restaurant_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_expired_orders_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_meal_categories_with_count_restaurants_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/getsubcategory_restaurants_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/is_resturant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/toggle_restaurant_favourite_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/banner.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_banner_by_id_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_subcategory.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/enums/main_services_enum.dart';
import '../../../../social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import '../../../../subcategories/domain/entities/sub_category_entity.dart';
import '../../data/models/expired_requests_model.dart';
import '../../data/models/restaurant_2_model.dart';
import '../../domain/entities/restaurant_entity.dart';

part 'restaurants_list_state.dart';

class RestaurantsCubit extends Cubit<RestaurantsListState> {
  final GetMainCategoryDetailsUseCase _getMainCategoryDetailsUseCase;
  final GetAllRestaurantUseCase _getAllRestaurantUseCase;
  // final GetNearByRestaurantsUseCase _getNearByRestaurantsUseCase;
  final GetBannerByIdUseCase _getBannerByIdUseCase;
  // final GetNumOfResturantUseCase _getNumOfResturantUseCase;
  final GetSubCategoryRestaurantsUseCases _getSubCategoryRestaurantsUseCases;
  final ToggleFavoriteSubcategoryUseCase _toggleFavoriteSubcategoryUseCase;
  // final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;
  final ToggleRestaurantFavouriteUseCase _toggleRestaurantFavouriteUseCase;
  final IsResturantUsecase _isResturantUseCase;
  final ChangeConnectivityUseCase _changeConnectivityUseCase;
  final GetExpiredOrdersUseCase _getExpiredOrdersUseCase;
  final GetMealCategoriesWithCountRestaurantsUseCase
      _getMealCategoriesWithCountRestaurantsUseCase;
  final ApiConsumer apiConsumer;

  RestaurantsCubit(
    this._getMainCategoryDetailsUseCase,
    this._getAllRestaurantUseCase,
    // this._getNearByRestaurantsUseCase,
    this._getBannerByIdUseCase,
    // this._getNumOfResturantUseCase,
    this._getSubCategoryRestaurantsUseCases,
    this._toggleFavoriteSubcategoryUseCase,
    this._toggleFavoriteCategoryUseCase,
    this._isResturantUseCase,
    this._getMealCategoriesWithCountRestaurantsUseCase,
    this.apiConsumer,
    this._changeConnectivityUseCase,
    this._getExpiredOrdersUseCase,
    this._toggleRestaurantFavouriteUseCase,
  ) : super(const RestaurantsListState());

  final service = MainServicesEnum.food;
  UserEntity? user;
  String? token;

  @override
  void onChange(Change<RestaurantsListState> change) {
    print("Current State: ${change.currentState.status}");
    print("Next State: ${change.nextState.status}");
    super.onChange(change);
  }

  Future<void> loadData() async {
    await _getUser();
    _getMainCategoryDetails();
    isRestaurant();
    loadInitialData();
    loadInitialRestaurantsData('');
    emit(state.copyWith(status: RestaurantsListStates.success));
  }

  Future<void> _getUser() async {
    await serviceLocator<UserCubit>()
        .getUser()
        .then((Either<Failure, UserEntity>? value) {
      value?.fold(
        (failure) => print("Failed to get user: $failure"),
        (u) => user = u,
      );
    });
  }

  Future<bool> toggleFavoriteSubcategory(String subcategoryId) async {
    final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
    bool isFav = false;
    response.fold(
        (failure) => emit(state.copyWith(status: RestaurantsListStates.error)),
        (data) {
      isFav = true;
      emit(state.copyWith(status: RestaurantsListStates.success));
    });
    return isFav;
  }

  Future<void> toggleFavoriteCategory(String categoryId) async {
    final response = await _toggleFavoriteCategoryUseCase(categoryId);
    response.fold(
        (failure) => emit(state.copyWith(status: RestaurantsListStates.error)),
        (data) async {
      await _getMainCategoryDetails();
    });
  }

  Future<bool> toggleFavoriteRestaurant(String id) async {
    final response = await _toggleRestaurantFavouriteUseCase(id);
    bool result = false;
    response.fold(
        (failure) => emit(state.copyWith(status: RestaurantsListStates.error)),
        (data) {
      result = data;
      emit(state.copyWith(status: RestaurantsListStates.success));
    });
    return result;
  }

  Future<void> isRestaurant() async {
    if (user != null) {
      final response = await _isResturantUseCase.call(const NoParams());
      response.fold(
          (failure) =>
              emit(state.copyWith(status: RestaurantsListStates.error)),
          (data) {
        print('sadafasfasvsdvd$data');
        emit(state.copyWith(isRestaurant: data));
      });
    } else {
      emit(state.copyWith(
          isRestaurant:
              IsRestaurantModel(isRestaurant: false, approved: false)));
    }
  }

  Future<void> getBannerById() async {
    final response = await _getBannerByIdUseCase.call(id: service.id);
    response.fold(
        (failure) => emit(state.copyWith(status: RestaurantsListStates.error)),
        (data) => emit(state.copyWith(banner: data)));
  }

  // Future<void> getAllRestaurant(int page) async {
  //   final response = await _getAllRestaurantUseCase(
  //       params: PostCommentsParams(
  //           userId: serviceLocator<UserCubit>().state.data?.id,page: page,limit: 2));
  //   response.fold(
  //       (failure) => emit(state.copyWith(status: RestaurantsListStates.error)),
  //       (data) {
  //         final isLastPage = data.length < 2;
  //         if (page == 1) {
  //           print("page == 1 $page");
  //           restaurantsPagingController.itemList = [];
  //         }
  //         if (isLastPage) {
  //           print("isLastPage = $isLastPage");
  //           restaurantsPagingController.appendLastPage(data);
  //         } else {
  //           print("isNotLastPage = $isLastPage");
  //           final nextPageKey = page + 1;
  //           restaurantsPagingController.appendPage(data, nextPageKey);
  //         }
  //         emit(state.copyWith(allRestaurant: data));
  //       });
  // }

  // Future<void> _getNumOfRestaurants() async {
  //   final response = await _getNumOfResturantUseCase.call();
  //   response.fold(
  //       (failure) => emit(state.copyWith(status: RestaurantsListStates.error)),
  //       (data) => emit(state.copyWith(numOfRestaurants: data)));
  // }

  // Futur<void> getSubCategoryRestaurants({required String id}) async {
  //   return;
  //   if (hasMoreRestaurantsData==false || isLoadingRestaurantMore==true) return;
  //   print("OpenFuncOOO");
  //
  //   isLoadingRestaurantMore = true;
  //   emit(state.copyWith(isLoadingRestaurantsMore: true));
  //   final response = await _getSubCategoryRestaurantsUseCases(GetSubCategoryRestaurants(id: id,page: 1,limit: 2));
  //
  //   response.fold(
  //         (failure) => emit(state.copyWith(failure: failure, status: RestaurantsListStates.error)),
  //         (data) {
  //       restaurants.addAll(data);
  //
  //       if (data.length < 1) {
  //         hasMoreRestaurantsData = false;
  //         emit(state.copyWith(isLoadingRestaurantsMore: false));
  //       } else {
  //         currentRestaurantsPage++;
  //       }
  //
  //       isLoadingRestaurantMore = false;
  //
  //       subCategories.map((e) => e.isSelected = false).toList();
  //       subCategories.firstWhere((element) => element.id==id).isSelected = true;
  //
  //       emit(state.copyWith(allRestaurant: restaurants,isLoadingRestaurantsMore: false));
  //     },
  //   );
  // }

  int pageSize = 10;
  final PagingController<int, Restaurant2Model> restaurantsPagingController =
      PagingController(firstPageKey: 1);

  void loadInitialData() async {
    subCategories.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchSubCategories();
  }

  void loadInitialExpiredOrders() async {
    emit(state.copyWith(status: RestaurantsListStates.loading));
    expiredOrders.clear();
    currentExpiredOrdersPage = 1;
    hasMoreExpiredOrders = true;
    await getExpiredOrders();
    emit(state.copyWith(status: RestaurantsListStates.success));
  }

  void loadInitialRestaurantsData(String? id) async {
    FoodCategoryEntity selectedCategory;
    if (subCategories.isNotEmpty) {
      selectedCategory =
          subCategories.firstWhere((element) => element.id == id);
    } else {
      selectedCategory = FoodCategoryEntity(
        id: '',
        image: Assets.allRestaurants,
        isSelected: true,
        fromAsset: true,
        nameAr: 'كل المطاعم',
        nameEn: 'All Restaurants',
      );
    }
    emit(state.copyWith(
        selectedSubCategoryId: id ?? '', selectedCategory: selectedCategory));
    restaurants.clear();
    currentRestaurantsPage = 1;
    hasMoreRestaurantsData = true;
    await fetchRestaurants();
    subCategories.map((e) => e.isSelected = false).toList();
    if (subCategories.isNotEmpty) {
      subCategories
          .firstWhere((element) => element.id == state.selectedSubCategoryId)
          .isSelected = true;
    }
  }

  bool isLoadingMore = false;
  bool hasMoreData = true;
  bool hasMoreExpiredOrders = true;
  int currentPage = 1;
  int currentExpiredOrdersPage = 1;
  bool isLoadingRestaurantMore = false;
  bool isLoadingExpiredOrdersMore = false;
  bool hasMoreRestaurantsData = true;
  int currentRestaurantsPage = 1;
  List<FoodCategoryEntity> subCategories = [];
  List<Restaurant2Model> restaurants = [];
  List<OrderData> expiredOrders = [];

  Future<void> fetchSubCategories() async {
    if (!hasMoreData || isLoadingMore) return;

    FoodCategoryEntity allRestaurants = FoodCategoryEntity(
      id: '',
      image: Assets.allRestaurants,
      isSelected: true,
      fromAsset: true,
      nameAr: 'كل المطاعم',
      nameEn: 'All Restaurants',
    );

    isLoadingMore = true;
    emit(state.copyWith(isLoadingMore: true));

    final response = await _getMealCategoriesWithCountRestaurantsUseCase(
        params: PostCommentsParams(
            userId: user?.id, page: currentPage, limit: pageSize));

    response.fold(
      (failure) => emit(state.copyWith(
          failure: failure, status: RestaurantsListStates.error)),
      (data) {
        subCategories.addAll(data);
        if (currentPage == 1) subCategories.insert(0, allRestaurants);

        if (data.length < pageSize) {
          hasMoreData = false;
          emit(state.copyWith(isLoadingMore: false));
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(
            mealCategories: subCategories, isLoadingMore: false));
      },
    );
  }

  Future<void> fetchRestaurants() async {
    if (hasMoreRestaurantsData == false || isLoadingRestaurantMore == true) {
      return;
    }
    print("OpenFuncOOO");

    isLoadingRestaurantMore = true;
    emit(state.copyWith(isLoadingRestaurantsMore: true));
    final response = await _getSubCategoryRestaurantsUseCases(
        GetSubCategoryRestaurants(
            id: state.selectedSubCategoryId ?? '',
            page: currentRestaurantsPage,
            limit: pageSize,
            userId: serviceLocator<UserCubit>().state.data?.id ?? ''));

    response.fold(
      (failure) => emit(state.copyWith(
          failure: failure, status: RestaurantsListStates.error)),
      (data) {
        restaurants.addAll(data);

        if (data.length < pageSize) {
          hasMoreRestaurantsData = false;
          emit(state.copyWith(isLoadingRestaurantsMore: false));
        } else {
          currentRestaurantsPage++;
        }

        isLoadingRestaurantMore = false;

        emit(state.copyWith(
            allRestaurant: restaurants, isLoadingRestaurantsMore: false));
      },
    );
  }

  Future<void> _getMainCategoryDetails() async {
    // if (user != null) {
    final response = await _getMainCategoryDetailsUseCase(service.id);
    response.fold(
        (failure) => emit(state.copyWith(status: RestaurantsListStates.error)),
        (data) {
      emit(state.copyWith(
        mainCategory: data,
      ));
    });
    // }
  }

  // Future<void> _ensureTokenInitialized() async {
  //   token ??= await CacheManager.getAccessToken();
  // }

  // Future<void> getExpiredOrders({int page = 1}) async {
  //   emit(state.copyWith(status: RestaurantsListStates.loading));
  //   final response = await _getExpiredOrdersUseCase(params:PaginationParams(page: page, limit: 5));
  //   response.fold(
  //           (failure) =>
  //               emit(state.copyWith(
  //                 status: RestaurantsListStates.error,
  //                 failure: failure,
  //               )),
  //           (data) =>  emit(state.copyWith(
  //             status: RestaurantsListStates.success,
  //             expiredRequestsResponse: data,
  //           )),);
  // }
  Future<void> getExpiredOrders() async {
    if (!hasMoreExpiredOrders || isLoadingExpiredOrdersMore) return;

    isLoadingExpiredOrdersMore = true;
    emit(state.copyWith(isLoadingExpiredOrdersMore: true));

    final response = await _getExpiredOrdersUseCase(
        params: PaginationParams(page: currentExpiredOrdersPage, limit: 5));
    response.fold(
      (failure) {
        isLoadingExpiredOrdersMore = false;
        emit(state.copyWith(
            failure: failure,
            isLoadingExpiredOrdersMore: false,
            status: RestaurantsListStates.error));
      },
      (data) {
        expiredOrders.addAll(data.data ?? []);

        if ((data.data?.length ?? 0) < 5) {
          hasMoreExpiredOrders = false;
          emit(state.copyWith(isLoadingMore: false));
        } else {
          currentExpiredOrdersPage++;
        }

        isLoadingExpiredOrdersMore = false;
        emit(state.copyWith(
            expiredRequestsResponse: data, isLoadingExpiredOrdersMore: false));
      },
    );
  }
}
