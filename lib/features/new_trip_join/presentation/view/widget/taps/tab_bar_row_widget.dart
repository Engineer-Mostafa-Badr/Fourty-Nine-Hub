import 'package:flutter/material.dart';

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
        const SizedBox(width: 10),
        TabItemWidget(
            text: "My\nBookings",
            icon: Assets.ideaIcon,
            index: 1,
            tabController: tabController),
        const SizedBox(width: 10),
        TabItemWidget(
            text: "Running\nTrips",
            icon: Assets.ideaIcon,
            index: 2,
            tabController: tabController),
        const SizedBox(width: 4),
        TabItemWidget(
            text: "Expired\nTrips",
            icon: Assets.ideaIcon,
            index: 3,
            tabController: tabController),
      ],
    );
  }
}
