import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/theme/cubit/cubit.dart';
import 'package:fourtyninehub/common/theme/cubit/states.dart';
import 'package:fourtyninehub/core/localization/localization_service.dart';
import 'package:fourtyninehub/core/themes/dark_theme.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/firebase_notfications_cubit/firebase_notfications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_app_notifications/get_app_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_services_notifications/get_services_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_social_notifications/get_social_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/components/screen_util/core/screenutil_init.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import 'core/service/cache_service.dart';
import 'core/themes/light_theme.dart';
import 'features/account_taps/wallet/presentation/cubit/wallet_cubit.dart';
import 'features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'routes/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheServiceImpl.init();
  await DI.execute();
  //to cache gift items
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
      child: const MyApp(),
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
          create: (BuildContext context) =>serviceLocator<WalletCubit>(),

        ),
        // BlocProvider(
        //   create: (context) => serviceLocator<RiderequestCubit>(),
        // ),
        // BlocProvider(
        //   create: (context) => serviceLocator<CreateShippingRequestCubit>(),
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
