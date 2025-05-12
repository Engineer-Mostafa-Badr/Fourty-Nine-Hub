import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

class TopNavigationBarProfileInstagarm extends StatelessWidget {
  const TopNavigationBarProfileInstagarm({
    super.key,
    required this.tabController,
    required this.onTap,
  });

  final TabController tabController;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          onTap: onTap,
          dividerHeight: 0,
          indicatorColor: context.isDarkMode ? Colors.white : Colors.black,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
          indicatorWeight: 2,
          padding: const EdgeInsets.only(bottom: 4),
          tabs: [
            Tab(
              height: 44,
              child: SvgPicture.asset(
                tabController.index == 0
                    ? (context.isDarkMode
                        ? Assets.appsBlackIconDark
                        : Assets.appsBlackIcon)
                    : (context.isDarkMode
                        ? Assets.appsGreyIconDark
                        : Assets.appsGreyIcon),
              ),
            ),
            Tab(
              height: 44,
              child: SvgPicture.asset(
                tabController.index == 1
                    ? (context.isDarkMode
                        ? Assets.videoIconDark
                        : Assets.videoIcon)
                    : (context.isDarkMode
                        ? Assets.videoGreyIconDark
                        : Assets.videoGreyIcon),
              ),
            ),
            Tab(
              height: 44,
              child: SvgPicture.asset(
                tabController.index == 2
                    ? (context.isDarkMode
                        ? Assets.profile2BlackIconDark
                        : Assets.profile2BlackIcon)
                    : (context.isDarkMode
                        ? Assets.profile2GreyIconDark
                        : Assets.profile2GreyIcon),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
