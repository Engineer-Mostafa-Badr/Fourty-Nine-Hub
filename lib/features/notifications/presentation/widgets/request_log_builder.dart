import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/ride_widget.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_user_trips_notifications/get_user_trips_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/see_and_clear_buttons.dart';

import '../../../../core/messages/messages.dart';
import '../../domain/entities/user_trip_entity.dart';
import 'no_notifications_widget.dart';
import 'notification_card_loading.dart';

class StatusRequestLogBuilder extends StatelessWidget {
  const StatusRequestLogBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    GetUserTripsNotificationsCubit getUserTripsNotificationsCubit =
        context.read<GetUserTripsNotificationsCubit>();

    return BlocConsumer<GetUserTripsNotificationsCubit,
        GetUserTripsNotificationsState>(
      listener: (context, state) {
        if (state is GetUserTripsNotificationsFailed) {
          showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is GetUserTripsNotificationsSuccess &&
            getUserTripsNotificationsCubit.userTrips.isEmpty) {
          return const NoNotificationsWidget();
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: getUserTripsNotificationsCubit.userTrips.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return SeeAndClearButtons(
                seeAllCallback: () async {
                  // context
                  //     .read<AllNotficationsSeenCubit>()
                  //     .allNotificationSeen(type: 'services')
                  //     .then(
                  //       (value) => context
                  //       .read<GetUnreadNotificationsCountCubit>()
                  //       .getUnreadNotificationsCount(),
                  // );
                  // context
                  //     .read<GetServicesNotificationsCubit>()
                  //     .notifications
                  //     .forEach((element) {
                  //   element.read = true;
                  // });
                },
                clearAllCallback: () async {
              //     await deleteAllNotificationsCubit.deleteAllNotifications(
              //         type: 'services');
              //     getServicesNotificationsCubit.notifications = [];
              //     getServicesNotificationsCubit.page = 1;
              //     await getServicesNotificationsCubit.getServicesNotifications(
              //         languageCode: 'en');
              //     await getUnreadNotificationsCountCubit
              //         .getUnreadNotificationsCount();
                },
              );
            }
            index--;
            if (index < getUserTripsNotificationsCubit.userTrips.length) {
              final UserTripEntity userTripEntity =
              getUserTripsNotificationsCubit.userTrips[index];
              return RideWidget(
                isTruck: true,
                isDriver: false,
                isSubscribed: true,
                userTripEntity: userTripEntity,
              );
            }
            return state is GetUserTripsNotificationsLoading
                ? const NotificationCardLoadingList()
                : const SizedBox();
          },
          separatorBuilder: (BuildContext context, int index) => const Sizer(),
        );
      },
    );
  }
}
