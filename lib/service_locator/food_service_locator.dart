import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/datasources/restaurant_dashboard_remote_datasource.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/repositories/restaurant_dashboard_repo_impl.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/get_restaurant_orders_usecase.dart';
import 'package:get_it/get_it.dart';

import '../features/food_feature/cusine_restaurants/presentation/cubit/cusine_restaurants_cubit.dart';
import '../features/food_feature/restaurant_dashboard/domain/repositories/restaurant_dashboard_repo.dart';
import '../features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_dashboard_cubit.dart';
import '../features/food_feature/restaurant_details/data/datasources/restaurant_details_remote_data_source.dart';
import '../features/food_feature/restaurant_details/data/repositories/restaurant_details_repo_impl.dart';
import '../features/food_feature/restaurant_details/domain/repositories/restaurant_details_repo.dart';
import '../features/food_feature/restaurant_details/domain/usecases/get_meals_usecase.dart';
import '../features/food_feature/restaurant_details/domain/usecases/get_restaurant_details_usecase.dart';
import '../features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import '../features/food_feature/restaurants_list/data/datasources/restaurants_remote_data_source.dart';
import '../features/food_feature/restaurants_list/data/repositories/restaurant_list_repo_impl.dart';
import '../features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';
import '../features/food_feature/restaurants_list/domain/usecases/get_food_categories_usecase.dart';
import '../features/food_feature/restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';
import '../features/food_feature/restaurants_list/domain/usecases/get_trending_restaurants_usecase.dart';
import '../features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';

class FoodServiceLocator {
  static void execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<RestaurantRemoteDataSource>(
        () => RestaurantRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerFactory<RestaurantDashboardRemoteDataSource>(
        () => RestaurantDashboardRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<RestaurantsRemoteDataSource>(
        () => RestaurantsRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<RestaurantListRepo>(
        () => RestaurantListRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<RestaurantDetailsRepo>(
        () => RestaurantDetailsRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<RestaurantDashboardRepo>(
        () => RestaurantDashboardRepoImpl(serviceLocator()));
    serviceLocator.registerFactory<RestaurantsListCubit>(() =>
        RestaurantsListCubit(
            serviceLocator(), serviceLocator(), serviceLocator())
          ..loadData());
    serviceLocator
        .registerFactory<RestaurantDetailsCubit>(() => RestaurantDetailsCubit(
              serviceLocator(),
              serviceLocator(),
            )..loadData());
    serviceLocator
        .registerFactory<CusineRestaurantsCubit>(() => CusineRestaurantsCubit(
              serviceLocator(),
            )..loadData());
    serviceLocator.registerFactory<RestaurantDashboardCubit>(
        () => RestaurantDashboardCubit(serviceLocator())..loadData());
    serviceLocator.registerLazySingleton<GetRestaurantDetailsUseCase>(
        () => GetRestaurantDetailsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRestaurantOrdersUseCase>(
        () => GetRestaurantOrdersUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetMealsUseCase>(
        () => GetMealsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetNearByRestaurantsUseCase>(
      () => GetNearByRestaurantsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetTrendingRestaurantsUseCase>(
      () => GetTrendingRestaurantsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetFoodCategoriesUseCase>(
      () => GetFoodCategoriesUseCase(
        serviceLocator(),
      ),
    );

    // RestaurantDashboardCubit

    //CusineRestaurantsCubit
  }
}
