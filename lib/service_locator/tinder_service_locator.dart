import 'package:fourtyninehub/features/social_media/tinder/data/data_sources/tinder_data_source.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/add_favourite_category_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/chech_user_nearby_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/delete_tinder_picture_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_favourites_category_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_favourites_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_gifts_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_last_seen_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_subcategory_data_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/get_tinder_profile_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/get_user_data_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/send_geft_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/upload_tinder_picture_use_case.dart';
import 'package:get_it/get_it.dart';

class TinderServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<TinderRemoteDataSource>(
        () => TinderRemoteDataSourceImpl(
              serviceLocator(),
            ));
    // serviceLocator.registerLazySingleton<TinderRepository>(
    //     () => TinderRepositoryImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<GetTinderProfileUseCase>(
        () => GetTinderProfileUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetTinderFavouritesUseCase>(
        () => GetTinderFavouritesUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<FetchLastSeenUseCase>(() => FetchLastSeenUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<SendGiftUseCase>(() => SendGiftUseCase(
          serviceLocator(),
        ));

    serviceLocator
        .registerLazySingleton<FetchGiftsUseCase>(() => FetchGiftsUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<CheckUserNearbyUseCase>(
        () => CheckUserNearbyUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<FetchSubCategoryDataUseCase>(
        () => FetchSubCategoryDataUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<UploadTinderPictureUseCase>(
        () => UploadTinderPictureUseCase(
              serviceLocator(),
            ));

    // serviceLocator.registerLazySingleton<GetMainCategoryDetailsUseCase>(
    //     () => GetMainCategoryDetailsUseCase(
    //           serviceLocator(),
    //         ));

    serviceLocator.registerLazySingleton<GetTinderFavouritesCategoryUseCase>(
        () => GetTinderFavouritesCategoryUseCase(
              serviceLocator(),
            ));
    serviceLocator
        .registerLazySingleton<GetUserDataUseCase>(() => GetUserDataUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<AddTinderFavouriteCategoryUseCase>(
        () => AddTinderFavouriteCategoryUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<DeleteTinderPictureUseCase>(
        () => DeleteTinderPictureUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<TinderViewCubit>(() => TinderViewCubit(
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
    ));
  }
  }
