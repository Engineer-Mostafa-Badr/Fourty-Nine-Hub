import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // أضف هذا الimport

import '../../../../common/theme/cubit/cubit.dart';
import '../../../../common/theme/cubit/states.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../routes/routes.dart'; // احذف import pages.dart
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
    // انتظار 3 ثواني
    await Future.delayed(const Duration(seconds: 3));

    // تحديد الشاشة التالية
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: themeCubit.isDarkTheme
                          ? AppColors.whiteColor
                          : AppColors.PRIMARY_COLOR,
                      width: themeCubit.isDarkTheme ? 2 : 0,
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      Assets.loginGIF,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
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
