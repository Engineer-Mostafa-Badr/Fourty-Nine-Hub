// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/all_notifications_seen/all_notfications_seen_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/delete_all_notifications/delete_all_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/delete_notification/delete_notification_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_seen/notification_seen_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/app_icon_builder.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/app_notification_builder.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/services_icon_builder.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/services_notification_builder.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/social_icon_builder.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/social_notification_builder.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/styles.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

int index = 0;
List<String> titles = [
  LocaleKeys.serviceNoifications.localize,
  LocaleKeys.socialNotifications.localize,
  LocaleKeys.fourtyNineNotifications.localize,
];

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    // serviceLocator<FirebaseHelper>().getToken();
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationSeenCubit>(
          create: (context) => NotificationSeenCubit(
            notificationSeenUseCase: serviceLocator(),
          ),
        ),
        BlocProvider<AllNotficationsSeenCubit>(
          create: (context) => AllNotficationsSeenCubit(
            allNotificationSeenUseCase: serviceLocator(),
          ),
        ),
        BlocProvider<DeleteNotificationCubit>(
          create: (context) => DeleteNotificationCubit(
            deleteNotificationUseCase: serviceLocator(),
          ),
        ),
        BlocProvider<DeleteAllNotificationsCubit>(
          create: (context) => DeleteAllNotificationsCubit(
            deleteAllNotificationsUseCase: serviceLocator(),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<NotificationSeenCubit, NotificationSeenState>(
            listener: (context, state) {
              if (state is NotificationSeenFailed) {
                showErrorMessage(context, state.message);
              }
            },
          ),
          BlocListener<AllNotficationsSeenCubit, AllNotficationsSeenState>(
            listener: (context, state) {
              if (state is AllNotficationsSeenFailed) {
                showErrorMessage(context, state.message);
              }
            },
          ),
          BlocListener<DeleteNotificationCubit, DeleteNotificationState>(
            listener: (context, state) {
              if (state is DeleteNotificationFailed) {
                showErrorMessage(context, state.message);
              }
            },
          ),
          BlocListener<DeleteAllNotificationsCubit,
              DeleteAllNotificationsState>(
            listener: (context, state) {
              if (state is DeleteAllNotificationsFailed) {
                showErrorMessage(context, state.message);
              }
            },
          ),
        ],
        child: DefaultTabController(
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
                      text: titles[index],
                      style: Styles.headerText(),
                    ),
                    const Sizer(),
                    TabBar(
                      onTap: (value) {
                        index = value;
                        setState(() {});
                      },
                      tabs: const [
                        SocialIconBuilder(),
                        ServicesIconBuilder(),
                        AppIconBuilder(),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          GestureDetector(
                            onHorizontalDragStart: (_) {},
                            onHorizontalDragEnd: (_) {},
                            child: const SocialNotificationBuilder(),
                          ),
                          GestureDetector(
                            onHorizontalDragStart: (_) {},
                            onHorizontalDragEnd: (_) {},
                            child: const ServicesNotificationBuilder(),
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
        ),
      ),
    );
  }
}
