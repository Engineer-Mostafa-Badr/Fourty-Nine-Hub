import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/localization/localization_service.dart';
import 'package:fourtyninehub/common/theme/cubit/cubit.dart';
import 'package:fourtyninehub/common/theme/cubit/states.dart';
import 'package:fourtyninehub/core/themes/dark_theme.dart';
import 'package:fourtyninehub/features/competition/data/repository/competition_repo_impl.dart';
import 'package:fourtyninehub/features/competition/presentation/cubit/competition_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'core/service/cache_service.dart';
import 'core/themes/light_theme.dart';
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
          create: (context) =>
              CompetitionCubit(serviceLocator.get<CompetitionRepoImpl>())
                ..fetchCompetition(context)
                ..fetchWinners(context),
        ),
        // BlocProvider(
        //   create: (context) => serviceLocator<RiderequestCubit>(),
        // ),
        // BlocProvider(
        //   create: (context) => serviceLocator<CreateShippingRequestCubit>(),
        // ),
        // // CreateAdCubit
        // BlocProvider(
        //   create: (context) => serviceLocator<CreateAdCubit>(),
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
      ],
      child: ZegoScreenUtilInit(
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
                );
              },
            );
          }),
    );
  }
}
