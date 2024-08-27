import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/api_service.dart';
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
          NotificationsCubit(NotificationRepoImpl(ApiService(Dio())))..fetchNotification('app'),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (BuildContext context, state) {
          return DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: const HomeAppbar(
                  color: Colors.red,
                ),
                body: state is NotificationsSuccessState
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Label(
                                  text: LocaleKeys.notifications.localize,
                                  //  text: state.notificationModel.data!.docs![0].bodyTranslationCode!,
                                  style: Styles.headerText(),
                                ),
                                TextAppButton(
                                    style: const TextStyle(color: AppColors.SECONDARY_COLOR),
                                    label: LocaleKeys.clearAll.localize,
                                    onPressed: () {
                                      showAreYouSure(
                                          title: LocaleKeys.alert.localize,
                                          subTitle: LocaleKeys.clearNotification.localize,
                                          action: () {},
                                          context: context);
                                    }),
                              ],
                            ),
                            const Sizer(),
                            TabBar(tabs: [
                              Tab(
                                icon: SvgPicture.asset(Assets.social, height: 20, semanticsLabel: 'social'),
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
                              const SizedBox.shrink(),
                              const SizedBox.shrink(),
                              state.notificationModel.data!.docs!.isNotEmpty
                                  ? _buildNotificationWidget(state: state)
                                  : Center(
                                      child: Text(
                                        'There are no notifications.',
                                        style: Styles.mediumText(fontSize: 35),
                                      ),
                                    ),
                            ]))
                          ],
                        ))
                    : const Center(child: CircularProgressIndicator()),
              ));
        },
      ),
    );
  }

  Widget _buildNotificationWidget({
    // required NotificationDoc notificationDoc,
    required state,
  }) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {},
      child: ListView.separated(
          itemBuilder: (context, index) {
            return NotificationCard(
              notificationDoc: state.notificationModel.data!.docs[index],
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: state.notificationModel.data!.docs!.length),
    );
  }
}
