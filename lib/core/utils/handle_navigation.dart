import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/service/storage.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/settings/presentation/cubit/choice_ruler_cubit.dart';
import 'package:fourtyninehub/features/settings/presentation/cubit/floating_navigator_cubit.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/secrets/controller/secrets_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HandleNavigation {
  static Future<void> navigateToNextScreen(BuildContext context) async {
    var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    String? refreshToken = await CacheManager.getRefreshToken();
    final isShowOnboarding = await CacheManager.getShowOnboarding();
    final currentLocation = GoRouter.of(currentContext).routerDelegate.currentConfiguration.uri.toString();
    final isActivate = await CacheManager.getActivation() ?? false;
    String nextRoute;
    if(currentContext.isUserLoggedIn!=true){
      print("currentContext.isUserLoggedIn1 ${currentContext.isUserLoggedIn}");
      if (!isShowOnboarding) {
        nextRoute = Routes.ChooseLangScreen;
      } else {
        nextRoute = Routes.HOME;
      }

      print('Navigating to: $nextRoute');

      if ((currentLocation!=nextRoute)) {
        currentContext.go(nextRoute);
      }
      return;
    }else
    {
      var result = await serviceLocator<ApiConsumer>().get('/settings');
      result.fold((failure){
      }, (data) async {
        print("data['data']['isLoggedIn'] $data");

        if(data['data']['isLoggedIn']==true){
          print("No Expiration");
          currentContext.read<UserCubit>().attachToken();
          currentContext.read<UserCubit>().getUser();
          currentContext.read<CreatePostCubit>().loadData();
          currentContext.read<SecretsCubit>().getAllSecrets();
          currentContext.read<CustomPageCubit>().fetchActivate();
          currentContext.read<GetUnreadNotificationsCountCubit>().getUnreadNotificationsCount();
          currentContext.read<FloatingNavigatorCubit>().getFloatingNavigatorStatus();
          currentContext.read<FloatingNavigatorCubit>().getEnableFloatingNavigatorStatus();
          currentContext.read<ChoiceRulerCubit>().getChoiceRulerStatus();
          currentContext.read<ChoiceRulerCubit>().getChoiceRulerEnabledStatus();
          if (!isShowOnboarding) {
            nextRoute = Routes.ChooseLangScreen;
          } else if (isActivate) {
            nextRoute = Routes.HOME;
          } else {
            nextRoute = Routes.HOME;
          }

          print('Navigating to: $nextRoute');

          if ((currentLocation!=nextRoute)) {
            currentContext.go(nextRoute);
          }
        }else{
          print("isAccessTokenExpired");
          UserTokensEntity? tokens = await _refreshToken(refreshToken??'');
          print("tokens !=null ${tokens !=null}");
          if(tokens !=null){
            currentContext.read<UserCubit>().attachToken();
            currentContext.read<UserCubit>().getUser();
            currentContext.read<CreatePostCubit>().loadData();
            currentContext.read<SecretsCubit>().getAllSecrets();
            currentContext.read<CustomPageCubit>().fetchActivate();
            currentContext.read<GetUnreadNotificationsCountCubit>().getUnreadNotificationsCount();
            currentContext.read<FloatingNavigatorCubit>().getFloatingNavigatorStatus();
            currentContext.read<FloatingNavigatorCubit>().getEnableFloatingNavigatorStatus();
            currentContext.read<ChoiceRulerCubit>().getChoiceRulerStatus();
            currentContext.read<ChoiceRulerCubit>().getChoiceRulerEnabledStatus();

            if (!isShowOnboarding) {
              nextRoute = Routes.ChooseLangScreen;
            } else if (isActivate) {
              nextRoute = Routes.HOME;
            } else {
              nextRoute = Routes.HOME;
            }

            print('Navigating to: $nextRoute');

            if ((currentLocation!=nextRoute)) {
              currentContext.go(nextRoute);
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

            if ((currentLocation!=nextRoute)) {
              currentContext.go(nextRoute);
            }
          }

        }
      });
    }
  }
}

Future<UserTokensEntity?> _refreshToken(String token) async {
  try {
    print('🔄 AuthInterceptor: Calling refresh token API From Splash');
    final response = await serviceLocator<Dio>().post(
      "https://9ad6cb01f298.ngrok-free.app/api/v1/auth/refresh-token",
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
    // currentContext.read<UserCubit>().attachToken();
    // currentContext.read<UserCubit>().getUser();
    // currentContext.read<CreatePostCubit>().loadData();
    // currentContext.read<SecretsCubit>().getAllSecrets();
    // currentContext.read<CustomPageCubit>().fetchActivate();
    // currentContext.read<GetUnreadNotificationsCountCubit>().getUnreadNotificationsCount();
    // currentContext.read<FloatingNavigatorCubit>().getFloatingNavigatorStatus();
    // currentContext.read<FloatingNavigatorCubit>().getEnableFloatingNavigatorStatus();
    // currentContext.read<ChoiceRulerCubit>().getChoiceRulerStatus();
    // currentContext.read<ChoiceRulerCubit>().getChoiceRulerEnabledStatus();
    // var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    // currentContext.push(Routes.LOGIN);
    print('❌ AuthInterceptor: Refresh token API failed: $e');
    return null;
  }
}
