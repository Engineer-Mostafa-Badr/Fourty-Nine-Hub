import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/wallet_widget.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../core/data/models/notification_model.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/styles.dart';
import '../../data/repository/notification_repo_impl.dart';
import '../cubit/notifications_cubit.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      NotificationsCubit(NotificationRepoImpl(ApiService(Dio())))..fetchNotification(),
      child: BlocBuilder<NotificationsCubit,NotificationsState>(
        builder: (BuildContext context, state) {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: const HomeAppbar(
                  color: Colors.red,
                ),
                body:state is NotificationsSuccessState? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(
                            //text: state.notificationModel.message!,
                              text: state.notificationModel.data!.docs![0].bodyTranslationCode!,
                            style: Styles.headerText(),
                          ),
                          TextAppButton(
                              style: const TextStyle(
                                  color: AppColors.SECONDARY_COLOR),
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
                      const WalletWidget(),
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
                            _buildNotificationWidget(notificationList: []),
                            _buildNotificationWidget(notificationList: []),
                          ]))
                    ],
                  ),
                ):const Center(child: CircularProgressIndicator()),
              ));
        },
      ),
    );
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
                  // id: 0,
                  // message: UIConst.placeholderText,
                  // itemId: 0,
                  // createdAt: DateTime.now(),
                  ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: 10),
    );
  }
}
