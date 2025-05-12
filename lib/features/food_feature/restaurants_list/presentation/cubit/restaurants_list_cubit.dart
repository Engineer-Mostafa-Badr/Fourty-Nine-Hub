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

import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/enums/main_services_enum.dart';
import '../../../../social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import '../../../../subcategories/domain/entities/sub_category_entity.dart';
import '../../data/models/expired_requests_model.dart';
import '../../data/models/restaurant_2_model.dart';
import '../../domain/entities/food_ads_entity.dart';
import '../../domain/entities/log_count_entity.dart';
import '../../domain/entities/logs_entity.dart';
import '../../domain/entities/rate_response_entity.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/set_request_seen_entity.dart';
import '../../domain/entities/user_order_entity.dart';
import '../../domain/usecases/add_rate_restaurant_use_case.dart';
import '../../domain/usecases/get_food_ads_use_case.dart';
import '../../domain/usecases/get_req_logs_count_use_case.dart';
import '../../domain/usecases/get_req_logs_use_case.dart';
import '../../domain/usecases/get_user_order_use_case.dart';
import '../../domain/usecases/set_request_log_seen_use_case.dart';

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
  final GetUserOrderUseCase _getUserOrderUseCase;
  final GetReqLogsUseCase getReqLogsUseCase;
  final ApiConsumer apiConsumer;
  final AddRateRestaurantUseCase addRateRestaurantUseCase;
  final GetReqLogsCountUseCase getReqLogsCountUseCase;
  final SetRequestLogSeenUseCase setRequestLogSeenUseCase;
  final GetFoodAdsUseCase getFoodAdsUseCase;
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
    this._getUserOrderUseCase,
    this.getReqLogsUseCase, this.addRateRestaurantUseCase, this.getReqLogsCountUseCase, this.setRequestLogSeenUseCase, this.getFoodAdsUseCase,
  ) : super(const RestaurantsListState());

  final service = MainServicesEnum.food;
  UserEntity? user;
  String? token;
  bool showSearch = false;

  @override
  void onChange(Change<RestaurantsListState> change) {
    print("Current State: ${change.currentState.status}");
    print("Next State: ${change.nextState.status}");
    super.onChange(change);
  }

  Future<void> setReqSeen({required String params}) async {
    emit(state.copyWith(status: RestaurantsListStates.loading));

    final response = await setRequestLogSeenUseCase(SetRequestLogSeenParams(requestId: params));

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: RestaurantsListStates.error));
      },
          (setData) async {
        emit(state.copyWith(
          setRequestLogSeenEntity: setData,
          status: RestaurantsListStates.success,

        ));
       await getReqCount();
         loadInitialReqLogs();


          },
    );
  }

  Future<void> getReqCount() async {
    emit(state.copyWith(status: RestaurantsListStates.loading));

    final response = await getReqLogsCountUseCase(NoParams());

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: RestaurantsListStates.error));
      },
          (reqCount) {
        emit(state.copyWith(
          reqCount: reqCount,
          status: RestaurantsListStates.success,

        ));
      },
    );
  }
  void updateLogEntity(LogsRequestLogsEntity updatedEntity) {
    // Get current state
    final currentState = state;

    // Check if we have logs in the current state
    if (currentState.logsEntity != null) {
      // Create updated list by replacing the matching log
      final updatedList = currentState.logsEntity!.map((log) =>
      log.id == updatedEntity.id ? updatedEntity : log
      ).toList();

      // Emit new state with updated list
      emit(currentState.copyWith(
        logsEntity: updatedList,
        status: RestaurantsListStates.success,
      ));
    }
  }

  Future<void> rateRestaurant({required AddRateRestaurantParams params}) async {
    emit(state.copyWith(status: RestaurantsListStates.loading));

    final response = await addRateRestaurantUseCase(params);

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: RestaurantsListStates.error));
      },
          (rateData) {
        emit(state.copyWith(
          rateResponseEntity: rateData,
            status: RestaurantsListStates.success,

        ));
      },
    );
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
    user= UserCubit.to.state.data;
    // await serviceLocator<UserCubit>()
    //     .getUser()
    //     .then((Either<Failure, UserEntity>? value) {
    //   value?.fold(
    //     (failure) => print("Failed to get user: $failure"),
    //     (u) => user = u,
    //   );
    // });
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
      loadInitialFoodAds();
    });
    return result;
  }
  void removeFromFavorites(String id) {
    restaurants.removeWhere((element) => element.id == id);
    // Also update the foodAdData if needed
    foodAdData.removeWhere((element) => element.id == id);
    emit(state.copyWith(
      allRestaurant: restaurants,
      foodAdEntity: foodAdData,
    ));
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

  void loadOrderData() async {
    subCategories.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchOrderData();
  }

  Future<void> fetchOrderData() async {
    if (!hasMoreUserOrders || isLoadingUserOrdersMore) return;

    isLoadingUserOrdersMore = true;
    emit(state.copyWith(isLoadingUserOrdersMore: true));

    final response = await _getUserOrderUseCase(
        params: GetUserOrderParams(page: currentUserOrdersPage, limit: 5));
    response.fold(
      (failure) {
        isLoadingUserOrdersMore = false;
        emit(state.copyWith(
            failure: failure,
            isLoadingUserOrdersMore: false,
            status: RestaurantsListStates.error));
      },
      (data) {
        userOrders.addAll(data ?? []);

        if ((data.length ?? 0) < 5) {
          hasMoreUserOrders = false;
          emit(state.copyWith(isLoadingMore: false));
        } else {
          currentUserOrdersPage++;
        }

        isLoadingUserOrdersMore = false;
        emit(state.copyWith(
            userOrderEntity: data, isLoadingUserOrdersMore: false));
      },
    );
  }

  int pageSize = 10;

  void loadInitialData() async {
    subCategories.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchSubCategories();
  }

  void loadInitialReqLogs() async {
    emit(state.copyWith(status: RestaurantsListStates.loading));
    reqLogs.clear();
    currentReqLogsPage = 1;
    hasMoreReqLogs = true;
    await getReqLogs();
    emit(state.copyWith(status: RestaurantsListStates.success));
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
      print("Elmonx ${selectedCategory}");
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
  bool hasMoreUserOrders = true;
  int currentPage = 1;
  int currentExpiredOrdersPage = 1;
  int currentUserOrdersPage = 1;
  bool isLoadingRestaurantMore = false;
  bool isLoadingExpiredOrdersMore = false;
  bool isLoadingUserOrdersMore = false;
  bool hasMoreRestaurantsData = true;
  int currentRestaurantsPage = 1;
  List<FoodCategoryEntity> subCategories = [];
  List<GetAllRestaurantEntity> restaurants = [];
  List<OrderData> expiredOrders = [];
  List<UserOrderEntity> userOrders = [];

  bool hasMoreReqLogs = true;
  int currentReqLogsPage = 1;
  bool isLoadingMoreLogs = false;

  List<LogsRequestLogsEntity> reqLogs = [];

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

  Future<void> getReqLogs() async {
    if (!hasMoreReqLogs || isLoadingMoreLogs) return;

    isLoadingMoreLogs = true;
    emit(state.copyWith(isLoadingMoreLogs: true));

    final response = await getReqLogsUseCase(
        params: PaginationParams(page: currentReqLogsPage, limit: 5));
    response.fold(
          (failure) {
            isLoadingMoreLogs = false;
        emit(state.copyWith(
            failure: failure,
            isLoadingMoreLogs: false,
            status: RestaurantsListStates.error));
      },
          (data) {
            reqLogs.addAll(data);

        if ((data.length ?? 0) < 5) {
          hasMoreReqLogs = false;
          emit(state.copyWith(isLoadingMore: false));
        } else {
          currentReqLogsPage++;
        }

        isLoadingMoreLogs = false;
        emit(state.copyWith(
            logsEntity: data, isLoadingMoreLogs: false));
      },
    );
  }

  List<GetAllRestaurantEntity> foodAdData = [];
  bool hasMoreFoodAds = true;
  int currentPageFoodAds = 1;
  bool isLoadingMoreFoodAds = false;

  void loadInitialFoodAds() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    foodAdData.clear();
    currentPageFoodAds = 1;
    hasMoreFoodAds = true;
    await getFoodAds();
    emit(state.copyWith(status: RestaurantsListStates.success));
  }

  Future<void> getFoodAds() async {
    if (!hasMoreFoodAds || isLoadingMoreFoodAds) return;
    isLoadingMoreFoodAds = true;
    emit(state.copyWith(isLoadingMoreLogs: true));
    final response = await getFoodAdsUseCase(
        params: PaginationParams(page: currentPageFoodAds, limit: 5));
    response.fold(
          (failure) {
            isLoadingMoreFoodAds = false;
        emit(state.copyWith(
            failure: failure,
            isLoadingMoreLogs: false,
            status: RestaurantsListStates.error));
      },
          (data) {
            foodAdData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreFoodAds = false;
          emit(state.copyWith(isLoadingMore: false));
        } else {
          currentPageFoodAds++;
        }

            isLoadingMoreFoodAds = false;
        emit(state.copyWith(
            foodAdEntity: data, isLoadingMoreLogs: false));
      },
    );
  }


}
