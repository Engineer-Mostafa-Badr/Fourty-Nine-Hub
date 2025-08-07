import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/constants/subscription_status.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/format_numbers.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class BuildTagAdsWidget extends StatelessWidget {
  const BuildTagAdsWidget({
    super.key,
    required this.status,
    required this.views,
  });

  final String status;
  final num views;

  @override
  Widget build(BuildContext context) {
    // super premium
    return Container(
      // width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // color: status == SubscriptionStatus.premium.status
      //     ? Colors.amber
      //     : Colors.grey,
      // color: status == SubscriptionStatus.premium.status
      //     ? Colors.amber
      //     : status == SubscriptionStatus.regular.status
      //     ? Colors.blue
      //     : Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // if (status != SubscriptionStatus.notSubscribed.status) ...[
          //   Icon(
          //     Icons.workspace_premium_outlined,
          //     size: 55.w,
          //     color: status == SubscriptionStatus.premium.status
          //         ? AppColors.SECONDARY_COLOR
          //         : status == SubscriptionStatus.regular.status
          //             ? AppColors.PRIMARY_COLOR
          //             : null,
          //   ),
          //   const Sizer(width: 5)
          // ],
          SvgPicture.asset(
            Assets.adsEyeIcon,
            color: context.isDarkMode ? Colors.white : const Color(0xFF6C6C6C),
          ),
          const SizedBox(width: 6),
          if (views == 0) ...[
            Label(
              text: LocaleKeys.noViews.localize,
              style: Styles.mediumText(
                color:
                    context.isDarkMode ? Colors.white : const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else if (views == 1) ...[
            Label(
              text: LocaleKeys.oneView.localize,
              style: Styles.mediumText(
                color:
                    context.isDarkMode ? Colors.white : const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else if (views == 2) ...[
            Label(
              text: LocaleKeys.twoViews.localize,
              style: Styles.mediumText(
                color:
                    context.isDarkMode ? Colors.white : const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else if (views >= 3 && views <= 10) ...[
            Label(
              text:
                  '${FormatNumbers().formatNumber(views, useArabicNumerals: context.isArabic)} ${LocaleKeys.views.localize}',
              style: Styles.mediumText(
                color:
                    context.isDarkMode ? Colors.white : const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else ...[
            Label(
              text:
                  '${FormatNumbers().formatNumber(views)} ${LocaleKeys.view.localize}',
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ],
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16,),
            margin: const EdgeInsets.symmetric( vertical: 4),
            decoration: BoxDecoration(
              color: status == SubscriptionStatus.premium.status
                  ? Colors.amber
                  : status == SubscriptionStatus.regular.status
                      ? Colors.blue
                      : Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Label(
              text: status == SubscriptionStatus.premium.status
                  ? LocaleKeys.premium2.localize
                  : status == SubscriptionStatus.regular.status
                      ? LocaleKeys.regular.localize
                      : LocaleKeys.notSubscribed.localize,
              style: Styles.mediumText(
                color: AppColors.getTextColor(context),
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.60,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
    // premium
    // regular
  }
}
