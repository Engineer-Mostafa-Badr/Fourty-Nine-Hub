import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    String? accessToken = await CacheManager.getAccessToken();
    String? refreshToken = await CacheManager.getRefreshToken();
    bool isAccessTokenExpired = JwtDecoder.isExpired(accessToken??'');
    bool isRefreshTokenExpired = JwtDecoder.isExpired(refreshToken??'');
    print("isRefreshTokenExpired $isRefreshTokenExpired");
    print("isAccessTokenExpired $isAccessTokenExpired");
    final isActivate = await CacheManager.getActivation() ?? false;
    final isShowOnboarding = await CacheManager.getShowOnboarding();
    String nextRoute;
    if (!isShowOnboarding) {
      nextRoute = Routes.ChooseLangScreen;
    } else if (isActivate) {
      nextRoute = Routes.PAGEPREVIEW;
    } else {
      nextRoute = Routes.HOME;
    }

    print('Navigating to: $nextRoute');

    if (mounted) {
      context.go(nextRoute);
    }
    if(isRefreshTokenExpired){
      print("isRefreshTokenExpired");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("ISLOGIN", false);
      await Future.delayed(const Duration(seconds: 2));
      context.read<UserCubit>().attachToken();
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
        nextRoute = Routes.PAGEPREVIEW;
      } else {
        nextRoute = Routes.HOME;
      }

      print('Navigating to: $nextRoute');

      if (mounted) {
        context.go(nextRoute);
      }
      return;
    }
    if(isAccessTokenExpired){
      print("isAccessTokenExpired");
      UserTokensEntity? tokens = await _refreshToken(refreshToken??'');
      print("tokens !=null ${tokens !=null}");
      if(tokens !=null){
        if (!isShowOnboarding) {
          nextRoute = Routes.ChooseLangScreen;
        } else if (isActivate) {
          nextRoute = Routes.PAGEPREVIEW;
        } else {
          nextRoute = Routes.HOME;
        }

        print('Navigating to: $nextRoute');

        if (mounted) {
          context.go(nextRoute);
        }
      }
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

      if(response.statusCode != 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("ISLOGIN", false);
        context.read<UserCubit>().attachToken();
        context.read<CreatePostCubit>().loadData();
        context.read<SecretsCubit>().getAllSecrets();
        context.read<CustomPageCubit>().fetchActivate();
        context.read<GetUnreadNotificationsCountCubit>().getUnreadNotificationsCount();
        context.read<FloatingNavigatorCubit>().getFloatingNavigatorStatus();
        context.read<FloatingNavigatorCubit>().getEnableFloatingNavigatorStatus();
        context.read<ChoiceRulerCubit>().getChoiceRulerStatus();
        context.read<ChoiceRulerCubit>().getChoiceRulerEnabledStatus();
      }

      if(response.statusCode == 200){
        context.read<UserCubit>().attachToken();
        context.read<CreatePostCubit>().loadData();
        context.read<SecretsCubit>().getAllSecrets();
        context.read<CustomPageCubit>().fetchActivate();
        context.read<GetUnreadNotificationsCountCubit>().getUnreadNotificationsCount();
        context.read<FloatingNavigatorCubit>().getFloatingNavigatorStatus();
        context.read<FloatingNavigatorCubit>().getEnableFloatingNavigatorStatus();
        context.read<ChoiceRulerCubit>().getChoiceRulerStatus();
        context.read<ChoiceRulerCubit>().getChoiceRulerEnabledStatus();

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
      serviceLocator<Dio>().options.headers['Authorization'] = 'Bearer $accessToken';

      return newToken;
    } catch (e) {
      var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
      currentContext.push(Routes.LOGIN);
      print('❌ AuthInterceptor: Refresh token API failed: $e');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(),
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
    );
  }
}
