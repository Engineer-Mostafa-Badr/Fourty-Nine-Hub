import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
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
import 'package:fourtyninehub/service_locator/service_locator.dart';

import 'core/service/background_service.dart';
import 'core/service/cache_service.dart';
import 'core/themes/light_theme.dart';
import 'features/account_taps/wallet/presentation/cubit/wallet_cubit.dart';
import 'features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'firebase_options.dart';
import 'routes/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheServiceImpl.init();
  await DI.execute();

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
          )..notificationListener(languageCode: 'en'),
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
