import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../../res/assets/assets.dart';
import 'tab_item_widget.dart';

class TabBarRowWidget extends StatelessWidget {
  final TabController tabController;
  final void Function()? onTap;
  const TabBarRowWidget({super.key, required this.tabController, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TabItemWidget(
            onTap: onTap,
            text: context.isArabic ? "رحلات \n متاحه" : "Available\nTrips",
            icon: Assets.ideaIcon,
            index: 0,
            tabController: tabController),
        SizedBox(width: 28.w),
        TabItemWidget(
            onTap: onTap,
            text: context.isArabic ? "حجوزاتي" : "My\nBookings",
            icon: Assets.ideaIcon,
            index: 1,
            tabController: tabController),
        SizedBox(width: 28.w),
        TabItemWidget(
            onTap: onTap,
            text: context.isArabic ? "رحلات \nجارية " : "Running\nTrips",
            icon: Assets.ideaIcon,
            index: 2,
            tabController: tabController),
        SizedBox(width: 28.w),
        TabItemWidget(
          onTap: onTap,
          text: context.isArabic ? "رحلات \n منتهية " : "Expired\nTrips",
          icon: Assets.ideaIcon,
          index: 3,
          tabController: tabController,
        ),
      ],
    );
  }
}
