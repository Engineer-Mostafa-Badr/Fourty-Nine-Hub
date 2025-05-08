import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../../../ads/interstitial_ad_model.dart';
import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/handle_cashback.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class GridBlocksWidget extends StatelessWidget {
  const GridBlocksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      children: [
        _buildStarWidget(context,
          onTap: () {
            AdInterstitialTop.loadIntersitialAd();
            AdInterstitialTop.showInterstitialAd();
            context.push(Routes.RIDE_HOME);
          },
          shadowColor: Color(0xff8000FF),
          image: Assets.car2Image,
          title: LocaleKeys.ride.localize,
        ),
        _buildStarWidget(context,
          onTap: () {
            AdInterstitialTop.loadIntersitialAd();
            AdInterstitialTop.showInterstitialAd();
            context.push(Routes.VISITA);
          },
          shadowColor: Color(0xff4997D0),
          image: Assets.doctorImage,
          title: LocaleKeys.health.localize,
        ),
        _buildStarWidget(context,
          onTap: () {
            AdInterstitialTop.loadIntersitialAd();
            AdInterstitialTop.showInterstitialAd();
            HandleCashback.setCount('beAStarCount', context);
            context.push(Routes.FOOD);
          },
          shadowColor: Color(0xffFF7F00),
          image: Assets.mealImage,
          title: LocaleKeys.meal.localize,
        ),
        _buildStarWidget(context,
          onTap: () {
            if(!context.read<UserCubit>().isLoggedIn){
              return pleaseLoginDialog(context);
            }
            AdInterstitialTop.loadIntersitialAd();
            AdInterstitialTop.showInterstitialAd();
            HandleCashback.setCount('tripJoinCount', context);
            context.push(Routes.newRideModeScreen);
          },
          shadowColor:
          AppColors.PRIMARY_COLOR.withValues(alpha: .8),
          image: Assets.joinTrip,
          title: LocaleKeys.tripJoin.localize,
        ),
        _buildStarWidget(context,
          onTap: () {
          if(!context.read<UserCubit>().isLoggedIn){
            return pleaseLoginDialog(context);
          }
            AdInterstitialTop.loadIntersitialAd();
            AdInterstitialTop.showInterstitialAd();
            HandleCashback.setCount('beAStarCount', context);
            context.push(Routes.BE_STAR);
          },
          shadowColor:
          AppColors.SECONDARY_COLOR.withValues(alpha: .7),
          image: Assets.tube1,
          title: LocaleKeys.tube.localize,
        ),
        _buildStarWidget(context,
          onTap: () {
            AdInterstitialTop.loadIntersitialAd();
            AdInterstitialTop.showInterstitialAd();
            context.push(Routes.MARRIAGESUBCATEGORIES);
          },
          shadowColor: Color(0xffFFC0CB),
          image: Assets.marriage,
          title: LocaleKeys.marriage.localize,
        ),
      ],
    );
  }
  Widget _buildStarWidget(context,{
    void Function()? onTap,
    required Color shadowColor,
    required String title,
    required String image,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: kToolbarHeight * 2.h,
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(40.r),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.fill,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(1, 1),
            )
          ],
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.black38,
            ),
            Label(
              text: title,
              style: Styles.mediumText(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
