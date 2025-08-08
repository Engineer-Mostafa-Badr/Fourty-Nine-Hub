import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/get_unread_notifications_count/get_unread_notifications_count_cubit.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
part 'get_social_notifications_state.dart';

class GetSocialNotificationsCubit extends Cubit<GetSocialNotificationsState> {
  final GetNotificationsUseCase getNotficationsUseCase;
  final BuildContext context;
  GetSocialNotificationsCubit({
    required this.context,
    required this.getNotficationsUseCase,
  }) : super(GetSocialNotificationsInitial());
  List<NotificationEntity> notifications = [];
  int page = 1;
  Future<void> getSocialNotifications({
    required String languageCode,
  }) async {
    final getUnreadNotificationsCountCubit =
        context.read<GetUnreadNotificationsCountCubit>();
    getUnreadNotificationsCountCubit.getUnreadNotificationsCount();
    emit(GetSocialNotificationsLoading());
    pr('getSocialNotifications is called');
    pr('pages: $page');
    pr('notifications: $notifications');
    final response = await getNotficationsUseCase.call(
        type: 'social', page: page, languageCode: languageCode);
    response.fold(
      (Failure failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        emit(GetSocialNotificationsFailed(Labels.errorHappened));
      },
      (data) {
        notifications.addAll(data);
        emit(GetSocialNotificationsSuccess(data));
      },
    );
  }
}
