import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/soon_dialog.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:go_router/go_router.dart';

import '../../../../ads/interstitial_ad_model.dart';
import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/handle_cashback.dart';
import '../../../../features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class GridBlocksWidget extends StatelessWidget {
  const GridBlocksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      _buildStarWidget(
        context,
        onTap: () {
          ManageVibration.vibrate();
          AdInterstitialTop.loadIntersitialAd();
          AdInterstitialTop.showInterstitialAd();
          context.push(Routes.RIDE_HOME);
        },
        shadowColor: const Color(0xff8000FF).withValues(alpha: 0.9),
        image: Assets.car2Image,
        title: LocaleKeys.ride.localize,
      ),
      _buildStarWidget(
        context,
        onTap: () {
          ManageVibration.vibrate();
          AdInterstitialTop.loadIntersitialAd();
          AdInterstitialTop.showInterstitialAd();
          context.push(Routes.VISITA);
        },
        shadowColor: const Color(0xff4997D0).withValues(alpha: 0.9),
        image: Assets.doctorImage,
        title: LocaleKeys.health.localize,
      ),
      _buildStarWidget(
        context,
        onTap: () {
          ManageVibration.vibrate();
          AdInterstitialTop.loadIntersitialAd();
          AdInterstitialTop.showInterstitialAd();
          HandleCashback.setCount('foodCount', context);
          context.push(Routes.FOOD);
        },
        shadowColor: const Color(0xffFF7F00).withValues(alpha: 0.9),
        image: Assets.mealImage,
        title: LocaleKeys.meal.localize,
      ),
      _buildStarWidget(
        context,
        onTap: () {
          ManageVibration.vibrate();
          if (!context.read<UserCubit>().isLoggedIn) {
            return pleaseLoginDialog(context);
          }
          ManageVibration.vibrate();
          AdInterstitialTop.loadIntersitialAd();
          AdInterstitialTop.showInterstitialAd();
          HandleCashback.setCount('tripJoinCount', context);
          context.push(Routes.newRideModeScreen);
        },
        shadowColor:  Colors.lightGreenAccent.withValues(alpha: .9),
        image: Assets.joinTrip,
        title: LocaleKeys.tripJoin.localize,
      ),
      _buildStarWidget(
        context,
        onTap: () {
          ManageVibration.vibrate();
          AdInterstitialTop.loadIntersitialAd();
          AdInterstitialTop.showInterstitialAd();
          HandleCashback.setCount('beAStarCount', context);
          // context.push(Routes.BE_STAR);
          context.push(
            context.read<UserCubit>().isLoggedIn
                ? Routes.BE_STAR
                : Routes.FirstLoginScreen,
          );
        },
        shadowColor: Colors.red.withValues(alpha: .9),
        image: Assets.tube1,
        title: LocaleKeys.tube.localize,
      ),
      _buildStarWidget(
        context,
        onTap: () {
          ManageVibration.vibrate();
          AdInterstitialTop.loadIntersitialAd();
          AdInterstitialTop.showInterstitialAd();
          // context.push(Routes.MARRIAGESUBCATEGORIES);
          context.push(
            context.read<UserCubit>().isLoggedIn
                ? Routes.MARRIAGESUBCATEGORIES
                : Routes.FirstLoginScreen,
          );
        },
        shadowColor: Colors.redAccent.withValues(alpha: 0.9),
        image: Assets.marriage,
        title: LocaleKeys.marriage.localize,
      ),
      _buildStarWidget(
        context,
        onTap: () {
          ManageVibration.vibrate();
          AdInterstitialTop.loadIntersitialAd();
          AdInterstitialTop.showInterstitialAd();
          context.push(
            context.read<UserCubit>().isLoggedIn
                ? Routes.CHANCE
                : Routes.FirstLoginScreen,
          );
        },
        shadowColor: Colors.yellowAccent.withValues(alpha: 0.9),
        image: Assets.chanceImage,
        title: LocaleKeys.chance.localize,
      ),
      _buildStarWidget(
        context,
        onTap: () {
          ManageVibration.vibrate();
          AdInterstitialTop.loadIntersitialAd();
          AdInterstitialTop.showInterstitialAd();
          context.push(Routes.EXCHANGECURRENCY);
        },
        shadowColor: Colors.pink.withValues(alpha: 0.9),
        image: Assets.moneyExchangeImage,
        title: context.isArabic ? 'عملات' : 'Exchange',
      ),
      _buildStarWidget(
        context,
        onTap: () {
          ManageVibration.vibrate();
          AdInterstitialTop.loadIntersitialAd();
          AdInterstitialTop.showInterstitialAd();
          context.push(Routes.availableAuctionScreen);
        },
        shadowColor: Colors.green.withValues(alpha: 0.9),
        image: Assets.bidImage,
        title: context.isArabic ? 'مزاد' : 'Auction',
      ),
      _buildStarWidget(
        context,
        onTap: () {
          ManageVibration.vibrate();
          soonDialog(context);
          // AdInterstitialTop.loadIntersitialAd();
          // AdInterstitialTop.showInterstitialAd();
          // context.push(Routes.MARRIAGESUBCATEGORIES);
        },
        shadowColor: Colors.brown.withValues(alpha: 0.9),
        image: Assets.gamesImage,
        title: context.isArabic ? 'العاب' : 'Games',
      ),
    ];

    return Directionality(
      textDirection: context.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 140.h, // Adjust depending on card height
          autoPlay: true,
          enlargeCenterPage: false,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          viewportFraction: 0.3, // Show 3 cards: center + partial sides
          enableInfiniteScroll: true,
          autoPlayInterval: const Duration(seconds: 3),
        ),
        items: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: item,
          );
        }).toList(),
      ),
    );
  }

  static Widget _buildStarWidget(
    BuildContext context, {
    void Function()? onTap,
    required Color shadowColor,
    required String title,
    required String image,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140.h, // Adjust depending on card height
        width: 200.w,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(40.r),
          border: Border.all(color: context.isDarkMode? AppColors.whiteColor : AppColors.GREY_DARK_COLOR, width: 1),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: shadowColor,
          //     spreadRadius: 5,
          //     blurRadius: 5,
          //     offset: const Offset(1, 1),
          //   )
          // ],
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(1, 1),
                )
              ]
            ),
            child: Label(
              text: title,
              style: Styles.mediumText(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
