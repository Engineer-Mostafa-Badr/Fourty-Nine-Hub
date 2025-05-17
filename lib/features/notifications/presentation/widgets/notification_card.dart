import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/all_notifications_seen/all_notfications_seen_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../res/assets/assets.dart';

class NotificationCard extends StatefulWidget {
  final NotificationEntity notificationEntity;
  final int index;
  final Function() notificationSeenCallback;
  final Function() notificationDeleteCallback;
  final String? type;

  const NotificationCard(
      {super.key,
      required this.notificationEntity,
      required this.index,
      required this.notificationSeenCallback,
      required this.notificationDeleteCallback,
      this.type});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllNotficationsSeenCubit, AllNotficationsSeenState>(
      builder: (context, state) {
        if (widget.notificationEntity.body == null ||
            widget.notificationEntity.title == null) {
          return Container();
        }
        return InkWell(
          onTap: () {
            widget.notificationSeenCallback();
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.all(5.w),
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
                          top: 20.h, right: 10.w, left: 10.w, bottom: 20.h),
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    : AppColors.PRIMARY_COLOR.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    Builder(builder: (context) {
                      if (widget.type == 'services') {
                        return Container(
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsetsDirectional.only(end: 15.w),
                          height: kToolbarHeight,
                          width: kToolbarHeight,
                          child: Image.network(
                            widget.notificationEntity.receiverId ==
                                    UserCubit.to.state.data?.id
                                ? UserCubit.to.state.data?.profilePicture ??
                                    Assets.maleImagePlaceholder
                                : widget.notificationEntity.gender == 'male'
                                    ? Assets.maleImagePlaceholder
                                    : Assets.femaleImagePlacehlder,
                            fit: BoxFit.fill,
                          ),
                        );
                      }
                      return Container(
                        height: kToolbarHeight,
                        width: kToolbarHeight,
                        margin: EdgeInsetsDirectional.only(end: 15.w),
                        child: widget.notificationEntity.userImageUrl == null
                            ? Image.asset(
                                Assets.icon,
                              )
                            : _networkImage(),
                      );
                    }),
                    // Sizer(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.notificationEntity.title?.isNotEmpty ??
                              false) ...[
                            Text(
                              context.isArabic
                                  ? convertToArabicNumbers(widget.notificationEntity.title??'')
                                  : _capitalizeTitle(
                                      widget.notificationEntity.title ?? ''),
                              style: Styles.headerText(
                                color: context.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Sizer(height: 5.h),
                          ],
                          Text(
                            context.isArabic?convertToArabicNumbers(widget.notificationEntity.body??'نتبيه غير معروف'):widget.notificationEntity.body ?? 'Unknown Notification Content',
                            style: Styles.mediumText(
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Sizer(height: 5.h),
                          Label(
                            text: _formatDate(),
                            style: Styles.mediumText(
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.grey,
                            ),
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

  String _capitalizeTitle(String title) {
    // return title;
    title = title.trim();
    List<String> words = title.split(' ');
    String? result;
    for (String word in words) {
      result =
          '${result == null ? "" : "$result "}${word[0].toUpperCase()}${word.substring(1)}';
    }
    return result ?? '';
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
    return DateFormat('dd MMM, hh:mm aaa', context.locale.languageCode)
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
