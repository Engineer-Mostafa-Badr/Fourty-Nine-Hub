import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../Controllers/on_boarding_cubit.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<OnBoardingCubit, OnBoardingState>(
        builder: (context, state) {
          var cubit = context.read<OnBoardingCubit>();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.paddingOf(context).top,
                ),
                const Sizer(
                  height: 64,
                ),
                Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        CacheManager.isShowOnboarding(true);
                        context.go(Routes.LOGIN);
                      },
                      child: Label(
                        text: LocaleKeys.skip.localize,
                        style: Styles.headerText(
                          color: context.isDarkMode
                              ? AppColors.AUTH_CONTAINER_COLOR
                              : AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
                const Sizer(
                  height: 96,
                ),
                Expanded(
                  child: Directionality(
                    textDirection: context.textDirection,
                    child: PageView.builder(
                      itemCount: cubit.images.length,
                      itemBuilder: (context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 300,
                            child: SvgPicture.asset(
                              state.image,
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            context.isArabic ? state.titleAr : state.titleEn,
                            style: Styles.headerText(
                                color: context.isDarkMode
                                    ? AppColors.AUTH_CONTAINER_COLOR
                                    : AppColors.PRIMARY_COLOR),
                          ),
                        ],
                      ),
                      onPageChanged: (index) {
                        if (index < cubit.images.length) {
                          debugPrint(
                              'index <= ${cubit.images.length - 1} $index');
                          cubit.changeOnboardingData(index);
                        } else {
                          debugPrint('else $index');
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Scaffold()),
                              (route) => false);
                        }
                      },
                      controller: controller,
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      cubit.images.length,
                      (itemIndex) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: itemIndex == state.currentIndex
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF0B1035),
                                      Color(0xFFFF3308),
                                    ],
                                    begin: Alignment.topCenter,
                                  )
                                : null,
                            color: itemIndex == state.currentIndex
                                ? null
                                : AppColors.GREYBG,
                          ),
                          height: 10,
                          width: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                const Sizer(
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppButton(
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      int index = state.currentIndex;
                      debugPrint(index.toString());
                      if (index < cubit.images.length - 1) {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear);
                        cubit.changeOnboardingData(index);
                      } else {
                        CacheManager.isShowOnboarding(true);
                        context.go(Routes.LOGIN);
                        // CacheHelper.put(key: 'showOnboarding', value: true);
                      }
                    },
                    label: (state.currentIndex < cubit.images.length - 1)
                        ? LocaleKeys.next.localize
                        : LocaleKeys.start.localize,
                    style: Styles.headerText(
                        color: AppColors.AUTH_CONTAINER_COLOR),
                  ),
                ),
                const Sizer(
                  height: 96,
                ),

                // SizedBox(height: heightRation(context, 40),),
              ],
            ),
          );
        },
      ),
    );
  }
}
