import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/liveview/gifts/gift_manager.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'features/social_media/live_streaming/presentation/widgets/liveview/gifts/gift_sheet.dart';
import 'res/style/app_colors.dart';
import 'routes/pages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:admob_flutter/admob_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.execute();
  //to cache gift items
  ZegoGiftManager().cache.cache(giftItemList);

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
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: MaterialApp.router(
          title: '49',
          theme: ThemeData(
            iconTheme: const IconThemeData(
              size: 18,
              color: AppColors.PRIMARY_COLOR,
            ),
            colorScheme: ColorScheme.fromSeed(
              background: Colors.white,
              seedColor: const Color(0xff0b1035),
            ),
            useMaterial3: true,
          ),
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
