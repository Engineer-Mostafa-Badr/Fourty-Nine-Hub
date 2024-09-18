import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/theme/cubit/cubit.dart';
import 'package:fourtyninehub/common/theme/cubit/states.dart';
import 'package:fourtyninehub/core/data/datasources/remote/socket/socket_data_source.dart';
import 'package:fourtyninehub/core/localization/localization_service.dart';
import 'package:fourtyninehub/core/themes/dark_theme.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/firebase_notfications_cubit/firebase_notfications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_app_notifications/get_app_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_services_notifications/get_services_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_social_notifications/get_social_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'core/service/cache_service.dart';
import 'core/themes/light_theme.dart';
import 'features/account_taps/wallet/presentation/cubit/wallet_cubit.dart';
import 'features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'routes/pages.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:firebase_messaging/firebase_messaging.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
   IO.Socket? _socket;

  SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  Future<void> initialize() async {
  if(_socket == null) {
    final token = await TokenManager.getAccessToken();
    // socket
    _socket = IO.io(
        'https://49dev.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'authorization': token}) // optional
            .build());}
    if(!_socket!.connected){
      _socket!.connect();
    }

    _socket!.onConnect((_) {
      print('Connected to the socket server');
    });

    _socket!.on(SocketIOListeners.newMessageFromOther, (data) {
      _socket!.emit(SocketIOEvents.markMessageAsDelivered,
          jsonEncode({"chatId": jsonDecode(data)['chatId']}));
    });

    _socket!.onDisconnect((_) {
      print('Disconnected from the socket server');
    });

  }

  void emitNotification(Map<String, dynamic> notification) {
    // if (_socket.connected) {
    // } else {
    //   print('Socket not connected, unable to emit event');
    // }
  }
}

class NotificationService {

  Future<void> initialize() async {
    // Initialize the socket service

    // Listen for foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      saveNotificationAndEmit(message);

    });

    // Listen for background notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> saveNotificationAndEmit(RemoteMessage message) async {
    final SocketService socketService = SocketService();
    await socketService.initialize();
    final Map<String, dynamic> notification = {
      'title': message.notification?.title ?? 'No title',
      'body': message.notification?.body ?? 'No body',
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Emit to socket
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final SocketService socketService = SocketService();
    await socketService.initialize();
  final Map<String, dynamic> notification = {
    'title': message.notification?.title ?? 'No title',
    'body': message.notification?.body ?? 'No body',
    'timestamp': DateTime.now().toIso8601String(),
  };

  // Save to SQLite

  // Emit to socket
  // socketService.emitNotification(notification);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheServiceImpl.init();
  await DI.execute();
  NotificationService _notificationService = NotificationService();
  // await _notificationService.initialize();
  //to cache gift items
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _firebaseMessagingBackgroundHandler(message);
  });
  // ZegoGiftManager().cache.cache(giftItemList);

  //Admob.initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    LocalizationService.rootWidget(
      // child: DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => const MyApp(),
      // ),
      child: Phoenix(child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<UserCubit>(),
        ),
        BlocProvider(
          create: (BuildContext context) => serviceLocator<WalletCubit>(),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              serviceLocator<MainCategoriesCubit>()..loadData(),
        ),
        // BlocProvider(
        //   create: (context) => serviceLocator<RiderequestCubit>(),
        // ),
        // BlocProvider(
        //   create: (context) => serviceLocator<CreateShippingRequestCubit>(),
        // ),
        // //  tinder to be reviewed
        // BlocProvider(
        //   create: (context) => TinderViewCubit(),
        // ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<FirebaseNotficationsCubit>(
          create: (context) => FirebaseNotficationsCubit(serviceLocator()),
        ),
        BlocProvider<GetUnreadNotificationsCountCubit>(
          create: (context) => GetUnreadNotificationsCountCubit(
            getUnreadNotificationsCountUseCase: serviceLocator(),
          )..getUnreadNotificationsCount(),
        ),
        BlocProvider<GetAppNotificationsCubit>(
          create: (context) => GetAppNotificationsCubit(
            getNotficationsUseCase: serviceLocator(),
            context: context,
          ),
        ),
        BlocProvider<GetSocialNotificationsCubit>(
          create: (context) => GetSocialNotificationsCubit(
            getNotficationsUseCase: serviceLocator(),
            context: context,
          ),
        ),
        BlocProvider<GetServicesNotificationsCubit>(
          create: (context) => GetServicesNotificationsCubit(
            getNotficationsUseCase: serviceLocator(),
            context: context,
          ),
        ),
        BlocProvider<NotificationSocketIoCubit>(
          create: (context) => NotificationSocketIoCubit(
            context: context,
            notificationListenerUseCase: serviceLocator(),
          )..notificationListener(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(750, 1334),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return BlocBuilder<ThemeCubit, ThemeStates>(
              builder: (BuildContext context, state) {
                return MaterialApp.router(
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: child!,
                    );
                  },
                  themeMode: context.read<ThemeCubit>().isDarkTheme
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  theme: lightTheme(),
                  darkTheme: darkTheme(),
                  title: '49',
                  debugShowCheckedModeBanner: false,
                  routerConfig: AppPages.router,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  // for device preview package
                  // builder: DevicePreview.appBuilder,
                );
              },
            );
          }),
    );
  }
}
