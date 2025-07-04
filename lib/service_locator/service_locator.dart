import 'dart:developer';

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
import 'package:fourtyninehub/features/call/data/datasources/call_remote_datasource.dart';
import 'package:fourtyninehub/features/call/data/repositories/call_repository_impl.dart';
import 'package:fourtyninehub/features/call/domain/repositories/call_repository.dart';
import 'package:fourtyninehub/features/call/domain/usecases/get_agora_token_usecase.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/request_rider_trip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/show_offers_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/preload_cubit/preload_bloc.dart';
import 'package:fourtyninehub/features/social_media/stories/data/repositories/StoriesRpo.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/repositories/tinder_repository_impl.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/get_gifts_use_case.dart';
import 'package:fourtyninehub/helpers/call_helpers/call_helper/call_kit_helper.dart';
import 'package:fourtyninehub/helpers/call_helpers/call_helper/call_with_notification_helper.dart';
import 'package:fourtyninehub/helpers/call_helpers/notifications_helper/fcm_notification_helper.dart';
import 'package:fourtyninehub/service_locator/auth_service_locator.dart';
import 'package:fourtyninehub/service_locator/captain_share_service_locator.dart';
import 'package:fourtyninehub/service_locator/carpool_service_locator.dart';
import 'package:fourtyninehub/service_locator/club_voice_service_locator.dart';
import 'package:fourtyninehub/service_locator/competition_service_locator.dart';
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
import 'package:fourtyninehub/service_locator/ride_service_locator_updated.dart';
import 'package:fourtyninehub/service_locator/search_service_locator.dart';
import 'package:fourtyninehub/service_locator/secrets_service_locator.dart';
import 'package:fourtyninehub/service_locator/setting_service_locator.dart';
import 'package:fourtyninehub/service_locator/share_app_service_locator.dart';
import 'package:fourtyninehub/service_locator/shipping_service_locatior.dart';
import 'package:fourtyninehub/service_locator/star_service_locator.dart';
import 'package:fourtyninehub/service_locator/stories_service_locator.dart';
import 'package:fourtyninehub/service_locator/subcategories_service_locator.dart';
import 'package:fourtyninehub/service_locator/tinder_service_locator.dart';
import 'package:fourtyninehub/service_locator/transfer_money_service_locator.dart';
import 'package:fourtyninehub/service_locator/trip_join_service_locator.dart';
import 'package:fourtyninehub/service_locator/twitter_service_locator.dart';
import 'package:fourtyninehub/service_locator/wheel_service_locator.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import '../core/data/datasources/local/shared_preferences/local_storage_consumer.dart';
import '../core/localization/localization_service.dart';
import '../features/OnBoarding/Presentation/Controllers/on_boarding_cubit.dart';
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
import 'new_trip_join_service_location.dart';
import 'ride_dashboard_service_locator_updated.dart';
import 'social_service_locator.dart';
import 'subscribe_service_locator.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_socket_location_usecase.dart';

final serviceLocator = GetIt.instance;

class DI {
  static Future<void> execute({String? token}) async {
    print('executed');

    // Initialize SharedPreferences before registering it
    final sharedPreferences = await SharedPreferences.getInstance();

    // Register SharedPreferences as a singleton
    serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);

    _callFeatureInjector();
    // //preloading
    serviceLocator.registerLazySingleton(() => OnBoardingCubit());

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
    // final cred = await CacheManager.getAccessToken();
    // CliLogger.info('token from getit $cred');
    // CliLogger.info('token outside getit $token');
    // socket
    // serviceLocator.registerLazySingleton<Socket>(() => io(
    //     'https://e0d3-41-239-172-48.ngrok-free.app',
    //     OptionBuilder()
    //         .setTransports(['websocket'])
    //         .disableAutoConnect()
    //         .setExtraHeaders({'Authorization': token??cred}) // optional
    //         .build()));

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

    // Register the StoryRepository
    serviceLocator.registerLazySingleton<StoryRepository>(
      () => StoryRepository(),
    );
    serviceLocator.registerLazySingleton<GetGiftsUseCase>(
      () => GetGiftsUseCase(serviceLocator()),
    );
    // serviceLocator.registerLazySingleton<UpdateSocketLocationUseCase>(
    //   () => UpdateSocketLocationUseCase(serviceLocator()),
    // );

    // // Register the TinderRepository
    serviceLocator.registerLazySingleton<TinderRepository>(
      () => TinderRepositoryImpl(serviceLocator()),
    );
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
    // serviceLocator.registerLazySingleton<TinderViewCubit>(() => TinderViewCubit(
    //       serviceLocator(),
    //       serviceLocator(),
    //       serviceLocator(),
    //       serviceLocator(),
    //       serviceLocator(),
    //       serviceLocator(),
    //       serviceLocator(),
    //       serviceLocator(),
    //       serviceLocator(),
    //       serviceLocator(),
    //       serviceLocator(),
    //       serviceLocator(),
    //     ));
    //
    // serviceLocator.registerLazySingleton<TinderRemoteDataSource>(
    //     () => TinderRemoteDataSourceImpl(
    //           serviceLocator(),
    //         ));
    // serviceLocator.registerLazySingleton<TinderRepository>(
    //     () => TinderRepositoryImpl(serviceLocator()));
    //
    // serviceLocator
    //     .registerLazySingleton<GetUserDataUseCase>(() => GetUserDataUseCase(
    //           serviceLocator(),
    //         ));
    //
    // serviceLocator.registerLazySingleton<GetTinderFavouritesCategoryUseCase>(
    //     () => GetTinderFavouritesCategoryUseCase(
    //           serviceLocator(),
    //         ));
    //
    // serviceLocator.registerLazySingleton<GetTinderProfileUseCase>(
    //     () => GetTinderProfileUseCase(
    //           serviceLocator(),
    //         ));
    //
    // serviceLocator.registerLazySingleton<GetTinderFavouritesUseCase>(
    //     () => GetTinderFavouritesUseCase(
    //           serviceLocator(),
    //         ));
    // serviceLocator
    //     .registerLazySingleton<FetchLastSeenUseCase>(() => FetchLastSeenUseCase(
    //           serviceLocator(),
    //         ));
    //
    // serviceLocator.registerLazySingleton<SendGiftUseCase>(() => SendGiftUseCase(
    //       serviceLocator(),
    //     ));
    //
    // serviceLocator
    //     .registerLazySingleton<FetchGiftsUseCase>(() => FetchGiftsUseCase(
    //           serviceLocator(),
    //         ));
    //
    // serviceLocator.registerLazySingleton<CheckUserNearbyUseCase>(
    //     () => CheckUserNearbyUseCase(
    //           serviceLocator(),
    //         ));
    //
    // serviceLocator.registerLazySingleton<FetchSubCategoryDataUseCase>(
    //     () => FetchSubCategoryDataUseCase(
    //           serviceLocator(),
    //         ));
    //
    // serviceLocator.registerLazySingleton<UploadTinderPictureUseCase>(
    //     () => UploadTinderPictureUseCase(
    //           serviceLocator(),
    //         ));
    //
    // serviceLocator.registerLazySingleton<AddTinderFavouriteCategoryUseCase>(
    //     () => AddTinderFavouriteCategoryUseCase(
    //           serviceLocator(),
    //         ));

    // Register other dependencies...
    // serviceLocator
    //     .registerLazySingleton<TinderViewCubit>(() => TinderViewCubit());

    serviceLocator.registerLazySingleton<ApiConsumer>(
      () => BaseApiConsumer(
        serviceLocator(),
      ),
    );
    // serviceLocator.registerLazySingleton<ApiClientHelper>(
    //   () => ApiClientHelperImp(),
    // );
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
    //captain share service locator
    CaptainShareServiceLocator.execute(serviceLocator: serviceLocator);
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
    // Ride Updated
    RideServiceLocatorUpdated.execute(serviceLocator: serviceLocator);
    // Ride Updated
    RideDashboardServiceLocatorUpdated.execute(serviceLocator: serviceLocator);
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
    TinderServiceLocator.execute(serviceLocator: serviceLocator);
    CompetitionServiceLocator.execute(serviceLocator: serviceLocator);
    NewTripJoinServiceLocation.execute(serviceLocator: serviceLocator);
  }

  static Future<void> reset() async {
    log("Resetting service locator...");
    await serviceLocator.reset();
  }

  // static Future<void> registerSocket({required String? token}) async {
  //   final cred = await CacheManager.getAccessToken();
  //   CliLogger.info('token from getit $cred');
  //   CliLogger.info('token outside getit $token');
  //   // socket
  //   serviceLocator.registerFactory<Socket>(() => io(
  //       'https://e0d3-41-239-172-48.ngrok-free.app',
  //       OptionBuilder()
  //           .setTransports(['websocket'])
  //           .disableAutoConnect()
  //           .setExtraHeaders({'Authorization': token??cred}) // optional
  //           .build()));
  // }

  static void _callFeatureInjector() {
    serviceLocator.registerLazySingleton(() => SendCallCubit());
    serviceLocator.registerLazySingleton(() => CallCubit());
    serviceLocator.registerLazySingleton<FcmNotificationHelper>(
        () => FcmNotificationHelperImpl(serviceLocator()));
    serviceLocator.registerLazySingleton(() => FirebaseMessaging.instance);
    serviceLocator
        .registerLazySingleton(() => GetAgoraTokenUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<CallRepository>(
        () => CallRepositoryImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<CallRemoteDatasource>(
        () => CallRemoteDatasourceImpl());

    serviceLocator
        .registerLazySingleton<CallKitHelper>(() => CallKitHelperImpl());
    serviceLocator.registerLazySingleton<CallWithNotificationHelper>(() =>
        CallWithNotificationHelper(
            serviceLocator(), serviceLocator(), serviceLocator()));
  }
}
