import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/constants/subscription_status.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 16),
      // color: status == SubscriptionStatus.premium.status
      //     ? Colors.amber
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
          ),
          SizedBox(width: 6),
          if (views == 0) ...[
            Label(
              text: LocaleKeys.noViews.localize,
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else if (views == 1) ...[
            Label(
              text: LocaleKeys.oneView.localize,
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else if (views == 2) ...[
            Label(
              text: LocaleKeys.twoViews.localize,
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else if (views >= 3 && views <= 10) ...[
            Label(
              text: '$views ${LocaleKeys.views.localize}',
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
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
          Spacer(),
          Label(
            text: status == SubscriptionStatus.premium.status
                ? LocaleKeys.premiumSubscription.localize
                : status == SubscriptionStatus.regular.status
                    ? LocaleKeys.regularRequest.localize
                    : LocaleKeys.notSubscribed.localize,
            style: Styles.mediumText(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.60,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
    // premium
    // regular
  }
}
