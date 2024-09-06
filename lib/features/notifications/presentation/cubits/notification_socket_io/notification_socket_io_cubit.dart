import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/helpers/web_socket_helper.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_app_notifications/get_app_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_services_notifications/get_services_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_social_notifications/get_social_notifications_cubit.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';

part 'notification_socket_io_state.dart';

class NotificationSocketIoCubit extends Cubit<NotificationSocketIoState> {
  BuildContext context;
  WebSocketHelper webSocketHelper;
  NotificationSocketIoCubit({
    required this.context,
    required this.webSocketHelper,
  }) : super(NotificationSocketIoInitial());

  Future<void> notificationListener() async {
    final getAppNotificationsCubit = context.read<GetAppNotificationsCubit>();
    final getSocialNotificationsCubit = context.read<GetSocialNotificationsCubit>();
    final getServicesNotificationsCubit = context.read<GetServicesNotificationsCubit>();

    webSocketHelper.notificationListener((Map<String, dynamic> data) async {
      String? type = data['metadata']["type"];
      if (type == null) {
        emit(NotificationSocketIoFailed('Notfication Type is not Provided From the Server'));
        return;
      }
      if (type == 'app') {
        getAppNotificationsCubit.notifications = [];
        getAppNotificationsCubit.page = 1;
        await getAppNotificationsCubit.getAppNotifications();
        if (getAppNotificationsCubit.notifications.isNotEmpty) {
          emit(NotificationSocketIoNewNotification(getAppNotificationsCubit.notifications.first));
        }
        return;
      }
      if (type == 'social') {
        getSocialNotificationsCubit.notifications = [];
        getSocialNotificationsCubit.page = 1;
        await getSocialNotificationsCubit.getSocialNotifications();
        if (getSocialNotificationsCubit.notifications.isNotEmpty) {
          emit(NotificationSocketIoNewNotification(getSocialNotificationsCubit.notifications.first));
        }
        return;
      }
      if (type == 'services') {
        getServicesNotificationsCubit.notifications = [];
        getServicesNotificationsCubit.page = 1;
        await getServicesNotificationsCubit.getServicesNotifications();
        pr(getServicesNotificationsCubit.notifications);
        if (getServicesNotificationsCubit.notifications.isNotEmpty) {
          emit(NotificationSocketIoNewNotification(getServicesNotificationsCubit.notifications.first));
        }
        return;
      }
    });
  }
}
