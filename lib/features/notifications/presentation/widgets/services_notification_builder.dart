import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/all_notifications_seen/all_notfications_seen_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/delete_all_notifications/delete_all_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/delete_notification/delete_notification_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_services_notifications/get_services_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_seen/notification_seen_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/no_notifications_widget.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_card.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_card_loading.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/see_and_clear_buttons.dart';
import 'package:go_router/go_router.dart';

class ServicesNotificationBuilder extends StatefulWidget {
  const ServicesNotificationBuilder({
    super.key,
  });

  @override
  State<ServicesNotificationBuilder> createState() =>
      _ServicesNotificationBuilderState();
}

class _ServicesNotificationBuilderState
    extends State<ServicesNotificationBuilder> {
  late final ScrollController scrollController;
  late double scrollPosition;
  late double scrollMaxExtent;
  bool isLoading = false;

  late GetServicesNotificationsCubit getServicesNotificationsCubit;
  late final NotificationSeenCubit notificationSeenCubit;
  late final GetUnreadNotificationsCountCubit getUnreadNotificationsCountCubit;
  late final DeleteNotificationCubit deleteNotificationCubit;
  late final DeleteAllNotificationsCubit deleteAllNotificationsCubit;
  @override
  void initState() {
    getServicesNotificationsCubit =
        context.read<GetServicesNotificationsCubit>();
    notificationSeenCubit = context.read<NotificationSeenCubit>();
    getUnreadNotificationsCountCubit =
        context.read<GetUnreadNotificationsCountCubit>();
    deleteNotificationCubit = context.read<DeleteNotificationCubit>();
    deleteAllNotificationsCubit = context.read<DeleteAllNotificationsCubit>();
    _fetchNotificationsIfEmpty();
    _scrollListener();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _fetchNotificationsIfEmpty();
    return BlocConsumer<GetServicesNotificationsCubit,
        GetServicesNotificationsState>(
      listener: (context, state) {
        if (state is GetServicesNotificationsFailed) {
          showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is GetServicesNotificationsSuccess &&
            getServicesNotificationsCubit.notifications.isEmpty) {
          return const NoNotificationsWidget();
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: getServicesNotificationsCubit.notifications.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return SeeAndClearButtons(
                seeAllCallback: () async {
                  context
                      .read<AllNotficationsSeenCubit>()
                      .allNotificationSeen(type: 'services')
                      .then(
                        (value) => context
                            .read<GetUnreadNotificationsCountCubit>()
                            .getUnreadNotificationsCount(),
                      );
                  context
                      .read<GetServicesNotificationsCubit>()
                      .notifications
                      .forEach((element) {
                    element.read = true;
                  });
                },
                clearAllCallback: () async {
                  await deleteAllNotificationsCubit.deleteAllNotifications(
                      type: 'services');
                  getServicesNotificationsCubit.notifications = [];
                  getServicesNotificationsCubit.page = 1;
                  await getServicesNotificationsCubit
                      .getServicesNotifications();
                  await getUnreadNotificationsCountCubit
                      .getUnreadNotificationsCount();
                },
              );
            }
            index--;
            if (index < getServicesNotificationsCubit.notifications.length) {
              final NotificationEntity notificationEntity =
                  getServicesNotificationsCubit.notifications[index];
              return NotificationCard(
                type: 'services',
                notificationEntity: notificationEntity,
                index: index,
                notificationSeenCallback: () {
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
                  getServicesNotificationsCubit.notifications.removeAt(index);
                },
              );
            }
            return state is GetServicesNotificationsLoading
                ? const NotificationCardLoadingList()
                : const SizedBox();
          },
        );
      },
    );
  }

  void _scrollListener() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      scrollPosition = scrollController.position.pixels;
      scrollMaxExtent = scrollController.position.maxScrollExtent;
      if (scrollPosition >= 0.7 * scrollMaxExtent) {
        if (!isLoading &&
            (getServicesNotificationsCubit.notifications.last.hasNextPage ??
                false)) {
          isLoading = true;
          getServicesNotificationsCubit.page =
              getServicesNotificationsCubit.notifications.last.nextPageNumber!;
          await getServicesNotificationsCubit.getServicesNotifications();
          isLoading = false;
        }
      }
    });
  }

  void _fetchNotificationsIfEmpty() {
    if (getServicesNotificationsCubit.notifications.isEmpty) {
      getServicesNotificationsCubit.page = 1;
      // getServicesNotificationsCubit.notifications = [];
      getServicesNotificationsCubit.getServicesNotifications();
    }
  }
}
