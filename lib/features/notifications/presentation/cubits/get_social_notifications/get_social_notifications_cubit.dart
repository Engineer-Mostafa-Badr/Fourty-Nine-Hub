import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'get_social_notifications_state.dart';

class GetSocialNotificationsCubit extends Cubit<GetSocialNotificationsState> {
  final GetNotficationsUseCase getNotficationsUseCase;
  GetSocialNotificationsCubit({
    required this.getNotficationsUseCase,
  }) : super(GetSocialNotificationsInitial());
  List<NotificationEntity> notifications = [];
  int page = 1;
  Future<void> getSocialNotifications() async {
    emit(GetSocialNotificationsLoading());
    final response = await getNotficationsUseCase.call(type: 'app', page: page);
    response.fold(
      (Failure failure) {
        emit(GetSocialNotificationsFailed(Labels.errorHappened));
      },
      (data) {
        notifications.addAll(data);
        emit(GetSocialNotificationsSuccess(data));
      },
    );
  }
}
