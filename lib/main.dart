import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
<<<<<<< HEAD
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/liveview/gifts/gift_manager.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
=======
import 'package:fourtyninehub/core/themes/dark_theme.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'core/themes/light_theme.dart';
>>>>>>> f81a07431967fea988d5dd11b16e94cf604744ed
import 'features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'res/style/app_colors.dart';
import 'routes/pages.dart';
<<<<<<< HEAD
=======
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:admob_flutter/admob_flutter.dart';
import 'service_locator/tinder_service_locator.dart';
>>>>>>> f81a07431967fea988d5dd11b16e94cf604744ed

void main() async {
  CacheService cacheService = CacheServiceImpl();
  WidgetsFlutterBinding.ensureInitialized();
  await cacheService.init();
  await DI.execute();
  //to cache gift items
<<<<<<< HEAD
  ZegoGiftManager().cache.cache(giftItemList);
=======
  // ZegoGiftManager().cache.cache(giftItemList);

>>>>>>> f81a07431967fea988d5dd11b16e94cf604744ed
  //Admob.initialize();

  runApp(
    const MyApp(),
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
<<<<<<< HEAD
=======
        // SubscribeCubit
        // BlocProvider(
        //   create: (context) => serviceLocator<SubscribeCubit>(),
        // ),
>>>>>>> f81a07431967fea988d5dd11b16e94cf604744ed
        BlocProvider(
          create: (context) => serviceLocator<RiderequestCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<CreateShippingRequestCubit>(),
        ),
        // CreateAdCubit
        BlocProvider(
          create: (context) => serviceLocator<CreateAdCubit>(),
        ),
<<<<<<< HEAD
        BlocProvider(
          create: (context) => serviceLocator<ShippingCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<CreateDoctorCubit>(),
        ),
=======
        // health
        // BlocProvider(
        //   create: (context) => serviceLocator<DoctorsListCubit>(),
        // ),
>>>>>>> f81a07431967fea988d5dd11b16e94cf604744ed
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: MaterialApp.router(
          themeMode: ThemeMode.light,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          title: '49',
          debugShowCheckedModeBanner: false,
          routerConfig: AppPages.router,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
