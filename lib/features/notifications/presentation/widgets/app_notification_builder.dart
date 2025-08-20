import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/all_notifications_seen/all_notfications_seen_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/delete_all_notifications/delete_all_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/delete_notification/delete_notification_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_app_notifications/get_app_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_seen/notification_seen_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/no_notifications_widget.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_card.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_card_loading.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/see_and_clear_buttons.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

class AppNotificationBuilder extends StatefulWidget {
  const AppNotificationBuilder({
    super.key,
  });

  @override
  State<AppNotificationBuilder> createState() => _AppNotificationBuilderState();
}

class _AppNotificationBuilderState extends State<AppNotificationBuilder> {
  late final ScrollController scrollController;
  late double scrollPosition;
  late double scrollMaxExtent;
  bool isLoading = false;

  late GetAppNotificationsCubit getAppNotificationsCubit;
  late final NotificationSeenCubit notificationSeenCubit;
  late final GetUnreadNotificationsCountCubit getUnreadNotificationsCountCubit;
  late final DeleteNotificationCubit deleteNotificationCubit;
  late final DeleteAllNotificationsCubit deleteAllNotificationsCubit;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetAppNotificationsCubit, GetAppNotificationsState>(
      listener: (context, state) {
        if (state is GetAppNotificationsFailed) {
          showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is GetAppNotificationsSuccess &&
            getAppNotificationsCubit.notifications.isEmpty) {
          return const NoNotificationsWidget();
        }
        return GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: AppColors.SECONDARY_COLOR,
          child: ListView.builder(
            controller: scrollController,
            itemCount: getAppNotificationsCubit.notifications.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SeeAndClearButtons(
                  seeAllCallback: () async {
                    context
                        .read<AllNotficationsSeenCubit>()
                        .allNotificationSeen(type: 'app')
                        .then(
                          (value) => context
                              .read<GetUnreadNotificationsCountCubit>()
                              .getUnreadNotificationsCount(),
                        );
                    context
                        .read<GetAppNotificationsCubit>()
                        .notifications
                        .forEach((element) {
                      element.read = true;
                    });
                  },
                  clearAllCallback: () async {
                    await deleteAllNotificationsCubit.deleteAllNotifications(
                        type: 'app');
                    getAppNotificationsCubit.notifications = [];
                    getAppNotificationsCubit.page = 1;
                    await getAppNotificationsCubit.getAppNotifications(
                        languageCode: 'en');
                    await getUnreadNotificationsCountCubit
                        .getUnreadNotificationsCount();
                  },
                );
              }
              index--;
              if (index < getAppNotificationsCubit.notifications.length) {
                final NotificationEntity notificationEntity =
                    getAppNotificationsCubit.notifications[index];
                return NotificationCard(
                  notificationEntity: notificationEntity,
                  index: index,
                  notificationSeenCallback: () {
                    print("objectPaaaaaaaaaaaaaaath${notificationEntity.path}");
                    notificationEntity.read = true;
                    notificationSeenCubit
                        .notificationSeen(id: notificationEntity.id ?? '')
                        .then(
                          (value) => getUnreadNotificationsCountCubit
                              .getUnreadNotificationsCount()
                              .then((value) => context.push(
                                  notificationEntity.path ?? '',
                                  extra: notificationEntity.payload)),
                        );
                  },
                  notificationDeleteCallback: () {
                    deleteNotificationCubit.deleteNotification(
                        id: notificationEntity.id ?? '');
                    getAppNotificationsCubit.notifications.removeAt(index);
                  },
                );
              }
              return state is GetAppNotificationsLoading
                  ? const NotificationCardLoadingList()
                  : const SizedBox();
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getAppNotificationsCubit = context.read<GetAppNotificationsCubit>();
    notificationSeenCubit = context.read<NotificationSeenCubit>();
    getUnreadNotificationsCountCubit =
        context.read<GetUnreadNotificationsCountCubit>();
    deleteNotificationCubit = context.read<DeleteNotificationCubit>();
    deleteAllNotificationsCubit = context.read<DeleteAllNotificationsCubit>();
    _fetchNotificationsIfEmpty();
    _scrollListener();
    super.initState();
  }

  void _fetchNotificationsIfEmpty() {
    if (getAppNotificationsCubit.notifications.isEmpty) {
      getAppNotificationsCubit.page = 1;
      getAppNotificationsCubit.getAppNotifications(languageCode: 'en');
    }
  }

  void _scrollListener() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      scrollPosition = scrollController.position.pixels;
      scrollMaxExtent = scrollController.position.maxScrollExtent;
      if (scrollPosition >= 0.7 * scrollMaxExtent) {
        if (!isLoading &&
            (getAppNotificationsCubit.notifications.last.hasNextPage ??
                false)) {
          isLoading = true;
          getAppNotificationsCubit.page =
              getAppNotificationsCubit.notifications.last.nextPageNumber!;
          await getAppNotificationsCubit.getAppNotifications(
              languageCode: Localizations.localeOf(context).languageCode);
          isLoading = false;
        }
      }
    });
  }
}
