import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_app_notifications/get_app_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/no_notifications_widget.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_card.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_card_loading.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/see_and_clear_buttons.dart';

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
  int nextPage = 1;
  bool isLoading = false;

  late GetAppNotificationsCubit getAppNotificationsCubit;

  @override
  void initState() {
    getAppNotificationsCubit = context.read<GetAppNotificationsCubit>();
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
    return BlocConsumer<GetAppNotificationsCubit, GetAppNotificationsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is GetAppNotificationsSuccess && getAppNotificationsCubit.notifications.isEmpty) {
          return const NoNotificationsWidget();
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: getAppNotificationsCubit.notifications.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return SeeAndClearButtons(
                seeAllCallback: () {},
                clearAllCallback: () {},
              );
            }
            index--;
            if (index < getAppNotificationsCubit.notifications.length) {
              return NotificationCard(notificationEntity: getAppNotificationsCubit.notifications[index]);
            }
            return state is GetAppNotificationsLoading ? const NotificationCardLoadingList() : const SizedBox();
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
        if (!isLoading && (getAppNotificationsCubit.notifications.last.hasNextPage ?? false)) {
          isLoading = true;
          getAppNotificationsCubit.page = getAppNotificationsCubit.notifications.last.nextPageNumber!;
          await getAppNotificationsCubit.getAppNotifications();
          nextPage++;
          isLoading = false;
        }
      }
    });
  }

  void _fetchNotificationsIfEmpty() {
    if (getAppNotificationsCubit.notifications.isEmpty) {
      getAppNotificationsCubit.page = 1;
      getAppNotificationsCubit.getAppNotifications();
    }
  }
}
