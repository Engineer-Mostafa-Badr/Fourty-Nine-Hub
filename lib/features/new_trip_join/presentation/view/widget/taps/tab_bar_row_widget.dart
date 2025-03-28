import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../res/assets/assets.dart';
import 'tab_item_widget.dart';

class TabBarRowWidget extends StatelessWidget {
  final TabController tabController;
  const TabBarRowWidget({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TabItemWidget(
            text: "Available\nTrips",
            icon: Assets.ideaIcon,
            index: 0,
            tabController: tabController),
        SizedBox(width: 28.w),
        TabItemWidget(
            text: "My\nBookings",
            icon: Assets.ideaIcon,
            index: 1,
            tabController: tabController),
        SizedBox(width: 28.w),
        TabItemWidget(
            text: "Running\nTrips",
            icon: Assets.ideaIcon,
            index: 2,
            tabController: tabController),
        SizedBox(width: 28.w),
        TabItemWidget(
            text: "Expired\nTrips",
            icon: Assets.ideaIcon,
            index: 3,
            tabController: tabController),
      ],
    );
  }
}
