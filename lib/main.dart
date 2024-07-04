import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/presentation/cubit/doctors_list_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'res/style/app_colors.dart';
import 'routes/pages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.execute();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   Admob.initialize();

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
          create: (context) => serviceLocator<RestaurantDetailsCubit>(),
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
