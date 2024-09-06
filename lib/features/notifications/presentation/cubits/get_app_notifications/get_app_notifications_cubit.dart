import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'get_app_notifications_state.dart';

class GetAppNotificationsCubit extends Cubit<GetAppNotificationsState> {
  final GetNotficationsUseCase getNotficationsUseCase;

  GetAppNotificationsCubit({
    required this.getNotficationsUseCase,
  }) : super(GetAppNotificationsInitial());

  List<NotificationEntity> notifications = [];
  int page = 1;
  Future<void> getAppNotifications() async {
    emit(GetAppNotificationsLoading());
    final response = await getNotficationsUseCase.call(type: 'app', page: page);
    response.fold(
      (Failure failure) {
        emit(GetAppNotificationsFailed(Labels.errorHappened));
      },
      (data) {
        notifications.addAll(data);
        emit(GetAppNotificationsSuccess(data));
      },
    );
  }
}
