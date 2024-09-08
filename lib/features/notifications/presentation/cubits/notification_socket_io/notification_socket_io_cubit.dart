import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/notificaiton_listener_usecase.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_app_notifications/get_app_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_services_notifications/get_services_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_social_notifications/get_social_notifications_cubit.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';

part 'notification_socket_io_state.dart';

class NotificationSocketIoCubit extends Cubit<NotificationSocketIoState> {
  BuildContext context;
  NotificationListenerUseCase notificationListenerUseCase;
  NotificationSocketIoCubit({
    required this.context,
    required this.notificationListenerUseCase,
  }) : super(NotificationSocketIoInitial());

  Future<void> notificationListener() async {
    final getAppNotificationsCubit = context.read<GetAppNotificationsCubit>();
    final getSocialNotificationsCubit = context.read<GetSocialNotificationsCubit>();
    final getServicesNotificationsCubit = context.read<GetServicesNotificationsCubit>();

    notificationListenerUseCase.call(
      notificationCallback: (Map<String, dynamic> data) async {
        String? type = data['filterType'];
        if (type == null) {
          emit(NotificationSocketIoFailed('Notfication Type is not Provided From the Server'));
          return;
        }
        //! dev will be deleted after testing
        if (type == 'services') {
          getAppNotificationsCubit.notifications = [];
          getAppNotificationsCubit.page = 1;
          pr('===========');
          await getAppNotificationsCubit.getAppNotifications();
          if (getAppNotificationsCubit.notifications.isNotEmpty) {
            pr(getAppNotificationsCubit.notifications.first.id);
            pr(getAppNotificationsCubit.notifications.first.read);
            emit(NotificationSocketIoNewNotification(getAppNotificationsCubit.notifications.first));
          }
          return;
        }
        //! dev
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
          if (getServicesNotificationsCubit.notifications.isNotEmpty) {
            emit(NotificationSocketIoNewNotification(getServicesNotificationsCubit.notifications.first));
          }
          return;
        }
      },
    );
  }
}
