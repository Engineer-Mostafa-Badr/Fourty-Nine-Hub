import 'package:fourtyninehub/features/food_feature/food_cart/data/datasources/food_cart_remote_datasource.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/data/repositories/food_cart_repo_impl.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/domain/repositories/food_cart_repo.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/domain/usecases/get_cart_usecase.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/domain/usecases/place_order_usecase.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/cubit/food_cart_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/datasources/restaurant_dashboard_remote_datasource.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/repositories/restaurant_dashboard_repo_impl.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/delete_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/get_restaurant_orders_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/get_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/update_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/add_food_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/change_quantity_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/delete_cart_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/delete_food_from_cart_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/delete_food_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/change_connectivity_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/create_restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_all_restaurant_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_expired_orders_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_meal_categories_with_count_restaurants_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_num_of_resturant_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/is_resturant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/restaurant_shared_data.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/search_restaurants_use_case.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_menu_cubit/create_menu_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/toggle_restaurant_favourite_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/food_feature/cusine_restaurants/presentation/cubit/cusine_restaurants_cubit.dart';
import '../features/food_feature/restaurant_dashboard/domain/repositories/restaurant_dashboard_repo.dart';
import '../features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_dashboard_cubit.dart';
import '../features/food_feature/restaurant_details/data/datasources/restaurant_details_remote_data_source.dart';
import '../features/food_feature/restaurant_details/data/repositories/restaurant_details_repo_impl.dart';
import '../features/food_feature/restaurant_details/domain/repositories/restaurant_details_repo.dart';
import '../features/food_feature/restaurant_details/domain/usecases/add_to_cart_usecase.dart';
import '../features/food_feature/restaurant_details/domain/usecases/get_meals_usecase.dart';
import '../features/food_feature/restaurant_details/domain/usecases/get_restaurant_details_usecase.dart';
import '../features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import '../features/food_feature/restaurants_list/data/datasources/restaurants_remote_data_source.dart';
import '../features/food_feature/restaurants_list/data/repositories/restaurant_list_repo_impl.dart';
import '../features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';
import '../features/food_feature/restaurants_list/domain/usecases/getsubcategory_restaurants_usecase.dart';
import '../features/food_feature/restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';
import '../features/food_feature/restaurants_list/domain/usecases/get_trending_restaurants_usecase.dart';
import '../features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';

class FoodServiceLocator {
  static void execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<RestaurantRemoteDataSource>(
        () => RestaurantRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAllRestaurantUseCase>(
        () => GetAllRestaurantUseCase(serviceLocator()));
    serviceLocator.registerFactory<RestaurantDashboardRemoteDataSource>(() =>
        RestaurantDashboardRemoteDataSourceImpl(
            serviceLocator(), serviceLocator()));
    serviceLocator.registerLazySingleton<RestaurantsRemoteDataSource>(
        () => RestaurantsRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<FoodCartRemoteDataSource>(
        () => FoodCartRemoteDataSourceImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<RestaurantListRepo>(
        () => RestaurantListRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<RestaurantDetailsRepo>(
        () => RestaurantDetailsRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<RestaurantDashboardRepo>(
        () => RestaurantDashboardRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<FoodCartRepo>(
        () => FoodCartRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<CreateRestaurantUseCase>(
        () => CreateRestaurantUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ChangeConnectivityUseCase>(
        () => ChangeConnectivityUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetExpiredOrdersUseCase>(
        () => GetExpiredOrdersUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<AddFoodUseCase>(() => AddFoodUseCase(
          serviceLocator(),
        ));
    serviceLocator
        .registerLazySingleton<DeleteFoodUseCase>(() => DeleteFoodUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<DeleteRestaurantUseCase>(
        () => DeleteRestaurantUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<UpdateRestaurantUseCase>(
        () => UpdateRestaurantUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<DeleteFoodFromCartUseCase>(
        () => DeleteFoodFromCartUseCase(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<DeleteCartUseCase>(() => DeleteCartUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<ChangeQuantityUseCase>(
        () => ChangeQuantityUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<ToggleRestaurantFavouriteUseCase>(
        () => ToggleRestaurantFavouriteUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<RestaurantMenuCubit>(
        () => RestaurantMenuCubit(serviceLocator()));
    serviceLocator.registerLazySingleton<RestaurantSharedData>(
        () => RestaurantSharedData());
    serviceLocator.registerFactory<CreateRestaurantCubit>(
      () => CreateRestaurantCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
    serviceLocator.registerFactory<RestaurantsCubit>(() => RestaurantsCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
    serviceLocator
        .registerFactory<RestaurantDetailsCubit>(() => RestaurantDetailsCubit(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
            ));
    serviceLocator
        .registerFactory<CusineRestaurantsCubit>(() => CusineRestaurantsCubit(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<FoodCartCubit>(() => FoodCartCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
    serviceLocator.registerFactory<RestaurantDashboardCubit>(() =>
        RestaurantDashboardCubit(
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
            serviceLocator()));
    serviceLocator.registerLazySingleton<GetRestaurantDetailsUseCase>(
        () => GetRestaurantDetailsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRestaurantInfoUseCase>(
        () => GetRestaurantInfoUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRestaurantOrdersUseCase>(
        () => GetRestaurantOrdersUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetMealsUseCase>(
        () => GetMealsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<
            GetMealCategoriesWithCountRestaurantsUseCase>(
        () => GetMealCategoriesWithCountRestaurantsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetNearByRestaurantsUseCase>(
      () => GetNearByRestaurantsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetNumOfResturantUseCase>(
      () => GetNumOfResturantUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AddToCartUseCase>(
      () => AddToCartUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<GetSubCategoryRestaurantsUseCases>(
      () => GetSubCategoryRestaurantsUseCases(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<IsResturantUsecase>(
      () => IsResturantUsecase(
        serviceLocator(),
      ),
    );
    // GetSubCategoryRestaurantsUseCases
    serviceLocator.registerLazySingleton<GetTrendingRestaurantsUseCase>(
      () => GetTrendingRestaurantsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<PlaceOrderUseCase>(
      () => PlaceOrderUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<SearchRestaurantsCubit>(
      () => SearchRestaurantsCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<RemoveFromCartUseCase>(
      () => RemoveFromCartUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<SearchRestaurantsUseCase>(
      () => SearchRestaurantsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetCartUseCase>(
      () => GetCartUseCase(
        serviceLocator(),
      ),
    );
  }
}
