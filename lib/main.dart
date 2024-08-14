import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/liveview/gifts/gift_manager.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:fourtyninehub/core/themes/dark_theme.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'core/localization/localization_service.dart';
import 'core/themes/light_theme.dart';
import 'features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'routes/pages.dart';
//import 'package:admob_flutter/admob_flutter.dart';
import 'service_locator/tinder_service_locator.dart';

void main() async {
  CacheService cacheService = CacheServiceImpl();
  WidgetsFlutterBinding.ensureInitialized();
  await cacheService.init();
  await DI.execute();
  //to cache gift items
  // ZegoGiftManager().cache.cache(giftItemList);
  // ZegoGiftManager().cache.cache(giftItemList);

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
        // SubscribeCubit
        // BlocProvider(
        //   create: (context) => serviceLocator<SubscribeCubit>(),
        // ),
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
        // health
        // BlocProvider(
        //   create: (context) => serviceLocator<DoctorsListCubit>(),
        // ),
        BlocProvider(
          create: (context) => serviceLocator<ChatsCubit>(),
        ),
        //  tinder
        BlocProvider(
          create: (context) => TinderViewCubit(),
        ),
      ],
      child: MaterialApp.router(
        themeMode: ThemeMode.light,
        theme: lightTheme(),
        darkTheme: darkTheme(),
        title: '49',
        debugShowCheckedModeBanner: false,
        routerConfig: AppPages.router,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
