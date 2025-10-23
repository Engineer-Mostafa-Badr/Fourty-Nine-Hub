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
import 'package:fourtyninehub/core/widget/common/dots_widget.dart';
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
      final currentPage = controller.page?.toInt() ?? 0;
      final nextPage = (currentPage + 1) % cubit.images.length; // Loop back to 0

      controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // When back button is pressed, go back to language selection screen
          context.go(Routes.ChooseLangScreen);
        }
      },
      child: Scaffold(
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
      ),
    );
  }

  Widget _buildSkipButton(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        const Spacer(),
        Label(
          text: '',
          style: Styles.headerText(
            color: isDarkMode
                ? AppColors.AUTH_CONTAINER_COLOR
                : AppColors.PRIMARY_COLOR,
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
              // Update cubit with the actual current page index
              cubit.changeOnboardingData(index);
            }
          },
          controller: controller,
        ),
      ),
    );
  }

  Widget _buildPageIndicator(OnBoardingCubit cubit, OnBoardingState state) {
    int currentIndex = 0;

    if (controller.hasClients && controller.positions.isNotEmpty) {
      currentIndex = (controller.page ?? controller.initialPage.toDouble()).round();
    } else {
      currentIndex = state.currentIndex; // fallback to cubit's current index
    }

    return DotsWidget(length: cubit.images.length, currentIndex: currentIndex);
  }

  Widget _buildNavigationButton(
      OnBoardingCubit cubit, OnBoardingState state, bool isDarkTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          AppButton(
            backColor: isDarkTheme ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
            onPressed: () {
              ManageVibration.vibrate();
              _startAutoScroll(); // Reset timer on button press
              final currentIndex = state.currentIndex;
              if (currentIndex < cubit.images.length - 1) {
                // Just animate to next page, onPageChanged will handle the state update
                controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
              } else {
                CacheManager.isShowOnboarding(true);
                context.go(Routes.HOME);
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
          if( (state.currentIndex < cubit.images.length - 1)) SizedBox(height: 25,),
         if( (state.currentIndex < cubit.images.length - 1)) InkWell(
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
                color: context.isDarkMode
                    ? AppColors.AUTH_CONTAINER_COLOR
                    : AppColors.PRIMARY_COLOR,
                decoration: TextDecoration.underline,
                decorationThickness: 1
              ),
            ),
          ),
        ],
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
          textAlign: TextAlign.center,
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
