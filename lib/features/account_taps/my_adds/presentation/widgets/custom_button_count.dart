import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';

class CustomButtonCount extends StatelessWidget {
  const CustomButtonCount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Request Trip Join',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
        child: ListView.separated(
          itemBuilder: (context,index)=>buildItem(context),
          separatorBuilder: (context,index)=>const Sizer(),
          itemCount: 10,
        ),
      ),
    );
  }

  Widget buildItem(context) => Container(
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: Theme.of(context).primaryColor,width: 1),
    ),
    child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 75.r,
                  backgroundImage: const NetworkImage(
                      'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg'),
                ),
                const Sizer(),
                Label(
                  text: 'Moaz',
                  style: Styles.headerText(),
                ),
              ],
            ),
            Sizer(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AvaialbleTripsButton(
                    title: LocaleKeys.call.localize,
                    icon: Icons.phone,
                    color: AppColors.PRIMARY_COLOR,
                    onTap: () {},
                  ),
                ),
                Sizer(width: 10.w),
                Expanded(
                  flex: 3,
                  child: AvaialbleTripsButton(
                    title: LocaleKeys.message.localize,
                    icon: Icons.mail,
                    color: AppColors.PRIMARY_COLOR,
                    onTap: () {},
                  ),
                ),
                Sizer(width: 10.w),
                Expanded(
                  flex: 3,
                  child: AvaialbleTripsButton(
                    title: LocaleKeys.report.localize,
                    icon: Icons.report,
                    color: AppColors.SECONDARY_COLOR,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
  );
}
