import 'package:fourtyninehub/features/account_taps/account/data/datasources/account_remote_datasource.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/usecases/delete_favourite_ads_usecase.dart';
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
import 'package:fourtyninehub/features/account_taps/wallet/data/datasources/Gift/gift_remote_data_source.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/repositories/Gift/gift_repository_impl.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/repositories/wallet_repo_impl.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/gift_repository.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/wallet_repo.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/delete_subscription_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_balance_history_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_balance_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_gifts_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_winners_gift_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/request_withdraw_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/request_withdraw_wallet_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/request_withdraw_wheel_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/charge_wallet_cubit/charge_wallet_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/cashback_cubit/cashback_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/fetch_sub_category_wallet/fetch_sub_category_wallet_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/gift_two_cubit/gift_two_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_two_cubit/wallet_two_cubit.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/use_cases/get_wheel_wallet_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/winners_gift_cubit/winners_gift_cubit.dart';
import 'package:fourtyninehub/features/subscripe/domain/usecases/get_active_subscription_amounts.dart';
import 'package:get_it/get_it.dart';

import '../features/account_taps/account/data/repositories/account_repo_impl.dart';
import '../features/account_taps/account/domain/repositories/account_repo.dart';
import '../features/account_taps/account/domain/usecases/get_drawer_favourite_ads_usecase.dart';
import '../features/account_taps/account/presentation/cubit/cubit/favourite_drawer_cubit.dart';
import '../features/account_taps/account/presentation/cubit/managers/favourite_ads_cubit.dart';
import '../features/account_taps/account/presentation/cubit/managers/favourite_subcategories_cubit.dart';
import '../features/account_taps/lists/presentation/cubit/lists_cubit.dart';
import '../features/account_taps/share_app/presentation/cubit/share_app_cubit.dart';
import '../features/account_taps/wallet/domain/usecases/add_subscribe_use_case.dart';
import '../features/account_taps/wallet/domain/usecases/get_gift_competitions_use_case.dart';
import '../features/account_taps/wallet/domain/usecases/get_subscription_use_case.dart';
import '../features/account_taps/wallet/domain/usecases/get_wallet_history_use_case.dart';
import '../features/account_taps/wallet/domain/usecases/get_winners_cashback_use_case.dart';
import '../features/account_taps/wallet/domain/usecases/main_category_use_case.dart';
import '../features/account_taps/wallet/domain/usecases/sub_category_use_case.dart';
import '../features/account_taps/wallet/domain/usecases/transfer_balance_use_cse.dart';
import '../features/account_taps/wallet/domain/usecases/transfer_ten_balance_use_cse.dart';
import '../features/account_taps/wallet/domain/usecases/withdraw_balance_use_cse.dart';
import '../features/account_taps/wallet/presentation/cubit/subscription_wallet_cubit/subscription_wallet_cubit.dart';
import '../features/account_taps/wallet/presentation/cubit/winners_cashback_cubit/winners_cashback_cubit.dart';

class AccountServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<AccountRemoteDataSource>(
        () => AccountRemoteDataSourceImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<GiftRemoteDataSource>(
        () => GiftRemoteDataSourceImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<WalletRemoteDataSource>(
        () => WalletRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<ListsRemoteDataSource>(
        () => ListsRemoteDataSourceImpl(serviceLocator()));
    // AccountRepo
    serviceLocator.registerLazySingleton<ListsRepo>(
        () => ListsRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<WalletRepo>(
        () => WalletRepoImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<GiftRepository>(
        () => GiftRepositoryImpl(serviceLocator()));

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
    serviceLocator.registerLazySingleton<GetWalletHistoryUseCase>(
        () => GetWalletHistoryUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetSubscriptionWalletUseCase>(
        () => GetSubscriptionWalletUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetWalletUseCase>(
        () => GetWalletUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetWalletGiftsUseCase>(
        () => GetWalletGiftsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<RequestWithdrawUseCase>(
        () => RequestWithdrawUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<RequestWithdrawWheelUseCase>(
        () => RequestWithdrawWheelUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<MainCategoryUseCase>(
        () => MainCategoryUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<SubCategoryUseCase>(
        () => SubCategoryUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<DeleteSubscriptionUseCase>(
        () => DeleteSubscriptionUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<AddSubscriptionUseCase>(
        () => AddSubscriptionUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetDrawerFavouriteAdsUsecase>(
        () => GetDrawerFavouriteAdsUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<DeleteFavouriteAdsUsecase>(
        () => DeleteFavouriteAdsUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetGiftCompetitionsUseCase>(
        () => GetGiftCompetitionsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<RequestWithdrawWalletUseCase>(
        () => RequestWithdrawWalletUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<TransferTenBalanceUseCase>(
        () => TransferTenBalanceUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<TransferFiveBalanceUseCase>(
        () => TransferFiveBalanceUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<RequestWithdrawBalanceUseCase>(
        () => RequestWithdrawBalanceUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetWinnersCashbackUseCase>(
        () => GetWinnersCashbackUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetWinnersGiftUseCase>(
        () => GetWinnersGiftUseCase(serviceLocator()));

    serviceLocator.registerFactory<FavouriteAdsCubit>(
        () => FavouriteAdsCubit(serviceLocator())..loadData());

    serviceLocator.registerFactory<FavouriteSubCategoryCubit>(() =>
        FavouriteSubCategoryCubit(
            serviceLocator(), serviceLocator(), serviceLocator()));
    serviceLocator.registerFactory<FavouriteCategoryCubit>(() =>
        FavouriteCategoryCubit(serviceLocator(), serviceLocator()));
    serviceLocator
        .registerFactory<ShareAppCubit>(() => ShareAppCubit(serviceLocator()));

    serviceLocator.registerFactory<ListsCubit>(() => ListsCubit(
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
        .registerFactory<FavouriteDrawerCubit>(() => FavouriteDrawerCubit(
              serviceLocator(),
              serviceLocator(),
            ));
    serviceLocator.registerFactory<WalletCubit>(() => WalletCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ),//..loadData()
    );

    serviceLocator.registerFactory<WalletTwoCubit>(
      () => WalletTwoCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );

    serviceLocator.registerFactory<FetchSubCategoryWalletCubit>(
        () => FetchSubCategoryWalletCubit(
              serviceLocator<SubCategoryUseCase>(),
            ));

    serviceLocator.registerFactory<ChargeWalletCubit>(
      () => ChargeWalletCubit(
        serviceLocator<GetActiveSubscriptionAmountsUseCase>(),
      ),
    );

    serviceLocator.registerFactory<GiftTwoCubit>(
      () => GiftTwoCubit(
        // serviceLocator<GetWalletGiftsUseCase>(),
        serviceLocator<GetGiftCompetitionsUseCase>(),
        serviceLocator<TransferFiveBalanceUseCase>(),
        serviceLocator<TransferTenBalanceUseCase>(),
        serviceLocator<RequestWithdrawUseCase>(),
        serviceLocator<RequestWithdrawWheelUseCase>(),
      ),
    );

    serviceLocator.registerFactory<CashbackCubit>(
      () => CashbackCubit(
        serviceLocator<GetBalanceUseCases>(),
        serviceLocator<GetBalanceHistoryUseCase>(),
        serviceLocator<RequestWithdrawBalanceUseCase>(),
      ),
    );

    serviceLocator.registerFactory<SubscriptionWalletCubit>(
      () => SubscriptionWalletCubit(
        serviceLocator<DeleteSubscriptionUseCase>(),
      ),
    );

    serviceLocator.registerFactory<WinnersCashbackCubit>(
      () => WinnersCashbackCubit(
        serviceLocator<GetWinnersCashbackUseCase>(),
      ),
    );

    serviceLocator.registerFactory<WinnersGiftCubit>(
      () => WinnersGiftCubit(
        serviceLocator<GetWinnersGiftUseCase>(),
      ),
    );

    serviceLocator.registerFactory<GiftCubit>(() => GiftCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        )..loadData());
  }
}
