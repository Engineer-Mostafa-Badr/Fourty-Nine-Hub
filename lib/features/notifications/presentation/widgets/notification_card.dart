import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/all_notifications_seen/all_notfications_seen_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_seen/notification_seen_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../res/assets/assets.dart';

class NotificationCard extends StatefulWidget {
  final NotificationEntity notificationEntity;

  const NotificationCard({super.key, required this.notificationEntity});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllNotficationsSeenCubit, AllNotficationsSeenState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            widget.notificationEntity.read = true;
            setState(() {});
            context.read<NotificationSeenCubit>().notificationSeen(id: widget.notificationEntity.id ?? '').then(
                  (value) => context.read<GetUnreadNotificationsCountCubit>().getUnreadNotificationsCount(),
                );
            context.push(widget.notificationEntity.path ?? '', extra: widget.notificationEntity.payload);
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.startToEnd,
              behavior: HitTestBehavior.translucent,
              confirmDismiss: (direction) async {
                bool result = false;
                await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 20),
                      child: AreYouSure(
                        title: LocaleKeys.alert.localize,
                        subTitle: LocaleKeys.clearNoti.localize,
                        action: () {
                          result = true;
                        },
                      ),
                    );
                  },
                );
                return result;
              },
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.red,
                alignment: Alignment.centerLeft,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: NotificationCustomContainer(
                color: widget.notificationEntity.read! ? Colors.transparent : AppColors.PRIMARY_COLOR.withOpacity(0.1),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.notificationEntity.title ?? '',
                            style: Styles.headerText(),
                          ),
                          const Sizer(height: 5),
                          Text(
                            widget.notificationEntity.body ?? '',
                            style: Styles.mediumText(),
                          ),
                          const Sizer(height: 5),
                          Label(
                            text: _formatDate(),
                            style: Styles.mediumText(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate() {
    if (widget.notificationEntity.createdAt == null) {
      return '';
    }
    return DateFormat('dd MMM, hh:mm aaa').format(widget.notificationEntity.createdAt!);
  }
}

class NotificationCustomContainer extends StatelessWidget {
  const NotificationCustomContainer({super.key, required this.color, required this.child});
  final Color color;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: child,
    );
  }
}
