import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'get_app_notifications_state.dart';

class GetAppNotificationsCubit extends Cubit<GetAppNotificationsState> {
  final GetNotficationsUseCase getNotficationsUseCase;
  final BuildContext context;
  GetAppNotificationsCubit({
    required this.context,
    required this.getNotficationsUseCase,
  }) : super(GetAppNotificationsInitial());

  List<NotificationEntity> notifications = [];
  int page = 1;
  Future<void> getAppNotifications({
    required String languageCode,
  }) async {
    final getUnreadNotificationsCountCubit = context.read<GetUnreadNotificationsCountCubit>();
    getUnreadNotificationsCountCubit.getUnreadNotificationsCount();
    pr('getAppNotifications is called');
    pr('pages: $page');
    pr('notifications: $notifications');
    emit(GetAppNotificationsLoading());
    final response = await getNotficationsUseCase.call(type: 'app', page: page, languageCode: languageCode);
    response.fold(
      (Failure failure) {
        emit(GetAppNotificationsFailed(Labels.errorHappened));
      },
      (data) {
        notifications.addAll(data);

        pr(data);
        emit(GetAppNotificationsSuccess(data));
      },
    );
  }
}
