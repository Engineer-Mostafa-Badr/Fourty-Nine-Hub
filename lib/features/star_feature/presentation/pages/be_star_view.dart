import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import 'widgets/floating_action_button_star.dart';

class BeStarView extends StatelessWidget {
  const BeStarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.beAStar.localize,
        actions: [
          TextButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Winners()),
              // );
            },
            child: Text(
              '${LocaleKeys.winners.localize} 🏆',
              style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(Assets.star),
                ),
              ),
            ),
            const Sizer(),
            const Label(
              text: 'You have a talent or special unique content!',
              color: AppColors.SECONDARY_COLOR,
            ),
            const Sizer(),
            const Label(
              textAlign: TextAlign.center,
              text: 'Share it with the users and win 10000 EGP every month!!!',
              color: AppColors.SECONDARY_COLOR,
              maxLines: 3,
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButtonStar(),
    );
  }
}
