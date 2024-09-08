import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/app_notification_builder.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/styles.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: const HomeAppbar(
            color: Colors.red,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: LocaleKeys.notifications.localize,
                  style: Styles.headerText(),
                ),
                const Sizer(),
                TabBar(
                  isScrollable: false,
                  // physics: const RangeMaintainingScrollPhysics(),
                  // dragStartBehavior: DragStartBehavior.down,
                  tabs: [
                    Tab(
                      icon: SvgPicture.asset(Assets.social,
                          height: 20, semanticsLabel: 'social'),
                    ),
                    Tab(
                      icon: Image.asset(
                        Assets.hand,
                        height: 20,
                      ),
                    ),
                    Tab(
                      icon: Image.asset(
                        Assets.logo,
                        height: 20,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      GestureDetector(
                        onHorizontalDragStart: (_) {},
                        onHorizontalDragEnd: (_) {},
                        child: const AppNotificationBuilder(),
                      ),
                      GestureDetector(
                        onHorizontalDragStart: (_) {},
                        onHorizontalDragEnd: (_) {},
                        child: const AppNotificationBuilder(),
                      ),
                      GestureDetector(
                        onHorizontalDragStart: (_) {},
                        onHorizontalDragEnd: (_) {},
                        child: const AppNotificationBuilder(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
