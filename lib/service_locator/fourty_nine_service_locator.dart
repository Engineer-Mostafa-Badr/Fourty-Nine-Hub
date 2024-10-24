import 'package:fourtyninehub/features/account_taps/contact_us/data/datasources/contact_us_remote_datasource.dart';
import 'package:fourtyninehub/features/account_taps/contact_us/data/repositories/contact_us_repo_impl.dart';
import 'package:fourtyninehub/features/account_taps/contact_us/domain/usecases/create_contact_us_usecase.dart';
import 'package:fourtyninehub/features/account_taps/contact_us/domain/usecases/get_contact_us_messages.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/data/datasources/my_add_remote_datasource.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/data/repositories/my_ads_repo_impl.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/repositories/my_ads_repo.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/accept_come_with_me_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/accept_pick_me_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/fetch_my_ads_by_id_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/get_my_ads_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/reject_come_with_me_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/reject_pick_me_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/presentation/cubit/my_adds_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/data/datasources/ad_details_remote_data_source.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/repositories/ad_details_repo.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/usecases/get_ad_details_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/usecases/get_relevant_ads_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/usecases/make_ad_premium_request_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/usecases/make_ad_request_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/data/datasources/ad_requests_remote_data_source.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/data/repositories/ad_requests_repo_impl.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/repositories/ad_requests_repo.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/usecases/get_ad_requests_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/presentation/cubit/ad_requests_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/datasources/ads_remote_data_source.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/repositories/ads_repo.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/favourite_ad_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_ads_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_all_comewithme_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_all_pickme_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/remove_favourite_ad_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/request_come_with_me_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/request_pick_me_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/data/datasources/create_ad_remote_datasource.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/data/repositories/create_ad_repo_impl.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/usecases/create_ad_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/usecases/filter_ad_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/usecases/get_ad_properties_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/data/data_sources/remote_data_source/fourty_nine_remote_data_source.dart';
import 'package:fourtyninehub/features/fourty_nine/data/repositories/fourty_nine_repository_impl.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/repositories/fourty_nine_repository.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_banner_by_id_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/add_main_category_to_favorites_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_currency_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_wallet_home_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/remove_main_category_to_favorites_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/toggle_sub_category_to_favorites_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_taps_cubit/main_categories_taps_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/thumbnails/thumbnails_cubit.dart';
import 'package:get_it/get_it.dart';
import '../features/account_taps/contact_us/domain/repositories/contact_us_repo.dart';
import '../features/account_taps/contact_us/presentation/cubit/contact_us_cubit.dart';
import '../features/account_taps/my_adds/domain/usecases/cancel_ad_usecase.dart';
import '../features/account_taps/my_adds/domain/usecases/click_use_case.dart';
import '../features/account_taps/my_adds/domain/usecases/delete_come_with_me_usecase.dart';
import '../features/account_taps/my_adds/domain/usecases/delete_my_installment_usecase.dart';
import '../features/account_taps/my_adds/domain/usecases/delete_my_trip_join_usecase.dart';
import '../features/account_taps/my_adds/domain/usecases/delete_pick_me_usecase.dart';
import '../features/account_taps/my_adds/domain/usecases/edit_my_ads_use_case.dart';
import '../features/account_taps/my_adds/domain/usecases/get_all_counts_ads_usecase.dart';
import '../features/account_taps/my_adds/domain/usecases/get_all_counts_usecase.dart';
import '../features/account_taps/my_adds/domain/usecases/get_my_auctions_usecase.dart';
import '../features/account_taps/my_adds/domain/usecases/get_my_come_with_you_usecase.dart';
import '../features/account_taps/my_adds/domain/usecases/get_my_installments_usecase.dart';
import '../features/account_taps/my_adds/domain/usecases/get_my_other_ads_usecase.dart';
import '../features/account_taps/my_adds/domain/usecases/get_my_pick_me_usecase.dart';
import '../features/account_taps/my_adds/domain/usecases/get_my_trip_join_usecase.dart';
import '../features/ads_feature/ad_details/data/repositories/ad_details_repo_impl.dart';
import '../features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import '../features/ads_feature/ads/data/repositories/ads_repo_impl.dart';
import '../features/ads_feature/create_ad/domain/repositories/create_ad_repo.dart';
import '../features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import '../features/fourty_nine/domain/use_cases/get_parent_main_categories_use_case.dart';
import '../features/fourty_nine/domain/use_cases/get_slider_items_usecase.dart';
import '../features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import '../features/fourty_nine/presentation/controllers/slider_cubit.dart/slider_cubit.dart';

class FourtyNineServiceLocator {
  static void execute(GetIt serviceLocator) {
    serviceLocator.registerLazySingleton<FourtyNineRemoteDataSource>(
      () => FourtyNineRemoteDataSourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AdsRemoteDataSource>(
      () => AdsRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AdRequestsRemoteDataSource>(
      () => AdRequestsRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AdDetailsRemoteDataSource>(
      () => AdDetailsRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<CreateAdRemoteDatasource>(
      () => CreateAdRemoteDatasourceImpl(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<MyAdsRemoteDatasource>(
      () => MyAdsRemoteDatasourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<ContactUsRemoteDataSource>(
      () => ContactUsRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<FourtyNineRepository>(
      () => FourtyNineRepositoryImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AdsRepo>(
      () => AdsRepoImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AdRequestsRepo>(
      () => AdRequestsRepoImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<ContactUsRepo>(
      () => ContactUsRepoImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AdDetailsRepo>(
      () => AdDetailsRepoImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<CreateAdRepo>(
      () => CreateAdRepoImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<MyAdsRepo>(
      () => MyAdsRepoImpl(
        serviceLocator(),
      ),
    );

    // use cases
    serviceLocator.registerLazySingleton<GetParentMainCategoriesUseCase>(
      () => GetParentMainCategoriesUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<GetAdRequestsUseCase>(
      () => GetAdRequestsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator
        .registerLazySingleton<RemoveMainCategoryFromFavoritesUseCase>(
      () => RemoveMainCategoryFromFavoritesUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AddMainCategoryToFavoritesUseCase>(
      () => AddMainCategoryToFavoritesUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetMainCategoryDetailsUseCase>(
      () => GetMainCategoryDetailsUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<GetMainCategoriesUseCase>(
      () => GetMainCategoriesUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetBannerByIdUseCase>(
      () => GetBannerByIdUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetAdsUseCase>(
      () => GetAdsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetContactUsMessages>(
      () => GetContactUsMessages(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<CreateContactUsUseCase>(
      () => CreateContactUsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetAdDetailsUseCase>(
      () => GetAdDetailsUseCase(
        serviceLocator(),
      ),
    );
    // serviceLocator.registerLazySingleton<GetCompanyAdsOptionsUseCase>(
    //   () => GetCompanyAdsOptionsUseCase(
    //     serviceLocator(),
    //   ),
    // );
    serviceLocator.registerLazySingleton<GetAllPickMeUseCase>(
      () => GetAllPickMeUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetAllComeWithMeUseCase>(
      () => GetAllComeWithMeUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<RequestPickMeUseCase>(
      () => RequestPickMeUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<RequestComeWithMeUseCase>(
      () => RequestComeWithMeUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<GetAdPropertiesUsecase>(
      () => GetAdPropertiesUsecase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<CreateAdUseCase>(
      () => CreateAdUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetRelevantAdsUseCase>(
      () => GetRelevantAdsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetMyAdsUseCase>(
      () => GetMyAdsUseCase(
        serviceLocator(),
      ),
    );
    // serviceLocator.registerLazySingleton<GetSliderItemsUseCase>(
    //   () => GetSliderItemsUseCase(
    //     serviceLocator(),
    //   ),
    // );
    serviceLocator.registerLazySingleton<GetMyPickMeAdsUseCase>(
      () => GetMyPickMeAdsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetMyComeWithMeUseCase>(
      () => GetMyComeWithMeUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<DeletePickMeUseCase>(
      () => DeletePickMeUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<DeleteComeWithMeUseCase>(
      () => DeleteComeWithMeUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetMyAuctionsUseCase>(
      () => GetMyAuctionsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetMyTripJoinUseCase>(
      () => GetMyTripJoinUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetAllCountsUseCase>(
      () => GetAllCountsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetAllCountsAdsUseCase>(
      () => GetAllCountsAdsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<EditMyAdsUseCase>(
      () => EditMyAdsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<ClickUseCase>(
      () => ClickUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<FetchMyAdsByIdUseCase>(
          () => FetchMyAdsByIdUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<DeleteMyTripJoinUseCase>(
      () => DeleteMyTripJoinUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<DeleteMyInstallmentUseCase>(
      () => DeleteMyInstallmentUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetMyInstallmentUseCase>(
      () => GetMyInstallmentUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetMyOtherAdsUseCase>(
      () => GetMyOtherAdsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AcceptComeWithMeUseCase>(
      () => AcceptComeWithMeUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<CancelAdUseCase>(
      () => CancelAdUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<RejectComeWithMeUseCase>(
      () => RejectComeWithMeUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AcceptPickMeUseCase>(
      () => AcceptPickMeUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetWalletHomeUseCase>(
      () => GetWalletHomeUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<RejectPickMeUseCase>(
      () => RejectPickMeUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<ToggleSubCategoryToFavoritesUseCase>(
      () => ToggleSubCategoryToFavoritesUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<MakeAdRequestUsecase>(
      () => MakeAdRequestUsecase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<FavouriteAdUseCase>(
      () => FavouriteAdUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<RemoveFavouriteAdUseCase>(
      () => RemoveFavouriteAdUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<FilterAdUseCase>(
      () => FilterAdUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetCurrencyUseCase>(
      () => GetCurrencyUseCase(serviceLocator()),
    );
    serviceLocator.registerLazySingleton<MakeAdPremiumRequestUsecase>(
      () => MakeAdPremiumRequestUsecase(serviceLocator()),
    );

    // cubits
    serviceLocator.registerLazySingleton<GetSliderItemsUseCase>(
      () => GetSliderItemsUseCase(serviceLocator()),
    );
    serviceLocator.registerSingleton(
      SliderCubit(serviceLocator())..loadData(),
    );
    serviceLocator.registerFactory<ThumbnailsCubit>(
        () => ThumbnailsCubit(serviceLocator())..loadData());
    serviceLocator.registerFactory<MainCategoriesTapsCubit>(() =>
        MainCategoriesTapsCubit(serviceLocator(), serviceLocator())
          ..loadData());
    serviceLocator.registerFactory<MyAddsCubit>(() => MyAddsCubit(
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
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
    )
      ..loadData());

    serviceLocator.registerFactory<MainCategoriesCubit>(
      () => MainCategoriesCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );

    serviceLocator.registerFactory<AdvertisementCubit>(
      () => AdvertisementCubit(
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
      ),
    );
    // CreateAdCubit
    serviceLocator.registerFactory<CreateAdCubit>(
      () => CreateAdCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
    serviceLocator.registerFactory<AdDetailsCubit>(
      () => AdDetailsCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
    // ContactUsCubit
    serviceLocator.registerFactory<ContactUsCubit>(
      () => ContactUsCubit(
        serviceLocator(),
      ),
    );
    // AdRequestsCubit
    serviceLocator.registerFactory<AdRequestsCubit>(
      () => AdRequestsCubit(
        serviceLocator(),
      ),
    );
  }
}
