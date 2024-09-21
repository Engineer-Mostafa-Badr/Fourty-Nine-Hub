import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/localization/localization_service.dart';
import 'package:fourtyninehub/common/theme/cubit/cubit.dart';
import 'package:fourtyninehub/common/theme/cubit/states.dart';
import 'package:fourtyninehub/core/themes/dark_theme.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/accept_decline_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'core/service/cache_service.dart';
import 'core/themes/light_theme.dart';
import 'features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'routes/pages.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

void main() async {
  // SocketIoService socket = SocketIoService();

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await CacheServiceImpl.init();
  DI.execute();
  // socket.connectSocket();
  // socket.updateDriverLocation();
  //to cache gift items
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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<UserCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<AcceptDeclineTripCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<CallMessageCubit>(),
        ),
        // BlocProvider(
        //   create: (context) => serviceLocator<RiderequestCubit>(),
        // ),
        // BlocProvider(
        //   create: (context) => serviceLocator<CreateShippingRequestCubit>(),
        // ),
        // // CreateAdCubit
        // BlocProvider(
        //   create: (context) => serviceLocator<CreateAdCubit>(),
        // ),
        // //  tinder to be reviewed
        BlocProvider(
          create: (context) => serviceLocator<ChatsCubit>(),
        ),
        // BlocProvider(
        //   create: (context) => TinderViewCubit(),
        // ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: ZegoScreenUtilInit(
          designSize: const Size(750, 1334),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return BlocBuilder<ThemeCubit, ThemeStates>(
              builder: (BuildContext context, state) {
                return MaterialApp.router(
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

  // void updateDriverLocation() {
  //   log("llllllllllllllllllllllllllllllllll");
  //   io.Socket socket;
  //   socket = io.io("https://49dev.com", <String, dynamic>{
  //     'autoConnect': false,
  //     'transports': ['websocket'],
  //     'extraHeaders': {
  //       'Authorization':
  //           "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6ImRiODg0OTliLTY0YjQtNDRkYy1iNDVkLTA5ZjIwOTAzNTdmMCIsImlhdCI6MTcyNjI3MzkzMSwiZXhwIjo1NTcyNjI3MzkzMSwic3ViIjoiNjZjMzQ5ZDdhNjg0YWI0NzNmMWMxZWQ3In0.cgX_mq5Kcgj5qA0uxPzkv4BJ8kpsJDOYw8UL20f_UGY"
  //     },
  //   });
  //   socket.onConnectError(
  //     (data) {
  //       log(data.toString(), name: "lllllllllllllllllllllll");
  //     },
  //   );
  //   socket.connect();
  //   socket.onConnect(
  //     (data) {
  //       log("Connect Socket", name: "lllllllllllllllllllllll");
  //     },
  //   );
  //   socket.onError(
  //     (data) {
  //       log(data.toString(), name: "lllllllllllllllllllllll");
  //     },
  //   );
  //   var data = jsonEncode({
  //     "location": [12, 21],
  //     "driverId": "string",
  //     "subcategoryId": "string",
  //   });
  //   socket.emit("driver:location", [data]);
  //   socket.on(
  //     "driver:location",
  //     (data) {
  // log("-----------------------------------------------------", name: "lllllllllllllllllllllll");
  // log(data.toString(), name: "lllllllllllllllllllllll");
  // log("-----------------------------------------------------", name: "lllllllllllllllllllllll");
  //     },
  //   );
  // }
}

// abstract class SocketIoService {

// }

class SocketIoService {
  io.Socket? socket;

  void connectSocket() {
    if (socket != null) {
      // إذا كان هناك اتصال بالفعل، لا تقم بإنشاء اتصال جديد
      return;
    }

    socket = io.io("https://49dev.com", <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
      'extraHeaders': {
        'Authorization':
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6ImRiODg0OTliLTY0YjQtNDRkYy1iNDVkLTA5ZjIwOTAzNTdmMCIsImlhdCI6MTcyNjI3MzkzMSwiZXhwIjo1NTcyNjI3MzkzMSwic3ViIjoiNjZjMzQ5ZDdhNjg0YWI0NzNmMWMxZWQ3In0.cgX_mq5Kcgj5qA0uxPzkv4BJ8kpsJDOYw8UL20f_UGY"
      },
    });

    socket!.onConnectError(
      (data) {
        log(data.toString(), name: "lllllllllllllllllllllll");
      },
    );

    socket!.connect();

    socket!.onConnect(
      (data) {
        log("Connect Socket", name: "lllllllllllllllllllllll");
      },
    );

    socket!.onError(
      (data) {
        log(data.toString(), name: "lllllllllllllllllllllll");
      },
    );

    // _socket!.on(
    //   "driver:location",
    //   (data) {
    //     log("-----------------------------------------------------",
    //         name: "lllllllllllllllllllllll");
    //     log(data.toString(), name: "lllllllllllllllllllllll");
    //     log("-----------------------------------------------------",
    //         name: "lllllllllllllllllllllll");
    //   },
    // );
  }

  // void updateDriverLocation() {
  //   if (_socket == null) {
  //     log("Socket is not connected");
  //     return;
  //   }

  //   var data = jsonEncode({
  //     "location": [12, 21],
  //     "driverId": "string",
  //     "subcategoryId": "string",
  //   });

  //   _socket!.emit("driver:location", [data]);
  //   _socket!.on(
  //     "driver:location",
  //     (data) {
  //       log("-----------------------------------------------------",
  //           name: "lllllllllllllllllllllll");
  //       log(data.toString(), name: "lllllllllllllllllllllll");
  //       log("-----------------------------------------------------",
  //           name: "lllllllllllllllllllllll");
  //     },
  //   );
  // }
}
