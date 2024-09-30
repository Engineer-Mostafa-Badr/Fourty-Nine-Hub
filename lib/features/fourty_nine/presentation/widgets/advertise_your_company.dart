import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class AdvertiseYourCompany extends StatelessWidget {
  const AdvertiseYourCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.CREATECOMPANYAD),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.SECONDARY_COLOR),
        child: Row(
          children: [
            const Icon(
              FontAwesomeIcons.bullhorn,
              color: Colors.white,
            ),
            const Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: 'Advertise your business',
                  style: Styles.mediumText(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Sizer(
                  height: 5.h,
                ),
                Label(
                  text:
                      'You can create ADs using text , images, or videos to advertise your business',
                  style: Styles.smallText(color: Colors.white),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
