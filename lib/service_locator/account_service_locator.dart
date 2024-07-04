import 'package:fourtyninehub/features/account_taps/account/data/datasources/account_remote_datasource.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/usecases/get_favourite_ads_usecase.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/usecases/get_favourite_categories_usecase.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/usecases/get_favourite_subcategories_usecase.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/cubit/managers/favourite_categories_cubit.dart';
import 'package:fourtyninehub/features/account_taps/lists/data/datasources/lists_remote_datasource.dart';
import 'package:fourtyninehub/features/account_taps/lists/data/repositories/lists_repo_impl.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/repositories/lists_repo.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_blocked_usecase.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_followers_usecase.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_friend_requests_usecase.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_friends_usecase.dart';
import 'package:get_it/get_it.dart';
import '../features/account_taps/account/data/repositories/account_repo_impl.dart';
import '../features/account_taps/account/domain/repositories/account_repo.dart';
import '../features/account_taps/account/presentation/cubit/managers/favourite_ads_cubit.dart';
import '../features/account_taps/account/presentation/cubit/managers/favourite_subcategories_cubit.dart';
import '../features/account_taps/lists/presentation/cubit/lists_cubit.dart';
import '../features/account_taps/share_app/presentation/cubit/share_app_cubit.dart';

class AccountServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<AccountRemoteDataSource>(
        () => AccountRemoteDataSourceImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<ListsRemoteDataSource>(
        () => ListsRemoteDataSourceImpl(serviceLocator()));
        // AccountRepo
    serviceLocator.registerLazySingleton<ListsRepo>(
        () => ListsRepoImpl(serviceLocator()));
        serviceLocator.registerLazySingleton<AccountRepo>(
        () => AccountRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<GetFavouriteAdsUsecase>(
        () => GetFavouriteAdsUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetFavouriteCategoriesUseCase>(
        () => GetFavouriteCategoriesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetFavouriteSubCategoriesUseCase>(
        () => GetFavouriteSubCategoriesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetFriendsUsecase>(
        () => GetFriendsUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetFollowersUseCase>(
        () => GetFollowersUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetFriendRequestsUsecase>(
        () => GetFriendRequestsUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetBlockedUseCase>(
        () => GetBlockedUseCase(serviceLocator()));
    serviceLocator.registerFactory<FavouriteAdsCubit>(
        () => FavouriteAdsCubit(serviceLocator())..loadData());
    serviceLocator.registerFactory<FavouriteSubCategoryCubit>(
        () => FavouriteSubCategoryCubit(serviceLocator())..loadData());
    serviceLocator.registerFactory<FavouriteCategoryCubit>(
        () => FavouriteCategoryCubit(serviceLocator())..loadData());
 serviceLocator.registerFactory<ShareAppCubit>(
        () => ShareAppCubit());

    serviceLocator.registerFactory<ListsCubit>(() => ListsCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        )..loadData());

  }
}
