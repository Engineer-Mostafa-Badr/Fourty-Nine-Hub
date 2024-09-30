import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/theme/cubit/cubit.dart';
import 'package:fourtyninehub/common/theme/cubit/states.dart';
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
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/show_offers_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'core/service/background_service.dart';
import 'core/service/cache_service.dart';
import 'core/themes/light_theme.dart';
import 'features/account_taps/wallet/presentation/cubit/wallet_cubit.dart';
import 'features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'routes/pages.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  // SocketIoService socket = SocketIoService();

  WidgetsFlutterBinding.ensureInitialized();

  await CacheServiceImpl.init();
  await DI.execute();

  // ZegoGiftManager().cache.cache(giftItemList);

  // Admob.initialize();

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _startWebSocketService() async {
    final token = await TokenManager.getAccessToken();
    BackgroundService.startWebSocketService(token);
  }

  @override
  void initState() {
    super.initState();
    _startWebSocketService();
  }

  @override
  Widget build(BuildContext context) {
    // updateDriverLocation();
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
        BlocProvider(
                        create: (context) =>
                            ShowOffersCubit(repository: serviceLocator()),
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
                );
              },
            );
          }),
    );
  }

  void updateDriverLocation() {
    log("llllllllllllllllllllllllllllllllll");
    io.Socket socket;
    socket = io.io("https://49dev.com", <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
      'extraHeaders': {
        'Authorization':
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjA1ZjdiZmQxLTU5OTAtNGRlNi04ZGNkLWY3NTMyOTIzZjgyOCIsImlhdCI6MTcyNzA1MzMzNywiZXhwIjo1NTcyNzA1MzMzNywic3ViIjoiNjZjMzQ5ZDdhNjg0YWI0NzNmMWMxZWQ3In0.GY970EmMJvtySdwqMnnAemXxPWVxQxEJm0IwGPtNYe4"
      },
    });
    socket.onConnectError(
      (error) {
        log("Connection Error: $error");
      },
    );
    socket.connect();
    socket.onConnect(
      (data) {
        log("Connect Socket", name: "onConnect");
      },
    );
    socket.onError(
      (data) {
        log(data.toString(), name: "onError");
      },
    );
    var data = jsonEncode({
      "location": [30.033333, 31.233334],
      "subcategoryId": "62c8ba9f8e28a58a3edf57eb",
      "tripId": "66f0e278099d41ac6a96598d"
    });
    socket.emit("drivers:nearBy", [data]);
    socket.on(
      "drivers:near",
      (data) {
        log("-----------------------------------------------------",
            name: "lllllllllllllllllllllll");
        log(data.toString(), name: "lllllllllllllllllllllll");
        log("-----------------------------------------------------",
            name: "lllllllllllllllllllllll");
      },
    );
  }
}

// abstract class SocketIoService {

// }

// class SocketIoService {
//   io.Socket? socket;

//   void connectSocket() {
//     if (socket != null) {
//       // إذا كان هناك اتصال بالفعل، لا تقم بإنشاء اتصال جديد
//       return;
//     }

//     socket = io.io("https://49dev.com", <String, dynamic>{
//       'autoConnect': false,
//       'transports': ['websocket'],
//       'extraHeaders': {
//         'Authorization':
//             "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6ImRiODg0OTliLTY0YjQtNDRkYy1iNDVkLTA5ZjIwOTAzNTdmMCIsImlhdCI6MTcyNjI3MzkzMSwiZXhwIjo1NTcyNjI3MzkzMSwic3ViIjoiNjZjMzQ5ZDdhNjg0YWI0NzNmMWMxZWQ3In0.cgX_mq5Kcgj5qA0uxPzkv4BJ8kpsJDOYw8UL20f_UGY"
//       },
//     });

//     socket!.onConnectError(
//       (data) {
//         log(data.toString(), name: "lllllllllllllllllllllll");
//       },
//     );

//     socket!.connect();

//     socket!.onConnect(
//       (data) {
//         log("Connect Socket", name: "lllllllllllllllllllllll");
//       },
//     );

//     socket!.onError(
//       (data) {
//         log(data.toString(), name: "lllllllllllllllllllllll");
//       },
//     );

//     // _socket!.on(
//     //   "driver:location",
//     //   (data) {
//     //     log("-----------------------------------------------------",
//     //         name: "lllllllllllllllllllllll");
//     //     log(data.toString(), name: "lllllllllllllllllllllll");
//     //     log("-----------------------------------------------------",
//     //         name: "lllllllllllllllllllllll");
//     //   },
//     // );
//   }

//   // void updateDriverLocation() {
//   //   if (_socket == null) {
//   //     log("Socket is not connected");
//   //     return;
//   //   }

//   //   var data = jsonEncode({
//   //     "location": [12, 21],
//   //     "driverId": "string",
//   //     "subcategoryId": "string",
//   //   });

//   //   _socket!.emit("driver:location", [data]);
//   //   _socket!.on(
//   //     "driver:location",
//   //     (data) {
//   //       log("-----------------------------------------------------",
//   //           name: "lllllllllllllllllllllll");
//   //       log(data.toString(), name: "lllllllllllllllllllllll");
//   //       log("-----------------------------------------------------",
//   //           name: "lllllllllllllllllllllll");
//   //     },
//   //   );
//   // }
// }
