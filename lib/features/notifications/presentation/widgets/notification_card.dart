import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/all_notifications_seen/all_notfications_seen_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../res/assets/assets.dart';

class NotificationCard extends StatefulWidget {
  final NotificationEntity notificationEntity;
  final int index;
  final Function() notificationSeenCallback;
  final Function() notificationDeleteCallback;
  const NotificationCard({
    super.key,
    required this.notificationEntity,
    required this.index,
    required this.notificationSeenCallback,
    required this.notificationDeleteCallback,
  });

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
            widget.notificationSeenCallback();
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.all(5),
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.startToEnd,
              behavior: HitTestBehavior.translucent,
              confirmDismiss: (direction) async {
                bool confirmDelete = false;
                await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.only(
                          top: 20, right: 10, left: 10, bottom: 20),
                      child: AreYouSure(
                        title: LocaleKeys.alert.localize,
                        subTitle: LocaleKeys.clearNoti.localize,
                        action: () {
                          confirmDelete = true;
                        },
                      ),
                    );
                  },
                );
                if (confirmDelete) {
                  widget.notificationDeleteCallback();
                }
                return confirmDelete;
              },
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.red,
                alignment: Alignment.centerLeft,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: NotificationCustomContainer(
                color: widget.notificationEntity.read!
                    ? Colors.transparent
                    : AppColors.PRIMARY_COLOR.withOpacity(0.1),
                child: Row(
                  children: [
                    SizedBox(
                      height: kToolbarHeight,
                      width: kToolbarHeight,
                      child: widget.notificationEntity.userImageUrl == null
                          ? Image.asset(
                              Assets.icon,
                            )
                          : _networkImage(),
                    ),
                    // Sizer(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.notificationEntity.title ?? '',
                            style: Styles.headerText(),
                          ),
                          Sizer(height: 5.h),
                          Text(
                            widget.notificationEntity.body ?? '',
                            style: Styles.mediumText(),
                          ),
                          Sizer(height: 5.h),
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

  Container _networkImage() {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.hardEdge,
      child: CachedNetworkImage(
        imageUrl: widget.notificationEntity.userImageUrl ?? '',
        placeholder: (context, url) => Image.asset(
          Assets.icon,
        ),
        errorWidget: (context, url, error) => Image.asset(
          Assets.icon,
        ),
        fit: BoxFit.cover,
      ),
    );
  }

  String _formatDate() {
    if (widget.notificationEntity.createdAt == null) {
      return '';
    }
    return DateFormat('dd MMM, hh:mm aaa')
        .format(widget.notificationEntity.createdAt!);
  }
}

class NotificationCustomContainer extends StatelessWidget {
  const NotificationCustomContainer(
      {super.key, required this.color, required this.child});
  final Color color;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5.h),
      child: child,
    );
  }
}
