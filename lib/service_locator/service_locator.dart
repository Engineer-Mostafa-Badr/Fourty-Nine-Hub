import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fourtyninehub/core/api/api_client_helper.dart';
import 'package:fourtyninehub/core/api/api_client_helper_imp.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/api/interceptors/subscription_interceptor.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/service/base_repository.dart';
import 'package:fourtyninehub/core/service/socket_service.dart';
import 'package:fourtyninehub/service_locator/auth_service_locator.dart';
import 'package:fourtyninehub/service_locator/club_voice_service_locator.dart';
import 'package:fourtyninehub/service_locator/reels_service_locator.dart';
import 'package:fourtyninehub/service_locator/ride_service_locator.dart';
import 'package:fourtyninehub/service_locator/shipping_service_locatior.dart';
import 'package:fourtyninehub/service_locator/wheel_service_locator.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../core/api/api_consumer.dart';
import '../core/local_storage/local_storage_consumer.dart';

import '../firebase_options.dart';
import 'account_service_locator.dart';
import 'auction_service_locator.dart';
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

    // api consumer
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
    // Ride Customer
    await RideServiceLocator.execute(serviceLocator: serviceLocator);
    // Fourty-Nine
    FourtyNineServiceLocator.execute(serviceLocator);

    // sokcket service
    serviceLocator.registerLazySingleton<SocketServiceContract>(
      () => SocketServiceImplementation(),
    );

    // Wheel
    WheelServiceLocator.execute(serviceLocator);
    // Reels
    ReelsServiceLocator.execute(serviceLocator);
    // food
    FoodServiceLocator.execute(serviceLocator: serviceLocator);
    // auction
    AuctionServiceLocator.execute(serviceLocator: serviceLocator);
    // installments
    InstallmentServiceLocator.execute(serviceLocator: serviceLocator);
    // health
    HealthServiceLocator.execute(serviceLocator: serviceLocator);
    // account
    AccountServiceLocator.execute(serviceLocator: serviceLocator);
    // social
    SocialServiceLocator.execute(serviceLocator: serviceLocator);
    // subscriptions
    SubscriptionServiceLocator.execute(serviceLocator: serviceLocator);
    // shipping
    ShippingServiceLocatior.execute(serviceLocator: serviceLocator);
  }
}
