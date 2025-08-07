// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
part 'get_services_notifications_state.dart';

class GetServicesNotificationsCubit
    extends Cubit<GetServicesNotificationsState> {
  GetNotificationsUseCase getNotficationsUseCase;
  final BuildContext context;
  GetServicesNotificationsCubit({
    required this.context,
    required this.getNotficationsUseCase,
  }) : super(GetServicesNotificationsInitial());
  List<NotificationEntity> notifications = [];
  int page = 1;
  Future<void> getServicesNotifications({
    required String languageCode,
  }) async {
    final getUnreadNotificationsCountCubit =
        context.read<GetUnreadNotificationsCountCubit>();
    getUnreadNotificationsCountCubit.getUnreadNotificationsCount();
    // pr('getServicesNotifications is called');
    // pr('pages: $page');
    // pr('notifications: $notifications');
    emit(GetServicesNotificationsLoading());
    final response = await getNotficationsUseCase.call(
        type: 'services', page: page, languageCode: languageCode);
    response.fold(
      (Failure failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        emit(GetServicesNotificationsFailed(Labels.errorHappened));
      },
      (data) {
        notifications.addAll(data);

        emit(GetServicesNotificationsSuccess(data));
      },
    );
  }
}
