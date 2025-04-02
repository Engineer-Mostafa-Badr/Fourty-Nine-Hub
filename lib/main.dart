import 'package:device_preview/device_preview.dart';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_callkit_incoming_yoer/flutter_callkit_incoming.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/theme/cubit/cubit.dart';
import 'package:fourtyninehub/common/theme/cubit/states.dart';
import 'package:fourtyninehub/core/localization/localization_service.dart';
import 'package:fourtyninehub/core/themes/dark_theme.dart';
import 'package:fourtyninehub/core/utils/location_tracker.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/pages/whatsapp_screen.dart';
import 'package:fourtyninehub/features/carpool/join_trip/presentation/cubits/cubit/join_trip_car_pool_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/firebase_notfications_cubit/firebase_notfications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_app_notifications/get_app_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_services_notifications/get_services_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_social_notifications/get_social_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/preload_cubit/preload_bloc.dart';
import 'package:fourtyninehub/helpers/call_helpers/notifications_helper/fcm_notification_helper.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/secrets/controller/secrets_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:geolocator/geolocator.dart';
import 'core/service/cache_service.dart';
import 'core/themes/light_theme.dart';
import 'features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import 'features/account_taps/wallet/presentation/cubit/wallet_cubit.dart';
import 'features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'features/notifications/presentation/cubits/get_user_trips_notifications/get_user_trips_notifications_cubit.dart';
import 'features/settings/presentation/cubit/choice_ruler_cubit.dart';
import 'features/settings/presentation/cubit/floating_navigator_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'firebase_options.dart';
import 'routes/pages.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

bool isActivate = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheManager.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final locationService = LocationService();

  // locationService.startLocationTracking();

  // // Listen for new locations (only when moved at least 300m)
  // locationService.locationUpdates.listen((position) {
  //   Fluttertoast.showToast(
  //       msg: "New location (moved at least 300m): ${position.latitude}, ${position.longitude}",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //       fontSize: 16.0
  //   );
  //   print('New location (moved at least 300m): ${position.latitude}, ${position.longitude}');
  //   // Do something with the new location
  // });

  await CacheServiceImpl.init();
  await DI.execute();
  serviceLocator<FcmNotificationHelper>().setup();
  serviceLocator<FcmNotificationHelper>().getFcmToken();
  await Geolocator.checkPermission().then(
    (value) {
      if (value == LocationPermission.denied) {
        Geolocator.requestPermission();
      }
    },
  );
  // ZegoGiftManager().cache.cache(giftItemList);
  isActivate = await CacheManager.getActivation() ?? false;
  await CacheManager.getFloatingNavigator();
  //Admob.initialize();l

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final customPageCubit = serviceLocator<CustomPageCubit>();
  await customPageCubit.fetchActivate();

  // final isActivated =  false;

  final initialRoute = isActivate ? Routes.PAGEPREVIEW : Routes.HOME;

  AppPages.initializeRouter(initialRoute);
  runApp(
    LocalizationService.rootWidget(
      child: Phoenix(
        child: DevicePreview(
          enabled: false,
          builder: (context) => const MyApp(),
        ),
      ),
      // child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  Future<dynamic> getCurrentCall() async {
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        return calls[0];
      } else {
        return null;
      }
    }
  }

  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
        await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future getToken() async {
    var token = await CacheManager.getAccessToken();
    log(token.toString(), name: "lskdjflskdfjlskdjfdslkfj");
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<SendCallCubit>()),
        BlocProvider(create: (context) => serviceLocator<CallCubit>()),
        // BlocProvider(
        //     create: (context) =>
        //         CheckTripEndCubit(repository: serviceLocator())),
        BlocProvider(
          create: (context) => serviceLocator<UserCubit>()..getUser(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<CreatePostCubit>()..loadData(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<SecretsCubit>()..getAllSecrets(),
        ),
        BlocProvider(
          create: (BuildContext context) => serviceLocator<WalletCubit>(),
        ),
        //to initialize preloading
        BlocProvider<ReelsCubit>(
          create: (_) => serviceLocator<ReelsCubit>()..fetchReels(),
        ),
        BlocProvider(
          create: (BuildContext context) => serviceLocator<SearchCubit>(),
        ),
        BlocProvider(
            create: (context) =>
                serviceLocator<PreloadBloc>()..getVideosFromApi()),
        BlocProvider(
          create: (BuildContext context) =>
              serviceLocator<MainCategoriesCubit>()..loadData(),
        ),
        BlocProvider(
          create: (BuildContext context) => serviceLocator<RideCubit>(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<CustomPageCubit>(
          create: (context) => serviceLocator()..fetchActivate(),
        ),
        BlocProvider<FirebaseNotficationsCubit>(
          create: (context) => FirebaseNotficationsCubit(serviceLocator()),
        ),
        BlocProvider<JoinTripCarPoolCubit>(
            create: (context) =>
                JoinTripCarPoolCubit(joinTripCarpoolUsecase: serviceLocator())),

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
        BlocProvider<GetUserTripsNotificationsCubit>(
          create: (context) => GetUserTripsNotificationsCubit(
            getAllUserTripsUseCase: serviceLocator(),
          )..getUserTripsNotifications(),
        ),
        BlocProvider<GetSocialNotificationsCubit>(
          create: (context) => GetSocialNotificationsCubit(
            getNotficationsUseCase: serviceLocator(),
            context: context,
          ),
        ),
        // BlocProvider(
        //   create: (context) => AuthenticationRideCubit(),
        // ),
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
                )),
        BlocProvider(create: (context) => serviceLocator<ShippingCubit>()),
        BlocProvider(
          create: (context) => FloatingNavigatorCubit()
            ..getFloatingNavigatorStatus()
            ..getEnableFloatingNavigatorStatus(),
        ),

        BlocProvider(
          create: (context) => ChoiceRulerCubit()
            ..getChoiceRulerStatus()
            ..getChoiceRulerEnabledStatus(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(750, 1334),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          context.read<SecretsCubit>().state.secrets?.zegoAppId;
          if (context.read<ReelsCubit>().state.globalReels.isEmpty) {
            context.read<ReelsCubit>().fetchReels();
          }
          return BlocBuilder<ThemeCubit, ThemeStates>(
            builder: (BuildContext context, state) {
              return FutureBuilder<bool>(
                future: CacheManager.getMode(),
                builder: (context, snapshot) {
                  return BlocBuilder<CustomPageCubit, CustomPageState>(
                    builder: (BuildContext context, custom) {
                      return Directionality(
                        textDirection: TextDirection.ltr,
                        child: Stack(
                          children: [
                            MaterialApp.router(
                              routerConfig: AppPages.router,
                              builder: (BuildContext context, Widget? child) {
                                final mediaQuery = MediaQuery.of(context);
                                return MediaQuery(
                                  data: mediaQuery.copyWith(
                                    textScaler: TextScaler.noScaling,
                                  ),
                                  child: child ?? const SizedBox.shrink(),
                                );
                              },
                              themeMode: (snapshot.data ?? false)
                                  ? ThemeMode.dark
                                  : ThemeMode.light,
                              theme: lightTheme,
                              darkTheme: darkTheme,
                              title: '49',
                              debugShowCheckedModeBanner: false,
                              localizationsDelegates:
                                  context.localizationDelegates,
                              supportedLocales: context.supportedLocales,
                              locale: context.locale,
                            ),
                            const WhatsAppCallScreen(),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
