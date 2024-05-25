import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/wallet_widget.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/notifications/data/models/notification_model.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_card.dart';
import 'package:fourtyninehub/res/style/const.dart';

import '../../../../res/style/styles.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: const HomeAppbar(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: 'Notifications',
                  style: Styles.headerText(),
                ),
                const WalletWidget(),
                const TabBar(tabs: [
                  Tab(
                    text: 'Social',
                  ),
                  Tab(
                    text: 'Service',
                  ),
                  Tab(
                    text: '49',
                  ),
                ]),
                Expanded(
                    child: TabBarView(children: [
                  _buildNotificationWidget(notificationList: []),
                  _buildNotificationWidget(notificationList: []),
                  _buildNotificationWidget(notificationList: []),
                ]))
              ],
            ),
          ),
        ));
  }

  Widget _buildNotificationWidget({
    required List<NotificationModel> notificationList,
  }) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {},
      child: ListView.separated(
          itemBuilder: (context, index) {
            return NotificationCard(
              item: NotificationModel(
                  id: 0,
                  message: UIConst.placeholderText,
                  itemId: 0,
                  createdAt: DateTime.now()),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: 10),
    );
  }
}
