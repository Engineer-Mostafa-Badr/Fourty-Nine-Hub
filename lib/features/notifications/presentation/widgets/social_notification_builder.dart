import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/all_notifications_seen/all_notfications_seen_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/delete_all_notifications/delete_all_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/delete_notification/delete_notification_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_social_notifications/get_social_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_seen/notification_seen_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/no_notifications_widget.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_card.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_card_loading.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/see_and_clear_buttons.dart';
import 'package:go_router/go_router.dart';

class SocialNotificationBuilder extends StatefulWidget {
  const SocialNotificationBuilder({
    super.key,
  });

  @override
  State<SocialNotificationBuilder> createState() =>
      _SocialNotificationBuilderState();
}

class _SocialNotificationBuilderState extends State<SocialNotificationBuilder> {
  late final ScrollController scrollController;
  late double scrollPosition;
  late double scrollMaxExtent;
  int nextPage = 1;
  bool isLoading = false;

  late GetSocialNotificationsCubit getSocialNotificationsCubit;
  late final NotificationSeenCubit notificationSeenCubit;
  late final GetUnreadNotificationsCountCubit getUnreadNotificationsCountCubit;
  late final DeleteNotificationCubit deleteNotificationCubit;
  late final DeleteAllNotificationsCubit deleteAllNotificationsCubit;
  @override
  void initState() {
    getSocialNotificationsCubit = context.read<GetSocialNotificationsCubit>();
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
    return BlocConsumer<GetSocialNotificationsCubit,
        GetSocialNotificationsState>(
      listener: (context, state) {
        if (state is GetSocialNotificationsFailed) {
          showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is GetSocialNotificationsSuccess &&
            getSocialNotificationsCubit.notifications.isEmpty) {
          return const NoNotificationsWidget();
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: getSocialNotificationsCubit.notifications.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return SeeAndClearButtons(
                seeAllCallback: () async {
                  context
                      .read<AllNotficationsSeenCubit>()
                      .allNotificationSeen(type: 'social')
                      .then(
                        (value) => context
                            .read<GetUnreadNotificationsCountCubit>()
                            .getUnreadNotificationsCount(),
                      );
                  context
                      .read<GetSocialNotificationsCubit>()
                      .notifications
                      .forEach((element) {
                    element.read = true;
                  });
                },
                clearAllCallback: () async {
                  await deleteAllNotificationsCubit.deleteAllNotifications(
                      type: 'social');
                  getSocialNotificationsCubit.notifications = [];
                  getSocialNotificationsCubit.page = 1;
                  await getSocialNotificationsCubit.getSocialNotifications();
                  await getUnreadNotificationsCountCubit
                      .getUnreadNotificationsCount();
                },
              );
            }
            index--;
            if (index < getSocialNotificationsCubit.notifications.length) {
              final NotificationEntity notificationEntity =
                  getSocialNotificationsCubit.notifications[index];
              return NotificationCard(
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
                  getSocialNotificationsCubit.notifications.removeAt(index);
                },
              );
            }
            return state is GetSocialNotificationsLoading
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
            (getSocialNotificationsCubit.notifications.last.hasNextPage ??
                false)) {
          isLoading = true;
          getSocialNotificationsCubit.page =
              getSocialNotificationsCubit.notifications.last.nextPageNumber!;
          await getSocialNotificationsCubit.getSocialNotifications();
          nextPage++;
          isLoading = false;
        }
      }
    });
  }

  void _fetchNotificationsIfEmpty() {
    if (getSocialNotificationsCubit.notifications.isEmpty) {
      getSocialNotificationsCubit.page = 1;
      getSocialNotificationsCubit.getSocialNotifications();
    }
  }
}
