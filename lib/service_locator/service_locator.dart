import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/data/datasources/local/database/local_database_data_source.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/interceptors/subscription_interceptor.dart';
import 'package:fourtyninehub/core/service/base_repository.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/core/utils/api_service.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/competition/data/repository/competition_repo_impl.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/request_rider_trip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/show_offers_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/preload_cubit/preload_bloc.dart';
import 'package:fourtyninehub/features/social_media/stories/data/repositories/StoriesRpo.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/data_sources/tinder_data_source.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/repositories/tinder_repository_impl.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/add_favourite_category_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/chech_user_nearby_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_favourites_category_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_favourites_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_gifts_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_last_seen_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_subcategory_data_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/get_gifts_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/get_tinder_profile_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/get_user_data_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/send_geft_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/upload_tinder_picture_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/service_locator/auth_service_locator.dart';
import 'package:fourtyninehub/service_locator/carpool_service_locator.dart';
import 'package:fourtyninehub/service_locator/club_voice_service_locator.dart';
import 'package:fourtyninehub/service_locator/edit_food_service_locator.dart';
import 'package:fourtyninehub/service_locator/face_book_service_locator.dart';
import 'package:fourtyninehub/service_locator/follow_service_locator.dart';
import 'package:fourtyninehub/service_locator/instagram_service_locator.dart';
import 'package:fourtyninehub/service_locator/join_trip_carpool_service_locator.dart';
import 'package:fourtyninehub/service_locator/notification_service_locator.dart';
import 'package:fourtyninehub/service_locator/payment_service_locator.dart';
import 'package:fourtyninehub/service_locator/privacy_service_locator.dart';
import 'package:fourtyninehub/service_locator/quran_service_locator.dart';
import 'package:fourtyninehub/service_locator/reels_service_locator.dart';
import 'package:fourtyninehub/service_locator/ride_service_locator.dart';
import 'package:fourtyninehub/service_locator/search_service_locator.dart';
import 'package:fourtyninehub/service_locator/secrets_service_locator.dart';
import 'package:fourtyninehub/service_locator/setting_service_locator.dart';
import 'package:fourtyninehub/service_locator/share_app_service_locator.dart';
import 'package:fourtyninehub/service_locator/shipping_service_locatior.dart';
import 'package:fourtyninehub/service_locator/star_service_locator.dart';
import 'package:fourtyninehub/service_locator/stories_service_locator.dart';
import 'package:fourtyninehub/service_locator/subcategories_service_locator.dart';
import 'package:fourtyninehub/service_locator/transfer_money_service_locator.dart';
import 'package:fourtyninehub/service_locator/trip_join_service_locator.dart';
import 'package:fourtyninehub/service_locator/twitter_service_locator.dart';
import 'package:fourtyninehub/service_locator/wheel_service_locator.dart';
import 'package:get_it/get_it.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:sqflite/sqflite.dart';

import '../core/data/datasources/local/shared_preferences/local_storage_consumer.dart';
import '../core/localization/localization_service.dart';
import '../features/social_media/tinder/presentation/cubit/gift_cubit.dart';
import '../firebase_options.dart';
import 'account_service_locator.dart';
import 'auction_service_locator.dart';
import 'balance_service_locator.dart';
import 'chance_service_locator.dart';
import 'company_add_service_locator.dart';
import 'custom_page_service_locator.dart';
import 'food_service_locator.dart';
import 'fourty_nine_service_locator.dart';
import 'health_service_locator.dart';
import 'installment_service_locator.dart';
import 'live_service_locator.dart';
import 'meeting_service_locator.dart';
import 'social_service_locator.dart';
import 'subscribe_service_locator.dart';

final serviceLocator = GetIt.instance;

class DI {
  static Future<void> execute({String? token}) async {
    print('executed');
    // //preloading
    serviceLocator.registerLazySingleton(() => PreloadBloc());
    serviceLocator.registerLazySingleton<ReelsCubit>(
      () => ReelsCubit(
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
          serviceLocator()),
    );

    await Firebase.initializeApp(
      name: "49-App",
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
    FirebaseMessaging.instance.subscribeToTopic('all');
    serviceLocator.registerSingleton<LocalStorageConsumer>(
      const BaseLocalStorageConsumer(
        storage: FlutterSecureStorage(),
      ),
    );

    await LocalizationService.init();
    await SQFLiteDataSource.instance.initDatabase();
    final cred = await CacheManager.getAccessToken();
    CliLogger.info('token from getit $cred');
    CliLogger.info('token outside getit $token');
    // socket
    serviceLocator.registerLazySingleton<Socket>(() => io(
        'https://49dev.com',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'Authorization': token ?? cred}) // optional
            .build()));
    // database
    serviceLocator.registerLazySingleton<Database>(
        () => SQFLiteDataSource.instance.database);

    // dio
    serviceLocator.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: kReleaseMode
              ? EndPoints.productionBaseUrl
              : EndPoints.developmentBaseUrl,
          connectTimeout: const Duration(seconds: 60),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      )..interceptors.addAll([
          SubscriptionInterceptor(),
          if (kDebugMode)
            PrettyDioLogger(
              requestHeader: true,
              requestBody: true,
              responseBody: true,
              responseHeader: false,
              error: true,
              compact: true,
              maxWidth: 90,
            )
        ]),
    );
    //for gifts
    serviceLocator.registerLazySingleton(() => GiftsCubit(serviceLocator()));
//tinder getIt register
    serviceLocator.registerLazySingleton<CompetitionRepoImpl>(
      () => CompetitionRepoImpl(ApiService(Dio())),
    );
    // serviceLocator.registerLazySingleton<CompanyAdvertiseRepoImpl>(() => CompanyAdvertiseRepoImpl(ApiService(Dio())),);

    // Register the StoryRepository
    serviceLocator.registerLazySingleton<StoryRepository>(
      () => StoryRepository(),
    );
    serviceLocator.registerLazySingleton<GetGiftsUseCase>(
      () => GetGiftsUseCase(serviceLocator()),
    );

    // serviceLocator
    //     .registerFactory<SliderCubit>(() => SliderCubit(serviceLocator()));
    //
    // // Register the TinderRepository
    serviceLocator.registerLazySingleton<GetTripInfoCubit>(
      () => GetTripInfoCubit(repository: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<ShowOffersCubit>(
      () => ShowOffersCubit(repository: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<RequestRiderTripCubit>(
      () => RequestRiderTripCubit(repository: serviceLocator()),
    );

    //
    // // Register the TinderCubit
    serviceLocator.registerLazySingleton<TinderViewCubit>(() => TinderViewCubit(
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

    serviceLocator.registerLazySingleton<TinderRemoteDataSource>(
        () => TinderRemoteDataSourceImpl(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<TinderRepository>(
        () => TinderRepositoryImpl(serviceLocator()));

    serviceLocator
        .registerLazySingleton<GetUserDataUseCase>(() => GetUserDataUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<GetTinderFavouritesCategoryUseCase>(
        () => GetTinderFavouritesCategoryUseCase(
              serviceLocator(),
            ));

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

    serviceLocator.registerLazySingleton<AddTinderFavouriteCategoryUseCase>(
        () => AddTinderFavouriteCategoryUseCase(
              serviceLocator(),
            ));

    // Register other dependencies...
    // serviceLocator
    //     .registerLazySingleton<TinderViewCubit>(() => TinderViewCubit());

    serviceLocator.registerLazySingleton<ApiConsumer>(
      () => BaseApiConsumer(
        serviceLocator(),
        serviceLocator(),
      ),
    );
    //cacheService
    serviceLocator.registerFactory<CacheService>(() => CacheServiceImpl());
    // base repo
    serviceLocator.registerLazySingleton(
      () => BaseRepository(),
    );
    // json parser
    serviceLocator.registerLazySingleton<JsonParser>(
      () => JsonParser(),
    );

    // auth service locator
    await AuthServiceLocator.execute(serviceLocator: serviceLocator);
    // Ride Customer
    await RideServiceLocator.execute(serviceLocator: serviceLocator);
    //Notification
    // await NotificationServiceLocator.execute(serviceLocator: serviceLocator);
    // Subcategories
    SubcategoriesServiceLocator.execute(serviceLocator: serviceLocator);
    // Fourty-Nine
    FourtyNineServiceLocator.execute(serviceLocator);

    // Wheel
    WheelServiceLocator.execute(serviceLocator);
    // Food
    FoodServiceLocator.execute(serviceLocator: serviceLocator);
    // Auction
    AuctionServiceLocator.execute(serviceLocator: serviceLocator);
    // Installments
    InstallmentServiceLocator.execute(serviceLocator: serviceLocator);
    // Health
    HealthServiceLocator.execute(serviceLocator: serviceLocator);
    // Account
    AccountServiceLocator.execute(serviceLocator: serviceLocator);
    // Social
    SocialServiceLocator.execute(serviceLocator: serviceLocator);
    // Club Voice
    ClubVoiceServiceLocator.execute(serviceLocator: serviceLocator);
    // Stream
    StreamServiceLocator.execute(serviceLocator: serviceLocator);
    // Subscriptions
    SubscriptionServiceLocator.execute(serviceLocator: serviceLocator);
    // Shipping
    ShippingServiceLocatior.execute(serviceLocator: serviceLocator);
    // trip join
    TripJoinServiceLocator.execute(serviceLocator: serviceLocator);
    //live
    LiveServiceLocator.execute(serviceLocator: serviceLocator);
    //secrets
    SecretsServiceLocator.execute(serviceLocator: serviceLocator);
    // notifications
    await NotificationsServiceLocator.execute(serviceLocator: serviceLocator);
    InstagramServiceLocator.execute(serviceLocator: serviceLocator);
    FaceBookServiceLocator.execute(serviceLocator: serviceLocator);
    TwitterServiceLocator.execute(serviceLocator: serviceLocator);
    BalanceServiceLocator.execute(serviceLocator: serviceLocator);
    CompanyAddServiceLocator.execute(serviceLocator: serviceLocator);
    PrivacyServiceLocator.execute(serviceLocator: serviceLocator);
    SettingServiceLocator.execute(serviceLocator: serviceLocator);
    PaymentProviderServiceLocator.execute(serviceLocator: serviceLocator);
    TransferMoneyServiceLocator.execute(serviceLocator: serviceLocator);
    CustomPageServiceLocator.execute(serviceLocator: serviceLocator);
    CarpoolServiceLocator.execute(serviceLocator: serviceLocator);
    ChanceServiceLocator.execute(serviceLocator: serviceLocator);
    SearchServiceLocator.execute(serviceLocator: serviceLocator);
    EditFoodServiceLocator.execute(serviceLocator: serviceLocator);
    JoinTripCarpoolServiceLocator.execute(serviceLocator: serviceLocator);
    ReelsServiceLocator.execute(serviceLocator: serviceLocator);
    StarServiceLocator.execute(serviceLocator: serviceLocator);
    QuranServiceLocator.execute(serviceLocator: serviceLocator);
    StoriesServiceLocator.execute(serviceLocator: serviceLocator);
    ShareAppServiceLocator.execute(serviceLocator: serviceLocator);
    FollowServiceLocator.execute(serviceLocator: serviceLocator);
  }

  static Future<void> reset() async {
    await serviceLocator.reset();
  }
}
