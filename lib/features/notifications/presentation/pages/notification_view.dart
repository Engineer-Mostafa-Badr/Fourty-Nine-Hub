import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/wallet_widget.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/notifications/data/models/notification_model.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_card.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/all_trip_model/all_trip_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/trip_card.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../res/assets/assets.dart';
import '../../../../res/style/styles.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Label(
                      text: 'Notifications',
                      style: Styles.headerText(),
                    ),
                    TextAppButton(
                        style:
                            const TextStyle(color: AppColors.SECONDARY_COLOR),
                        label: 'Clear All',
                        onPressed: () {
                          showAreYouSure(
                              title: 'Alert',
                              subTitle:
                                  'Are you sure you want to clear all notifications?',
                              action: () {},
                              context: context);
                        }),
                  ],
                ),
                // const WalletWidget(),
                TabBar(tabs: [
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
                ]),
                Expanded(
                    child: TabBarView(children: [
                  _buildNotificationWidget(notificationList: []),
                  _buildHandNotificationWidget(notificationList: []),
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
      child: Container()
    );
  }
   Widget _buildHandNotificationWidget({
    required List<NotificationModel> notificationList,
  }) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 7,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text("12:12"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text("12/5/2024"),
          ),
            ],
          ),
          NotificationDriverCard(
            priceFontSize: 40,
                  model: AllTripModel(adminIgnore: false, time: "12:30:45", desc: "lskd", price: 12, targetLocation: "to location", startLocation: "from location"),
                ),
          SizedBox(height: 8,),
          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: GestureDetector(
                              onTap: () {
                                //هتروح لي صفحه subscription
                                serviceLocator<SubscriptionController>().showActiveSubscriptionAmounts(walletType: WalletTypes.balance);
                              },
                              child: Text(
                                "Subscribe to send offer / contact the client",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
                              ),
                            ))
        ],
      ),
    );
  }
}
