import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/localization/localization_service.dart';
import 'package:fourtyninehub/common/theme/cubit/cubit.dart';
import 'package:fourtyninehub/common/theme/cubit/states.dart';
import 'package:fourtyninehub/common/translations/translation_cubit.dart';
import 'package:fourtyninehub/core/themes/dark_theme.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:fourtyninehub/service_locator/theme_service_locator.dart';
import 'core/themes/light_theme.dart';
import 'features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'routes/pages.dart';

//import 'package:admob_flutter/admob_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.execute();
  //to cache gift items
  // ZegoGiftManager().cache.cache(giftItemList);

  //Admob.initialize();

  runApp(
    LocalizationService.rootWidget(
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
