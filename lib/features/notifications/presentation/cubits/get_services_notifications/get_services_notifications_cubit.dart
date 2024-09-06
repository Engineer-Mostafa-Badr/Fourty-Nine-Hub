// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'get_services_notifications_state.dart';

class GetServicesNotificationsCubit extends Cubit<GetServicesNotificationsState> {
  GetNotficationsUseCase getNotficationsUseCase;
  GetServicesNotificationsCubit({
    required this.getNotficationsUseCase,
  }) : super(GetServicesNotificationsInitial());
  List<NotificationEntity> notifications = [];
  int page = 1;
  Future<void> getServicesNotifications() async {
    emit(GetServicesNotificationsLoading());
    final response = await getNotficationsUseCase.call(type: 'services', page: page);
    response.fold(
      (Failure failure) {
        emit(GetServicesNotificationsFailed(Labels.errorHappened));
      },
      (data) {
        notifications.addAll(data);

        emit(GetServicesNotificationsSuccess(data));
      },
    );
  }
}
