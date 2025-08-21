import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/theme/cubit/cubit.dart';
import '../../../../common/theme/cubit/states.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../Controllers/on_boarding_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController controller;
  Timer? _autoScrollTimer;
  final Duration _autoScrollDuration = const Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<OnBoardingCubit>();
      cubit.changeOnboardingData(0);
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(_autoScrollDuration, (Timer timer) {
      if (!mounted || !controller.hasClients) return;

      final cubit = context.read<OnBoardingCubit>();
      final nextPage = controller.page!.toInt() + 1;

      if (nextPage < cubit.images.length) {
        controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        controller.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<ThemeCubit, ThemeStates>(
          builder: (BuildContext context, theme) {
        var themeCubit = context.read<ThemeCubit>();
        return BlocBuilder<OnBoardingCubit, OnBoardingState>(
          builder: (context, state) {
            final cubit = context.read<OnBoardingCubit>();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.paddingOf(context).top),
                  _buildSkipButton(context, themeCubit.isDarkTheme),
                  const Spacer(
                    flex: 2,
                  ),
                  _buildPageView(cubit, state, context, themeCubit.isDarkTheme),
                  const Spacer(),
                  _buildPageIndicator(cubit, state),
                  const Spacer(),
                  _buildNavigationButton(cubit, state, themeCubit.isDarkTheme),
                  const Spacer(),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildSkipButton(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        const Spacer(),
        InkWell(
          onTap: () {
            ManageVibration.vibrate();
            CacheManager.isShowOnboarding(true);
            context.go(Routes.HOME);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const FirstLoginScreen()));
          },
          child: Label(
            text: LocaleKeys.skip.localize,
            style: Styles.headerText(
              color: isDarkMode
                  ? AppColors.AUTH_CONTAINER_COLOR
                  : AppColors.PRIMARY_COLOR,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageView(OnBoardingCubit cubit, OnBoardingState state,
      BuildContext context, bool isDarkTheme) {
    return Expanded(
      flex: 6,
      child: Directionality(
        textDirection: context.textDirection,
        child: PageView.builder(
          itemCount: cubit.images.length,
          itemBuilder: (context, index) => _buildPageItem(
            index: index,
            images: cubit.images,
            titleAr: cubit.titlesAr,
            titleEn: cubit.titlesEn,
            isDarkTheme: isDarkTheme,
          ),
          onPageChanged: (index) {
            _startAutoScroll(); // Reset timer on manual scroll
            if (!cubit.isClosed) {
              print('controller.page!: ${controller.page!.toInt()}');
              cubit.changeOnboardingData(controller.page!.toInt() + 1);
              // cubit.changeOnboardingData(state.currentIndex+1);
            }
            if (index >= cubit.images.length) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Scaffold()),
                (route) => false,
              );
            }
          },
          controller: controller,
        ),
      ),
    );
  }

  Widget _buildPageIndicator(OnBoardingCubit cubit, OnBoardingState state) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          cubit.images.length,
          (itemIndex) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: itemIndex == state.currentIndex
                    ? const LinearGradient(
                        colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                        begin: Alignment.topCenter,
                      )
                    : null,
                color:
                    itemIndex == state.currentIndex ? null : AppColors.GREYBG,
              ),
              height: 10,
              width: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
      OnBoardingCubit cubit, OnBoardingState state, bool isDarkTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppButton(
        backColor: isDarkTheme ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
        onPressed: () {
          ManageVibration.vibrate();
          _startAutoScroll(); // Reset timer on button press
          final index = state.currentIndex;
          if (index < cubit.images.length - 1) {
            controller.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );
            cubit.changeOnboardingData(index + 1);
          } else {
            CacheManager.isShowOnboarding(true);
            context.go(Routes.HOME);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const FirstLoginScreen()));
          }
        },
        label: (state.currentIndex < cubit.images.length - 1)
            ? LocaleKeys.next.localize
            : LocaleKeys.start.localize,
        style: Styles.headerText(
            color: isDarkTheme
                ? AppColors.PRIMARY_COLOR
                : AppColors.AUTH_CONTAINER_COLOR),
      ),
    );
  }

  Widget _buildPageItem(
      {required int index,
      required List<String> images,
      required List<String> titleAr,
      required List<String> titleEn,
      required bool isDarkTheme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: SvgPicture.asset(
            images.isNotEmpty ? images[index] : 'assets/default_image.svg',
            width: double.infinity,
          ),
        ),
        const Spacer(),
        Text(
          context.isArabic ? titleAr[index] : titleEn[index],
          style: Styles.headerText(
            color: isDarkTheme
                ? AppColors.AUTH_CONTAINER_COLOR
                : AppColors.PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }
}
