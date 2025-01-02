import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/theme/cubit/cubit.dart';
import 'package:fourtyninehub/common/theme/cubit/states.dart';
import 'package:fourtyninehub/core/localization/localization_service.dart';
import 'package:fourtyninehub/core/themes/dark_theme.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
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
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/check_trip_end_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/complete_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/rating_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/cancel_trip_client_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/cancel_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/check_start_record_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/check_stop_record_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/drivers_nearBy_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/start_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/accept_offer_by_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_accept_by_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_accept_by_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_payment_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_all_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_cateogry_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_reasons_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_ride_currentTrip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/location_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/offer_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/pick_driver_image_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/record_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/request_rider_trip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_trip_reel_time_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/send_offer_by_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/show_offers_cubit.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/controller/tiktok_controller_extension.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/preload_cubit/preload_bloc.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/secrets/controller/secrets_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:geolocator/geolocator.dart';
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
  await Geolocator.checkPermission().then(
    (value) {
      if (value == LocationPermission.denied) {
        Geolocator.requestPermission();
      }
    },
  );
  // ZegoGiftManager().cache.cache(giftItemList);

  //Admob.initialize();l

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final customPageCubit = serviceLocator<CustomPageCubit>();
  await customPageCubit.fetchActivate();

  final isActivated = customPageCubit.state.activate?.customPage ?? false;

  final initialRoute = isActivated ? Routes.PAGEPREVIEW : Routes.HOME;

  AppPages.initializeRouter(initialRoute);
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _startWebSocketService() async {
    final token = await CacheManager.getAccessToken();
    BackgroundService.startWebSocketService(token);
  }

  @override
  void initState() {
    super.initState();
    // _startWebSocketService();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                CheckTripEndCubit(repository: serviceLocator())),
        BlocProvider(
          create: (context) => serviceLocator<UserCubit>()..getUser(),
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
        // BlocProvider(
        //   create: (BuildContext context) =>
        //       serviceLocator<MainCategoriesCubit>()..getMainCategoryCustomPage(),
        // ),
        BlocProvider(
          create: (context) =>
              LocationSocketCubit(repository: serviceLocator()),
        ),
        BlocProvider(
          create: (context) => serviceLocator<ShowOffersCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<GetCateogryRiderCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<RiderTripReelTimeCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<RequestRiderTripCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              SendOfferByDriverCubit(repository: serviceLocator()),
        ),
        BlocProvider(
          create: (context) =>
              AcceptOfferByDriverCubit(repository: serviceLocator()),
        ),
        BlocProvider(
          create: (context) => RecordRideCubit(repository: serviceLocator()),
        ),
        // //  tinder to be reviewed
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
        BlocProvider<CustomPageCubit>(
          create: (context) => serviceLocator()..fetchActivate(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<StreamCubit>()
            ..loadLives()
            ..getScheduledMeetings()
            ..getTopics(),
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
                )),
        BlocProvider(
          create: (context) => ShowOffersCubit(
            repository: serviceLocator(),
          ),
        ),
        BlocProvider(
          create: (context) => CheckAcceptByDriverCubit(
            repository: serviceLocator(),
          )..check(),
        ),
        BlocProvider(
          create: (context) => CheckAcceptByRiderCubit(
            repository: serviceLocator(),
          )..check(),
        ),
        BlocProvider(
          create: (context) =>
              GetAllTripRiderCubit(repository: serviceLocator())..getAllTrip(),
        ),
        BlocProvider(
          create: (context) => OfferCubit(repository: serviceLocator()),
        ),
        BlocProvider(
          create: (context) => GetReasonsCubit(repository: serviceLocator()),
        ),
        BlocProvider(
          create: (context) =>
              StartTripRiderCubit(repository: serviceLocator()),
        ),
        BlocProvider(
          create: (context) =>
              CancelTripClientCubit(repository: serviceLocator()),
        ),
        BlocProvider(
          create: (context) => CheckPaymentCubit(repository: serviceLocator()),
        ),
        BlocProvider(
          create: (context) =>
              CancelTripRiderCubit(repository: serviceLocator()),
        ),
        BlocProvider(
          create: (context) => RatingDriverCubit(repository: serviceLocator()),
        ),
        BlocProvider(
          create: (context) =>
              CompleteNoSocketCubit(repository: serviceLocator()),
        ),
        BlocProvider(
          create: (context) =>
              CheckStopRecordCubit(repository: serviceLocator()),
        ),
        BlocProvider(
          create: (context) =>
              CheckStartRecordCubit(repository: serviceLocator()),
        ),

        // context.read<LocationSocketCubit>().updateDriverLocationOn();
        BlocProvider(
          create: (context) =>
              GetRideCurrenttripCubit(repository: serviceLocator())..get(),
        ),
        
        BlocProvider(
          create: (context) =>
              RegisterRiderCubit(repository: serviceLocator(), repo: serviceLocator()),
        ),
        BlocProvider(
          create: (context) =>
              PickDriverImageCubit(),
        ),
        BlocProvider(
          create: (context) => DriversNearbyCubit(repository: serviceLocator()),
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
                        return MaterialApp.router(
                          builder: (context, child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaler: TextScaler.noScaling),
                              child: child!,
                            );
                          },
                          themeMode: (snapshot.data ?? false)
                              ? ThemeMode.dark
                              : ThemeMode.light,
                          theme: lightTheme,
                          darkTheme: darkTheme,
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
                  });
            },
          );
        },
      ),
    );
  }
}
