import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fourtyninehub/core/themes/dark_theme.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/presentation/cubit/doctors_list_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/liveview/gifts/gift_manager.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// import 'package:fourtyninehub/res/style/theme.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'core/themes/light_theme.dart';
import 'features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'features/social_media/live_streaming/presentation/widgets/liveview/gifts/gift_sheet.dart';
import 'features/subscribe/presentation/cubit/subscribe_cubit.dart';
import 'res/style/app_colors.dart';
import 'routes/pages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:admob_flutter/admob_flutter.dart';
import 'service_locator/tinder_service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.execute();
  //to cache gift items
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
        BlocProvider(
          create: (context) => serviceLocator<SubscribeCubit>(),
        ),
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
        BlocProvider(
          create: (context) => serviceLocator<DoctorsListCubit>(),
        ),
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
