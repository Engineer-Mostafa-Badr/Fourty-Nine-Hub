import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../core/data/models/notification_model.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/assets/assets.dart';

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
          Builder(
            builder: (BuildContext context) {
              return Column(
                children: [
                  // state is! DeleteNotificationsLoadingState
                  //     ?
                  IconAppButton(
                      icon: Icons.clear,
                      onPressed: () {
                        showAreYouSure(
                            title: LocaleKeys.alert.localize,
                            subTitle: LocaleKeys.clearNoti.localize,
                            action: () {
                              // NotificationsCubit.get(context)
                              //     .deleteNotification(
                              //         id: notificationDoc.id!);
                            },
                            context: context);
                      })
                  // : IconAppButton(icon: Icons.clear, onPressed: () {}),
                  ,
                  Label(
                    text: formattedTime,
                    style: Styles.mediumText(color: Colors.grey),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
