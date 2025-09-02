import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fourtyninehub/service_locator/spot_light_service_locator.dart';
import '../core/data/datasources/json_parser.dart';
import '../core/data/datasources/local/database/local_database_data_source.dart';
import '../core/data/datasources/remote/api/api_consumer.dart';
import '../core/data/datasources/remote/api/end_points.dart';
import '../core/data/datasources/remote/api/interceptors/subscription_interceptor.dart';
import '../core/service/base_repository.dart';
import '../core/service/cache_service.dart';
import '../features/call/data/datasources/call_remote_datasource.dart';
import '../features/call/data/repositories/call_repository_impl.dart';
import '../features/call/domain/repositories/call_repository.dart';
import '../features/call/domain/usecases/get_agora_token_usecase.dart';
import '../features/call/presentation/controller/call_controller/call_cubit.dart';
import '../features/call/presentation/controller/send_call_controller.dart/send_call_cubit.dart';
import '../features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import '../features/ride/RideRequest/presentation/cubit/request_rider_trip_cubit.dart';
import '../features/ride/RideRequest/presentation/cubit/show_offers_cubit.dart';
import '../features/social_media/stories/data/repositories/StoriesRpo.dart';
import '../features/social_media/tinder/data/repositories/tinder_repository_impl.dart';
import '../features/social_media/tinder/domain/repositories/tinder_repository.dart';
import '../features/social_media/tinder/domain/use_case/get_gifts_use_case.dart';
import '../helpers/call_helpers/call_helper/call_kit_helper.dart';
import '../helpers/call_helpers/call_helper/call_with_notification_helper.dart';
import '../helpers/call_helpers/notifications_helper/fcm_notification_helper.dart';
import 'auth_service_locator.dart';
import 'captain_share_service_locator.dart';
import 'carpool_service_locator.dart';
import 'club_voice_service_locator.dart';
import 'competition_service_locator.dart';
import 'conversations_service_locator.dart';
import 'edit_food_service_locator.dart';
import 'face_book_service_locator.dart';
import 'follow_service_locator.dart';
import 'instagram_service_locator.dart';
import 'join_trip_carpool_service_locator.dart';
import 'notification_service_locator.dart';
import 'payment_service_locator.dart';
import 'privacy_service_locator.dart';
import 'quran_service_locator.dart';
import 'reels_service_locator.dart';
import 'ride_service_locator.dart';
import 'ride_service_locator_updated.dart';
import 'search_service_locator.dart';
import 'secrets_service_locator.dart';
import 'setting_service_locator.dart';
import 'share_app_service_locator.dart';
import 'shipping_service_locatior.dart';
import 'star_service_locator.dart';
import 'stories_service_locator.dart';
import 'subcategories_service_locator.dart';
import 'tinder_service_locator.dart';
import 'transfer_money_service_locator.dart';
import 'trip_join_service_locator.dart';
import 'twitter_service_locator.dart';
import 'wheel_service_locator.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sqflite/sqflite.dart';

import '../core/data/datasources/local/shared_preferences/local_storage_consumer.dart';
import '../core/localization/localization_service.dart';
import '../features/OnBoarding/Presentation/Controllers/on_boarding_cubit.dart';
import '../features/social_media/tinder/presentation/cubit/gift_cubit.dart';
import '../firebase_options.dart';
import 'account_service_locator.dart';
import 'auction_service_locator.dart';
import 'balance_service_locator.dart';
import 'chat_service_locator.dart';
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

final serviceLocator = GetIt.instance;

class DI {
  static Future<void> execute({String? token}) async {
    print('executed');

    // Clear any existing registrations to avoid duplicates
    await reset();

    // Initialize SharedPreferences before registering it
    final sharedPreferences = await SharedPreferences.getInstance();
    serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);

    // Initialize Firebase first
    await _initializeFirebase();

    // Register call feature dependencies
    _callFeatureInjector();

    // Register OnBoarding cubit
    serviceLocator.registerLazySingleton(() => OnBoardingCubit());

    // Register secure storage
    serviceLocator.registerSingleton<LocalStorageConsumer>(
      const BaseLocalStorageConsumer(
        storage: FlutterSecureStorage(),
      ),
    );

    // Initialize localization and database
    await LocalizationService.init();
    await SQFLiteDataSource.instance.initDatabase();

    // Register database
    serviceLocator.registerLazySingleton<Database>(
            () => SQFLiteDataSource.instance.database);

    // Register Dio with interceptors
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

    // Register API consumer
    serviceLocator.registerLazySingleton<ApiConsumer>(
          () => BaseApiConsumer(serviceLocator()),
    );

    // Register cache service
    serviceLocator.registerFactory<CacheService>(() => CacheServiceImpl());

    // Register base repository
    serviceLocator.registerLazySingleton(() => BaseRepository());

    // Register JSON parser
    serviceLocator.registerLazySingleton<JsonParser>(() => JsonParser());

    // Register gifts cubit
    serviceLocator.registerLazySingleton(() => GiftsCubit(serviceLocator()));

    // Register repositories
    serviceLocator.registerLazySingleton<StoryRepository>(() => StoryRepository());
    serviceLocator.registerLazySingleton<GetGiftsUseCase>(() => GetGiftsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<TinderRepository>(() => TinderRepositoryImpl(serviceLocator()));

    // Register trip-related cubits
    serviceLocator.registerLazySingleton<GetTripInfoCubit>(() => GetTripInfoCubit(repository: serviceLocator()));
    serviceLocator.registerLazySingleton<ShowOffersCubit>(() => ShowOffersCubit(repository: serviceLocator()));
    serviceLocator.registerLazySingleton<RequestRiderTripCubit>(() => RequestRiderTripCubit(repository: serviceLocator()));

    // Register all service locators with error handling
    try {
      await AuthServiceLocator.execute(serviceLocator: serviceLocator);
      await RideServiceLocator.execute(serviceLocator: serviceLocator);
      CaptainShareServiceLocator.execute(serviceLocator: serviceLocator);
      SubcategoriesServiceLocator.execute(serviceLocator: serviceLocator);
      FourtyNineServiceLocator.execute(serviceLocator);
      WheelServiceLocator.execute(serviceLocator);
      FoodServiceLocator.execute(serviceLocator: serviceLocator);
      AuctionServiceLocator.execute(serviceLocator: serviceLocator);
      InstallmentServiceLocator.execute(serviceLocator: serviceLocator);
      HealthServiceLocator.execute(serviceLocator: serviceLocator);
      AccountServiceLocator.execute(serviceLocator: serviceLocator);
      SocialServiceLocator.execute(serviceLocator: serviceLocator);
      RideServiceLocatorUpdated.execute(serviceLocator: serviceLocator);

      // Use try-catch for potentially duplicate registrations
      try {
        ConversationsServiceLocator.execute(serviceLocator: serviceLocator);
      } catch (e) {
        log('ConversationsServiceLocator already registered: $e');
      }

      RideDashboardServiceLocatorUpdated.execute(serviceLocator: serviceLocator);
      ClubVoiceServiceLocator.execute(serviceLocator: serviceLocator);
      StreamServiceLocator.execute(serviceLocator: serviceLocator);
      SubscriptionServiceLocator.execute(serviceLocator: serviceLocator);
      ShippingServiceLocatior.execute(serviceLocator: serviceLocator);
      TripJoinServiceLocator.execute(serviceLocator: serviceLocator);
      LiveServiceLocator.execute(serviceLocator: serviceLocator);
      SecretsServiceLocator.execute(serviceLocator: serviceLocator);
      await NotificationsServiceLocator.execute(serviceLocator: serviceLocator);
      InstagramServiceLocator.execute(serviceLocator: serviceLocator);
      FaceBookServiceLocator.execute(serviceLocator: serviceLocator);
      TwitterServiceLocator.execute(serviceLocator: serviceLocator);
      BalanceServiceLocator.execute(serviceLocator: serviceLocator);
      ChatServiceLocator.execute(serviceLocator: serviceLocator);
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
      SpotlightServiceLocator.execute(serviceLocator: serviceLocator);
    } catch (e) {
      log('Error registering service locators: $e');
      rethrow;
    }
  }

  static Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        name: "49-App",
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Request permissions with context available
      await FirebaseMessaging.instance.requestPermission(
        announcement: true,
        carPlay: true,
        criticalAlert: true,
      );

      // Subscribe to topic
      FirebaseMessaging.instance.subscribeToTopic('all');

      log('Firebase initialized successfully');
    } catch (e) {
      log('Firebase initialization error: $e');
      // Don't rethrow - allow app to continue without Firebase
    }
  }

  static Future<void> reset() async {
    if (serviceLocator.isRegistered<SharedPreferences>()) {
      log("Resetting service locator...");
      await serviceLocator.reset();
    }
  }

  static void _callFeatureInjector() {
    // Register call-related dependencies
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