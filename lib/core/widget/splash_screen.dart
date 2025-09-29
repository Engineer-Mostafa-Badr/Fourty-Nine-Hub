import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/core/service/storage.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_tokens_model.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/settings/presentation/cubit/choice_ruler_cubit.dart';
import 'package:fourtyninehub/features/settings/presentation/cubit/floating_navigator_cubit.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/secrets/controller/secrets_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/theme/cubit/cubit.dart';
import '../../../../common/theme/cubit/states.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../routes/routes.dart';
import '../utils/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    print("🚀 SplashScreen initState() called");
    // Defer navigation until after the build phase is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🚀 SplashScreen addPostFrameCallback triggered");
      if (!_hasNavigated) {
        print("🚀 SplashScreen calling _navigateToNextScreen()");
        _navigateToNextScreen();
      } else {
        print("🚀 SplashScreen already navigated, skipping");
      }
    });
  }

  Future<void> _navigateToNextScreen() async {
    print("🚀 SplashScreen _navigateToNextScreen() called");
    print("_hasNavigated $_hasNavigated");
    if (_hasNavigated) {
      print("🚀 SplashScreen already navigated, returning early");
      return; // Prevent multiple navigation calls
    }
    _hasNavigated = true;
    print("🚀 SplashScreen setting _hasNavigated = true");
    final currentLocation = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    print("🚀 currentLocation = $currentLocation");

    String? accessToken = await CacheManager.getAccessToken();
    String? refreshToken = await CacheManager.getRefreshToken();
    final isActivate = await CacheManager.getActivation() ?? false;
    final isShowOnboarding = await CacheManager.getShowOnboarding();
    String nextRoute;
    serviceLocator<Dio>().options.headers['Authorization'] = 'Bearer $accessToken';

    if(context.isUserLoggedIn!=true){
      print("context.isUserLoggedIn1 ${context.isUserLoggedIn}");
      if (!isShowOnboarding) {
        nextRoute = Routes.ChooseLangScreen;
      } else {
        nextRoute = Routes.HOME;
      }

      print('Navigating to: $nextRoute');

      if (mounted&&(currentLocation!=nextRoute)) {
        context.go(nextRoute);
      }
      return;
    }else{
      var result = await serviceLocator<ApiConsumer>().get('/settings');
      result.fold((failure){
      }, (data) async {
        print("data['data']['isLoggedIn'] $data");

        if(data['data']['isLoggedIn']==true){
          print("No Expiration");
          context.read<UserCubit>().attachToken();
          context.read<UserCubit>().getUser();
          context.read<CreatePostCubit>().loadData();
          context.read<SecretsCubit>().getAllSecrets();
          context.read<CustomPageCubit>().fetchActivate();
          context.read<GetUnreadNotificationsCountCubit>().getUnreadNotificationsCount();
          context.read<FloatingNavigatorCubit>().getFloatingNavigatorStatus();
          context.read<FloatingNavigatorCubit>().getEnableFloatingNavigatorStatus();
          context.read<ChoiceRulerCubit>().getChoiceRulerStatus();
          context.read<ChoiceRulerCubit>().getChoiceRulerEnabledStatus();
          if (!isShowOnboarding) {
            nextRoute = Routes.ChooseLangScreen;
          } else if (isActivate) {
            nextRoute = Routes.HOME;
          } else {
            nextRoute = Routes.HOME;
          }

          print('Navigating to: $nextRoute');

          if (mounted&&(currentLocation!=nextRoute)) {
            context.go(nextRoute);
          }
        }else{
          print("isAccessTokenExpired");
          UserTokensEntity? tokens = await _refreshToken(refreshToken??'');
          print("tokens !=null ${tokens !=null}");
          if(tokens !=null){
            context.read<UserCubit>().attachToken();
            context.read<UserCubit>().getUser();
            context.read<CreatePostCubit>().loadData();
            context.read<SecretsCubit>().getAllSecrets();
            context.read<CustomPageCubit>().fetchActivate();
            context.read<GetUnreadNotificationsCountCubit>().getUnreadNotificationsCount();
            context.read<FloatingNavigatorCubit>().getFloatingNavigatorStatus();
            context.read<FloatingNavigatorCubit>().getEnableFloatingNavigatorStatus();
            context.read<ChoiceRulerCubit>().getChoiceRulerStatus();
            context.read<ChoiceRulerCubit>().getChoiceRulerEnabledStatus();

            if (!isShowOnboarding) {
              nextRoute = Routes.ChooseLangScreen;
            } else if (isActivate) {
              nextRoute = Routes.HOME;
            } else {
              nextRoute = Routes.HOME;
            }

            print('Navigating to: $nextRoute');

            if (mounted&&(currentLocation!=nextRoute)) {
              context.go(nextRoute);
            }
          }else{
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool("ISLOGIN", false);

            await CacheManager.deleteAllTokens();
            await Storage.setLoginValue(false);
            print("No Expiration");
            if (!isShowOnboarding) {
              nextRoute = Routes.ChooseLangScreen;
            } else if (isActivate) {
              nextRoute = Routes.HOME;
            } else {
              nextRoute = Routes.LOGIN;
            }

            print('Navigating to: $nextRoute');

            if (mounted&&(currentLocation!=nextRoute)) {
              context.go(nextRoute);
            }
          }

        }
      });
    }


  }


  Future<UserTokensEntity?> _refreshToken(String token) async {
    try {
      print('🔄 AuthInterceptor: Calling refresh token API From Splash');
      final response = await serviceLocator<Dio>().post(
        "https://49backend.com/api/v1/auth/refresh-token",
        data: {
          'refreshToken': token,
        },
        options: Options(
          headers: {
            "x-api-key":
            "2c5381952acd7c2d530e6c656d2f6d94142f4f3e84c1c7d2b48dabdd976b0e06",
            "Content-Type": "application/json",
          },
        ),
      );
      final newAccessToken = response.data['data']['accessToken'] as String;
      serviceLocator<Dio>().options.headers['Authorization'] = 'Bearer ${newAccessToken??''}';
      print("serviceLocator<Dio>().options.headers['Authorization']1 ${serviceLocator<Dio>().options.headers['Authorization']}");
      Future.delayed(Duration(seconds: 4));

      if(response.statusCode != 200) {
        print("response.statusCode ${response.statusCode}");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("ISLOGIN", false);
        return null;
      }

      if(response.statusCode == 200){
        print("response.statusCode ${response.statusCode}");
        final accessToken = response.data['data']['accessToken'] as String;
        serviceLocator<Dio>().options.headers['Authorization'] = 'Bearer $accessToken';
        print("serviceLocator<Dio>().options.headers['Authorization'] ${serviceLocator<Dio>().options.headers['Authorization']}");
        Future.delayed(Duration(seconds: 1));

      }


      final accessToken = response.data['data']['accessToken'] as String;
      final refreshToken = response.data['data']['refreshToken'] as String;
      final newToken = UserTokensEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      serviceLocator<Dio>().options.headers['Authorization'] = 'Bearer $accessToken';

      print('🔐 AuthInterceptor: New tokens received - Access: ${accessToken.substring(0, 10)}..., Refresh: ${refreshToken.substring(0, 10)}...');

      // Save both tokens to cache
      await CacheManager.saveAccessToken(accessToken);
      await CacheManager.saveRefreshToken(refreshToken);
      await Storage.setRefreshToken(refreshToken);
      serviceLocator<Dio>().options.headers['Authorization'] = 'Bearer $accessToken';

      return newToken;
    } catch (e) {
      // context.read<UserCubit>().attachToken();
      // context.read<UserCubit>().getUser();
      // context.read<CreatePostCubit>().loadData();
      // context.read<SecretsCubit>().getAllSecrets();
      // context.read<CustomPageCubit>().fetchActivate();
      // context.read<GetUnreadNotificationsCountCubit>().getUnreadNotificationsCount();
      // context.read<FloatingNavigatorCubit>().getFloatingNavigatorStatus();
      // context.read<FloatingNavigatorCubit>().getEnableFloatingNavigatorStatus();
      // context.read<ChoiceRulerCubit>().getChoiceRulerStatus();
      // context.read<ChoiceRulerCubit>().getChoiceRulerEnabledStatus();
      // var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
      // currentContext.push(Routes.LOGIN);
      print('❌ AuthInterceptor: Refresh token API failed: $e');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: AppBar(
            automaticallyImplyLeading: false,
          ),
        ),
        body: BlocBuilder<ThemeCubit, ThemeStates>(
            builder: (BuildContext context, theme) {
          var themeCubit = context.read<ThemeCubit>();
          return SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 5,
                    child: Image.asset(
                      themeCubit.isDarkTheme
                          ? Assets.logo
                          : Assets.logoWithBlackText,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Welcome to 49 HUB Super App',
                    style: TextStyle(
                      color: themeCubit.isDarkTheme
                          ? AppColors.whiteColor
                          : AppColors.PRIMARY_COLOR,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tangerine',
                    ),
                  ),
                  const Text(
                    'A L L   Y O U   N E E D',
                    style: TextStyle(
                      color: AppColors.SECONDARY_COLOR,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tangerine',
                    ),
                  ),
                  const Spacer(flex: 3),
                  Label(
                    text: '© 49 HUB FOR PROGRAMMING',
                    style: Styles.mediumText(
                      color: themeCubit.isDarkTheme
                          ? AppColors.whiteColor
                          : AppColors.PRIMARY_COLOR,
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                  Label(
                    text: 'V1.0.5 - All rights reserved 2025',
                    style: Styles.mediumText(
                      color: AppColors.GREY_DARK_COLOR,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
