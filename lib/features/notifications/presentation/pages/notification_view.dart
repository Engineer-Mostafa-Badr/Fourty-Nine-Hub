// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/all_notifications_seen/all_notfications_seen_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_seen/notification_seen_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/app_icon_builder.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/app_notification_builder.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/services_icon_builder.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/social_icon_builder.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/styles.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
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
                      text: LocaleKeys.notifications.localize,
                      style: Styles.headerText(),
                    ),
                    const Sizer(),
                    const TabBar(
                      tabs: [
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
                            child: const AppNotificationBuilder(),
                          ),
                          GestureDetector(
                            onHorizontalDragStart: (_) {},
                            onHorizontalDragEnd: (_) {},
                            child: const AppNotificationBuilder(),
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
