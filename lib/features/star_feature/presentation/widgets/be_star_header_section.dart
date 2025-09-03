import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/custom_show_dialog.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_state.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/subscribe_button_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class BeStarHeaderSection extends StatelessWidget {
  final StarState state;

  const BeStarHeaderSection({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    log("Banner Title: ${state.banner?.titleAr} ${state.banner?.titleEn}");
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Banner Image
          Container(
            width: double.infinity,
            height: 280.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: ImageFromInternet(
              image: state.banner?.banner ?? '',
              fit: BoxFit.fitWidth,
            ),
          ),
          const Sizer(),

          // Header Row with Title, Hint, and Subscribe Button
          Row(
            children: [
              // Title
              // Text(
              //   // (state.banner?.titleAr ?? state.banner?.titleEn ?? '')
              //   //     .toArabicNumbers(context),
              //   context.isArabic
              //       ? state.banner?.titleAr ?? ''
              //       : state.banner?.titleEn ?? '',
              //   textAlign: TextAlign.center,
              //   style: Styles.mediumText(
              //     fontSize: MediaQuery.of(context).size.width * 0.05,
              //     fontWeight: FontWeight.w500,
              //     color: context.isDarkMode
              //         ? Colors.white
              //         : AppColors.PRIMARY_COLOR,
              //   ),
              // ),
              AutoSizeText(
                context.isArabic
                    ? state.banner?.titleAr ?? ''
                    : state.banner?.titleEn ?? '',
                // style: TextStyle(
                //     fontSize: MediaQuery.of(context).size.width * 0.02),
              ),
              Sizer(),
              // Hint Button
              InkWell(
                onTap: () => _showHintDialog(context),
                child: SvgPicture.asset(
                  Assets.idea,
                  height: 24,
                  width: 24,
                ),
              ),
            ],
          ),
          const Sizer(),

          // Subtitle
          Align(
            alignment:
                context.isArabic ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              // text: (state.banner?.subTitleAr ?? state.banner?.subTitleEn ?? '')
              //     .toArabicNumbers(context),
              context.isArabic
                  ? state.banner?.subTitleAr ?? ''
                  : state.banner?.subTitleEn ?? '',
              // textAlign: TextAlign.center,
              style: Styles.mediumText(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color:
                    context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
              ),
            ),
          ),

          // Subscribe Button
          Align(
            alignment:
                context.isArabic ? Alignment.centerLeft : Alignment.centerRight,
            child: SubscribeButton(
              text: LocaleKeys.subscribe.localize,
              icon: Assets.ideaIcon,
              isSelected: true,
              onTap: () => _handleSubscribe(context),
              onShowHint: () => _showSubscribeHint(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showHintDialog(BuildContext context) {
    ManageVibration.vibrate();
    showAnimatedDialog(
      context,
      AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              width: double.infinity,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                Assets.talentGIF,
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.cover,
              ),
            ),
            PositionedDirectional(
              top: 10,
              start: 10,
              child: InkWell(
                onTap: () {
                  ManageVibration.vibrate();
                  context.pop();
                },
                child: Image.asset(
                  Assets.close,
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubscribe(BuildContext context) {
    ManageVibration.vibrate();
    if (!context.read<UserCubit>().isLoggedIn) {
      pleaseLoginDialog(context);
    } else {
      SubscriptionMethod().subscribe(
        subscribeId: "67e952dbbb085740a35d4281",
        title: LocaleKeys.ads.localize,
      );
    }
  }

  void _showSubscribeHint(BuildContext context) {
    ManageVibration.vibrate();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Label(
              text: context.isArabic
                  ? 'اشترك لإبقاء الصوت في الخلفية'
                  : 'Subscribe to remain voice in background',
              style: TextStyle(
                color: const Color(0xffFF0808),
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
