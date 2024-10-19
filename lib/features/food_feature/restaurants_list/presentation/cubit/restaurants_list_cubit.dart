import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/is_restaurant_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_all_restaurant_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_meal_categories_with_count_restaurants_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_num_of_resturant_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/getsubcategory_restaurants_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/is_resturant_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/banner.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_banner_by_id_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_subcategory.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/enums/main_services_enum.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import '../../../../subcategories/domain/entities/sub_category_entity.dart';
import '../../data/models/expired_requests_model.dart';
import '../../data/models/restaurant_2_model.dart';
import '../../domain/entities/restaurant_entity.dart';

part 'restaurants_list_state.dart';

class RestaurantsCubit extends Cubit<RestaurantsListState> {
  final GetMainCategoryDetailsUseCase _getMainCategoryDetailsUseCase;
  final GetAllRestaurantUseCase _getAllRestaurantUseCase;
  final GetNearByRestaurantsUseCase _getNearByRestaurantsUseCase;
  final GetBannerByIdUseCase _getBannerByIdUseCase;
  final GetNumOfResturantUseCase _getNumOfResturantUseCase;
  final GetSubCategoryRestaurantsUseCases _getSubCategoryRestaurantsUseCases;
  final ToggleFavoriteSubcategoryUseCase _toggleFavoriteSubcategoryUseCase;
  final IsResturantUsecase _isResturantUseCase;
  final GetMealCategoriesWithCountRestaurantsUseCase
      _getMealCategoriesWithCountRestaurantsUseCase;
  final ApiConsumer apiConsumer;

  RestaurantsCubit(
    this._getMainCategoryDetailsUseCase,
    this._getAllRestaurantUseCase,
    this._getNearByRestaurantsUseCase,
    this._getBannerByIdUseCase,
    this._getNumOfResturantUseCase,
    this._getSubCategoryRestaurantsUseCases,
    this._toggleFavoriteSubcategoryUseCase,
    this._isResturantUseCase,
    this._getMealCategoriesWithCountRestaurantsUseCase,
    this.apiConsumer,
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
    if (serviceLocator<UserCubit>().isLoggedIn) {
      await _getMainCategoryDetails();
      await isRestaurant();
      await _getMealCategoriesWithCountRestaurants();
      // await _getNumOfRestaurants();
      await getAllRestaurant();

      // Future.wait([
      //   _getMainCategoryDetails(),
      //   isRestaurant(),
      //   _getMealCategoriesWithCountRestaurants(),
      //   getAllRestaurant(),
      //   _getNumOfRestaurants(),
      // ]);
    }
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

  Future<void> toggleFavoriteSubcategory(String subcategoryId) async {
    final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
    response.fold(
        (failure) => emit(state.copyWith(status: RestaurantsListStates.error)),
        (data) => _getMealCategoriesWithCountRestaurants());
  }

  Future<void> toggleFavoriteCategory(String categoryId) async {
    await _ensureTokenInitialized();

    final String url = 'https://49dev.com/api/v1/favorite-category/$categoryId';
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.post(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Category API Success: $data");
        await _getMainCategoryDetails();
      } else {
        print("Failed to toggle favorite: ${response.statusCode}");
        emit(state.copyWith(status: RestaurantsListStates.error));
      }
    } catch (e) {
      print("API Error: $e");
      emit(state.copyWith(status: RestaurantsListStates.error));
    }
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

  Future<void> changeConnectivityStatus(isActive) async {
    const url = 'https://49dev.com/api/v1/restaurants/modify-active';

    await apiConsumer.patch(url, data: {
      'isActive': isActive,
    });

    await isRestaurant();
    emit(state);
  }

  Future<void> getBannerById() async {
    final response = await _getBannerByIdUseCase.call(id: service.id);
    response.fold(
        (failure) => emit(state.copyWith(status: RestaurantsListStates.error)),
        (data) => emit(state.copyWith(banner: data)));
  }

  Future<void> getAllRestaurant() async {
    final response = await _getAllRestaurantUseCase(
        params: PostCommentsParams(
            userId: serviceLocator<UserCubit>().state.data?.id));
    response.fold(
        (failure) => emit(state.copyWith(status: RestaurantsListStates.error)),
        (data) => emit(state.copyWith(allRestaurant: data)));
  }

  // Future<void> _getAllRestaurant(// required String userId,
  //     // int limit = 10,
  //     // int page = 1,
  //     ) async {
  //   emit(state.copyWith(status: RestaurantsListStates.loading));
  //
  //   const url = 'https://49dev.com/api/v1/restaurants/all-restaurants';
  //
  //   final queryParameters = {
  //     'userId': user?.id,
  //     // 'limit': limit.toString(),
  //     // 'page': page.toString(),
  //   };
  //
  //   final response = await apiConsumer.get(
  //     url,
  //     queryParameters: queryParameters,
  //   );
  //
  //   response.fold(
  //     (failure) {
  //       emit(state.copyWith(
  //         status: RestaurantsListStates.error,
  //         failure: failure,
  //       ));
  //     },
  //     (data) {
  //       // Assuming data contains the list of restaurants
  //       emit(state.copyWith(
  //         status: RestaurantsListStates.success,
  //         allRestaurant:
  //             data, // Update based on your API response
  //         // message: 'Restaurants loaded successfully',
  //       ));
  //     },
  //   );
  // }

  Future<void> _getNumOfRestaurants() async {
    final response = await _getNumOfResturantUseCase.call();
    response.fold(
        (failure) => emit(state.copyWith(status: RestaurantsListStates.error)),
        (data) => emit(state.copyWith(numOfRestaurants: data)));
  }

  Future<void> getSubCategoryRestaurants({required String id}) async {
    emit(state.copyWith(status: RestaurantsListStates.loadingSubCategories));
    final response = await _getSubCategoryRestaurantsUseCases(id);
    response.fold(
        (failure) => emit(state.copyWith(status: RestaurantsListStates.error)),
        (data) => emit(state.copyWith(
            subCategories: data, status: RestaurantsListStates.success)));
  }

  Future<void> _getMealCategoriesWithCountRestaurants() async {
    final response = await _getMealCategoriesWithCountRestaurantsUseCase(
        params: PostCommentsParams(userId: user?.id));
    response.fold(
        (failure) => emit(state.copyWith(status: RestaurantsListStates.error)),
        (data) => emit(state.copyWith(mealCategories: data)));
  }

  Future<void> _getMainCategoryDetails() async {
    if (user != null) {
      final response = await _getMainCategoryDetailsUseCase(service.id);
      response.fold(
          (failure) =>
              emit(state.copyWith(status: RestaurantsListStates.error)),
          (data) => emit(state.copyWith(
              mainCategory: data, status: RestaurantsListStates.success)));
    }
  }

  Future<void> _ensureTokenInitialized() async {
    token ??= await CacheManager.getAccessToken();
  }

  Future<void> getExpiredOrders({int page = 1}) async {
    emit(state.copyWith(status: RestaurantsListStates.loading));

    const String url = 'https://49dev.com/api/v1/food/expired-orders';

    final Map<String, dynamic> queryParameters = {
      'page': '$page',
    };

    final response = await apiConsumer.get(
      url,
      queryParameters: queryParameters,
    );

    response.fold(
      (failure) {
        emit(state.copyWith(
          status: RestaurantsListStates.error,
          failure: failure,
        ));
      },
      (data) {
        // final List<dynamic> ordersData = data['data'] ?? [];
        final orders = ExpiredRequestsResponse.fromJson(data);

        log(orders.data!.first.createdAt.toString() + ",jblnkln");
        emit(state.copyWith(
          status: RestaurantsListStates.success,
          expiredRequestsResponse: orders,
        ));
      },
    );
  }
}

// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:bloc/bloc.dart';
// import 'package:flutter/foundation.dart';
// import 'package:fourtyninehub/core/abstract/use_case.dart';
// import 'package:fourtyninehub/core/error/failure.dart';
// import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/is_restaurant_model.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_entity.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_all_restaurant_use_case.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_meal_categories_with_count_restaurants_use_case.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_num_of_resturant_use_case.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/getsubcategory_restaurants_usecase.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/is_resturant_usecase.dart';
// import 'package:fourtyninehub/features/fourty_nine/domain/entities/banner.dart';
// import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
// import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_banner_by_id_use_case.dart';
// import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
// import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
// import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
// import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_subcategory.dart';
// import '../../../../../core/enums/main_services_enum.dart';
// import '../../../../../service_locator/service_locator.dart';
//
// part 'restaurants_list_state.dart';
//
// class RestaurantsCubit extends Cubit<RestaurantsListState> {
//   final GetMainCategoryDetailsUseCase _getMainCategoryDetailsUseCase;
//   final GetAllRestaurantUseCase _getAllRestaurantUseCase;
//   final GetNearByRestaurantsUseCase _getNearByRestaurantsUseCase;
//
//   // final GetTrendingRestaurantsUseCase _getTrendingRestaurantsUseCase;
//   final GetBannerByIdUseCase _getBannerByIdUseCase;
//   final GetNumOfResturantUseCase _getNumOfResturantUseCase;
//   final GetSubCategoryRestaurantsUseCases _getSubCategoryRestaurantsUseCases;
//   final ToggleFavoriteSubcategoryUseCase _toggleFavoriteSubcategoryUseCase;
//   final IsResturantUsecase _isResturantUseCase;
//   final GetMealCategoriesWithCountRestaurantsUseCase
//       _getMealCategoriesWithCountRestaurantsUseCase;
//
//   RestaurantsCubit(
//     this._getMealCategoriesWithCountRestaurantsUseCase,
//     this._getBannerByIdUseCase,
//     this._isResturantUseCase,
//     this._getNearByRestaurantsUseCase,
//     // this._getTrendingRestaurantsUseCase,
//     this._toggleFavoriteSubcategoryUseCase,
//     this._getSubCategoryRestaurantsUseCases,
//     this._getAllRestaurantUseCase,
//     this._getMainCategoryDetailsUseCase,
//     this._getNumOfResturantUseCase,
//   ) : super(const RestaurantsListState());
//   final service = MainServicesEnum.food;
//
//   // final user = UserCubit.to.state.data;
//   @override
//   void onChange(Change<RestaurantsListState> change) {
//     print(change.currentState.status);
//     print(change.nextState.status);
//     super.onChange(change);
//   }
//
//   void loadData() async {
//     if (serviceLocator<UserCubit>().isLoggedIn) {
//       Future.wait([
//         _getMainCategoryDetails(),
//         _isDoctor(),
//         _getMealCategoriesWithCountRestaurants(),
//         _getAllRestaurant(),
//         // getNearByRestaurants(),
//         // getNearByRestaurants(),
//         getNumOfRestaurants(),
//       ]);
//     }
//   }
//
//   Future<void> toggleFavoriteSubcategory(String subcategoryId) async {
//     final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
//     response.fold(
//         (failure) => emit(state.copyWith(
//             failure: failure, status: RestaurantsListStates.error)),
//         (data) => _getMealCategoriesWithCountRestaurantsUseCase(
//             params: const PostCommentsParams(page: 1)));
//   }
//
//   Future<void> _isDoctor() async {
//     final response = await _isResturantUseCase.call(const NoParams());
//     response.fold(
//         (failure) => emit(state.copyWith(
//             failure: failure, status: RestaurantsListStates.error)),
//         (data) => emit(state.copyWith(isRestaurant: data)));
//   }
//
//   Future<void> getNearByRestaurants() async {
//     final response =
//         await _getNearByRestaurantsUseCase.call(LocationParams(lat: 0, lng: 0));
//     log("response failure: ${jsonEncode(response)}");
//
//     response.fold((failure) {
//       log("response failure: ${jsonEncode(response)}");
//       emit(state.copyWith(
//           failure: failure, status: RestaurantsListStates.error));
//     }, (data) {
//       log("response data: ${jsonEncode(response)}");
//       emit(state.copyWith(
//           nearByRestaurants: data, status: RestaurantsListStates.initState));
//     });
//   }
//
//   Future<void> getBannerById() async {
//     final response = await _getBannerByIdUseCase.call(id: service.id);
//     response.fold(
//         (failure) => emit(state.copyWith(
//             failure: failure, status: RestaurantsListStates.error)),
//         (data) => emit(state.copyWith(
//             banner: data, status: RestaurantsListStates.initState)));
//   }
//
//   Future<void> _getAllRestaurant() async {
//     final response = await _getAllRestaurantUseCase(
//         params: PostCommentsParams(
//             userId: serviceLocator<UserCubit>().state.data?.id));
//     log('aaaaaaaaaaaaaaaaaasssssssssssssddddddddddddddddddddddddd11dd${serviceLocator<UserCubit>().state.data?.id}');
//     response.fold(
//         (failure) => emit(state.copyWith(
//             failure: failure, status: RestaurantsListStates.error)),
//         (data) => emit(state.copyWith(
//             allRestaurant: data, status: RestaurantsListStates.initState)));
//   }
//
//   Future<void> getNumOfRestaurants() async {
//     final response = await _getNumOfResturantUseCase.call();
//     response.fold(
//         (failure) => emit(state.copyWith(
//             failure: failure, status: RestaurantsListStates.error)),
//         (data) => emit(state.copyWith(
//             numOfRestaurants: data, status: RestaurantsListStates.initState)));
//   }
//
//   Future<void> getSubCategoryRestaurants({required String id}) async {
//     emit(state.copyWith(
//       status: RestaurantsListStates.loading,
//     ));
//     final response = await _getSubCategoryRestaurantsUseCases(id);
//     response.fold(
//         (failure) => emit(state.copyWith(
//             failure: failure, status: RestaurantsListStates.error)), (data) {
//       emit(state.copyWith(
//           subCategories: data, status: RestaurantsListStates.success));
//     });
//   }
//
//   UserEntity? user;
//
//   Future<void> _getMealCategoriesWithCountRestaurants() async {
//     await UserCubit.to.getUser();
//     user = UserCubit.to.state.data;
//     if (user != null) {
//       final response = await _getMealCategoriesWithCountRestaurantsUseCase(
//           params: PostCommentsParams(
//         page: 1,
//         userId: user?.id,
//       ));
//       response.fold(
//           (failure) => emit(state.copyWith(
//               failure: failure, status: RestaurantsListStates.error)), (data) {
//         emit(state.copyWith(
//             mealCategories: data, status: RestaurantsListStates.initState));
//         if (state.categories?.isNotEmpty ?? false) {
//           getSubCategoryRestaurants(id: state.categories!.first.id);
//         }
//       });
//     }
//   }
//
//   Future<void> _getMainCategoryDetails() async {
//     final response = await _getMainCategoryDetailsUseCase(service.id);
//     response.fold(
//         (failure) => emit(state.copyWith(
//             failure: failure, status: RestaurantsListStates.error)),
//         (data) => emit(state.copyWith(mainCategory: data)));
//   }
// }
