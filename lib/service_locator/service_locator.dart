// import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:fourtyninehub/core/api/api_client_helper.dart';
// import 'package:fourtyninehub/core/api/api_client_helper_imp.dart';
// import 'package:fourtyninehub/core/api/end_points.dart';
// import 'package:fourtyninehub/core/api/interceptors/subscription_interceptor.dart';
// import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
// import 'package:fourtyninehub/core/service/base_repository.dart';
// import 'package:fourtyninehub/core/service/socket_service.dart';
// import 'package:fourtyninehub/features/social_media/reels/data/repositories/reels_repository_impl.dart';
// import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// import 'package:fourtyninehub/service_locator/auth_service_locator.dart';
// import 'package:fourtyninehub/service_locator/club_voice_service_locator.dart';
// import 'package:fourtyninehub/service_locator/ride_service_locator.dart';
// import 'package:fourtyninehub/service_locator/shipping_service_locatior.dart';
// import 'package:fourtyninehub/service_locator/subcategories_service_locator.dart';
// import 'package:fourtyninehub/service_locator/wheel_service_locator.dart';
// import 'package:get_it/get_it.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
//
// import '../core/api/api_consumer.dart';
// import '../core/local_storage/local_storage_consumer.dart';
//
// import '../core/localization/localization_service.dart';
// import '../firebase_options.dart';
// import 'account_service_locator.dart';
// import 'auction_service_locator.dart';
// import 'food_service_locator.dart';
// import 'fourty_nine_service_locator.dart';
// import 'health_service_locator.dart';
// import 'installment_service_locator.dart';
// import 'meeting_service_locator.dart';
// import 'social_service_locator.dart';
// import 'subscribe_service_locator.dart';
//
// final serviceLocator = GetIt.instance;
//
// class DI {
//   static Future<void> execute() async {
//     await Firebase.initializeApp(
//       name: "49-App",
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//
//     await FirebaseMessaging.instance.requestPermission(
//       announcement: true,
//       carPlay: true,
//       criticalAlert: true,
//     );
//     FirebaseMessaging.instance.subscribeToTopic('all');
//     serviceLocator.registerSingleton<LocalStorageConsumer>(
//       const BaseLocalStorageConsumer(
//         storage: FlutterSecureStorage(),
//       ),
//     );
//
//     await LocalizationService.init();
//
//     // dio
//     serviceLocator.registerLazySingleton<Dio>(
//       () => Dio(
//         BaseOptions(
//           baseUrl: kReleaseMode
//               ? EndPoints.productionBaseUrl
//               : EndPoints.developmentBaseUrl,
//           connectTimeout: const Duration(seconds: 60),
//           headers: {
//             'Accept': 'application/json',
//             'Content-Type': 'application/json',
//           },
//         ),
//       )..interceptors.addAll([
//           SubscriptionInterceptor(),
//           if (kDebugMode)
//             PrettyDioLogger(
//               requestHeader: true,
//               requestBody: true,
//               responseBody: true,
//               responseHeader: false,
//               error: true,
//               compact: true,
//               maxWidth: 90,
//             )
//         ]),
//     );
//
// //tinder getIt register
//     serviceLocator
//         .registerLazySingleton<TinderViewCubit>(() => TinderViewCubit());
//     serviceLocator.registerLazySingleton<ReelsCubit>(
//         () => ReelsCubit(repository: ReelsRepository()));
//
//     // api consumer
//
//     serviceLocator.registerLazySingleton<ApiConsumer>(
//       () => BaseApiConsumer(
//         serviceLocator(),
//         serviceLocator(),
//       ),
//     );
//     serviceLocator.registerLazySingleton<ApiClientHelper>(
//       () => ApiClientHelperImp(),
//     );
//     // base repo
//     serviceLocator.registerLazySingleton(
//       () => BaseRepository(),
//     );
//     // json parser
//     serviceLocator.registerLazySingleton<JsonParser>(
//       () => JsonParser(),
//     );
//     // auth service locator
//     await AuthServiceLocator.execute(serviceLocator: serviceLocator);
//     // Ride Customer
//     await RideServiceLocator.execute(serviceLocator: serviceLocator);
//     // Subcategories
//     SubcategoriesServiceLocator.execute(serviceLocator: serviceLocator);
//     // Fourty-Nine
//     FourtyNineServiceLocator.execute(serviceLocator);
//
//     // sokcket service
//     serviceLocator.registerLazySingleton<SocketServiceContract>(
//       () => SocketServiceImplementation(),
//     );
//
//     // Wheel
//     WheelServiceLocator.execute(serviceLocator);
//     // Reels
//     // ReelsServiceLocator.execute(serviceLocator);
//     // food
//     FoodServiceLocator.execute(serviceLocator: serviceLocator);
//     // auction
//     AuctionServiceLocator.execute(serviceLocator: serviceLocator);
//     // installments
//     InstallmentServiceLocator.execute(serviceLocator: serviceLocator);
//     // health
//     HealthServiceLocator.execute(serviceLocator: serviceLocator);
//     // account
//     AccountServiceLocator.execute(serviceLocator: serviceLocator);
//     // social
//     SocialServiceLocator.execute(serviceLocator: serviceLocator);
//     //club voice
//     ClubVoiceServiceLocator.execute(serviceLocator: serviceLocator);
//     //meeting
//     MeetingServiceLocator.execute(serviceLocator: serviceLocator);
//     // subscriptions
//     SubscriptionServiceLocator.execute(serviceLocator: serviceLocator);
//     // shipping
//     ShippingServiceLocatior.execute(serviceLocator: serviceLocator);
//   }
// }

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/data/datasources/local/database/local_database_data_source.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_client_helper.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_client_helper_imp.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/interceptors/subscription_interceptor.dart';
import 'package:fourtyninehub/core/data/datasources/remote/socket/socket_data_source.dart';
import 'package:fourtyninehub/core/service/base_repository.dart';
import 'package:fourtyninehub/core/utils/api_service.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/competition/data/repository/competition_repo_impl.dart';
import 'package:fourtyninehub/features/social_media/reels/data/repositories/reels_repository_impl.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/data/repositories/StoriesRpo.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/repo/tinder_repo.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/service_locator/auth_service_locator.dart';
import 'package:fourtyninehub/service_locator/club_voice_service_locator.dart';
import 'package:fourtyninehub/service_locator/face_book_service_locator.dart';
import 'package:fourtyninehub/service_locator/instagram_service_locator.dart';
import 'package:fourtyninehub/service_locator/notification_service_locator.dart';
import 'package:fourtyninehub/service_locator/payment_service_locator.dart';
import 'package:fourtyninehub/service_locator/ride_service_locator.dart';
import 'package:fourtyninehub/service_locator/shipping_service_locatior.dart';
import 'package:fourtyninehub/service_locator/subcategories_service_locator.dart';
import 'package:fourtyninehub/service_locator/trip_join_service_locator.dart';
import 'package:fourtyninehub/service_locator/twitter_service_locator.dart';
import 'package:fourtyninehub/service_locator/wheel_service_locator.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:sqflite/sqflite.dart';

import '../core/data/datasources/local/shared_preferences/local_storage_consumer.dart';
import '../core/localization/localization_service.dart';
import '../firebase_options.dart';
import 'account_service_locator.dart';
import 'auction_service_locator.dart';
import 'balance_service_locator.dart';
import 'company_add_service_locator.dart';
import 'food_service_locator.dart';
import 'fourty_nine_service_locator.dart';
import 'health_service_locator.dart';
import 'installment_service_locator.dart';
import 'meeting_service_locator.dart';
import 'social_service_locator.dart';
import 'subscribe_service_locator.dart';

final serviceLocator = GetIt.instance;

class DI {
  static Future<void> execute() async {
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

    // database
    serviceLocator.registerLazySingleton<Database>(() => SQFLiteDataSource.instance.database);

    // dio
    serviceLocator.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: kReleaseMode ? EndPoints.productionBaseUrl : EndPoints.developmentBaseUrl,
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

//tinder getIt register
    serviceLocator.registerLazySingleton<CompetitionRepoImpl>(
      () => CompetitionRepoImpl(ApiService(Dio())),
    );
    // serviceLocator.registerLazySingleton<CompanyAdvertiseRepoImpl>(() => CompanyAdvertiseRepoImpl(ApiService(Dio())),);
    // Register the ReelsRepository
    serviceLocator.registerLazySingleton<ReelsRepository>(
      () => ReelsRepository(),
    );

    // Register the ReelsCubit
    serviceLocator.registerFactory<ReelsCubit>(
      () => ReelsCubit(repository: serviceLocator<ReelsRepository>()),
    );

    // Register the StoryRepository
    serviceLocator.registerLazySingleton<StoryRepository>(
      () => StoryRepository(),
    );

    // Register the StoryCubit
    serviceLocator.registerFactory<StoryCubit>(
      () => StoryCubit(serviceLocator<StoryRepository>()),
    );
    //
    // // Register the TinderRepository
    // serviceLocator.registerLazySingleton<TinderRepository>(
    //   () => TinderRepository(),
    // );
    //
    // // Register the TinderCubit
    // serviceLocator.registerFactory<TinderViewCubit>(
    //   () =>
    //       TinderViewCubit(tinderRepository: serviceLocator<TinderRepository>()),
    // );

    // Register the TinderRepository as a singleton
    serviceLocator.registerLazySingleton<TinderRepository>(() => TinderRepository());

    // Register the TinderViewCubit and inject the TinderRepository dependency
    serviceLocator
        .registerFactory<TinderViewCubit>(() => TinderViewCubit(tinderRepository: serviceLocator<TinderRepository>()));

    // Register other dependencies...
    // serviceLocator
    //     .registerLazySingleton<TinderViewCubit>(() => TinderViewCubit());

    serviceLocator.registerLazySingleton<ApiConsumer>(
      () => BaseApiConsumer(
        serviceLocator(),
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<ApiClientHelper>(
      () => ApiClientHelperImp(),
    );

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
    //  final token = await TokenManager.getAccessToken();
    final String? token = await serviceLocator<GetTokensUseCase>()
        . //
        call(const NoParams())
        . //
        then((value) => value.fold((l) => null, (r) => r?.accessToken));
    // socket
    serviceLocator.registerLazySingleton<Socket>(() => io(
        'https://49dev.com',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'authorization': token}) // optional
            .build()));
    // Ride Customer
    await RideServiceLocator.execute(serviceLocator: serviceLocator);
    // Subcategories
    SubcategoriesServiceLocator.execute(serviceLocator: serviceLocator);
    // Fourty-Nine
    FourtyNineServiceLocator.execute(serviceLocator);

    // Socket service
    serviceLocator.registerLazySingleton<ChatSocketServiceContract>(
      () => ChatSocketServiceImplementation(),
    );

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
    // Meeting
    MeetingServiceLocator.execute(serviceLocator: serviceLocator);
    // Subscriptions
    SubscriptionServiceLocator.execute(serviceLocator: serviceLocator);
    // Shipping
    ShippingServiceLocatior.execute(serviceLocator: serviceLocator);
    // trip join
    TripJoinServiceLocator.execute(serviceLocator: serviceLocator);
    // notifications
    await NotificationsServiceLocator.execute(serviceLocator: serviceLocator);
    InstagramServiceLocator.execute(serviceLocator: serviceLocator);
    FaceBookServiceLocator.execute(serviceLocator: serviceLocator);
    TwitterServiceLocator.execute(serviceLocator: serviceLocator);
    BalanceServiceLocator.execute(serviceLocator: serviceLocator);
    CompanyAddServiceLocator.execute(serviceLocator: serviceLocator);
    PaymentProviderServiceLocator.execute(serviceLocator: serviceLocator);
  }
}
