import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:intl/intl.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';

import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../core/data/models/notification_model.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../res/assets/assets.dart';
import '../../data/repository/notification_repo_impl.dart';
import '../cubit/notifications_cubit.dart';

class NotificationCard extends StatelessWidget {
  final NotificationDoc notificationDoc;

  const NotificationCard({super.key, required this.notificationDoc});

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt = DateTime.parse('${notificationDoc.createdAt!}');

    // Convert the time to Egypt timezone (EET or EEST)
    final DateTime egyptTime = createdAt.toUtc().add(
        const Duration(hours: 3)); // EET is UTC+2, adjust for DST if necessary

    // Format the time for display
    final String formattedTime = DateFormat('h:mm a').format(egyptTime);
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          SizedBox(
            height: kToolbarHeight,
            width: kToolbarHeight,
            child: Image.asset(
              Assets.icon,
            ),
          ),
          // const Sizer(),
          Expanded(
            child: Text(
              notificationDoc.bodyTranslationCode!,
              style: Styles.mediumText(),
            ),
          ),
          BlocProvider(
            create: (BuildContext context) =>
            NotificationsCubit(NotificationRepoImpl(ApiService(Dio()))),
            child: BlocConsumer<NotificationsCubit,NotificationsState>(
              listener: (BuildContext context, NotificationsState state) {
                if(state is DeleteNotificationsSuccessState){
                  var snackBar = SnackBar(
                    content:  const Text('Delete Successfully'),
                    backgroundColor: Theme.of(context).primaryColor,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              builder: (BuildContext context, state) {
                return Column(
                  children: [
                   state is! DeleteNotificationsLoadingState? IconAppButton(
                        icon: Icons.clear,
                        onPressed: () {
                          showAreYouSure(
                              title: LocaleKeys.alert.localize,
                              subTitle: LocaleKeys.clearNoti.localize,
                              action: () {
                                NotificationsCubit.get(context)
                                    .deleteNotification(id: notificationDoc.id!);
                              },
                              context: context);
                        }):IconAppButton(icon: Icons.clear, onPressed: (){}),
                    Label(
                      text: formattedTime,
                      style: Styles.mediumText(color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
