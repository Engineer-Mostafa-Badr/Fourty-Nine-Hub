import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/notifications/data/models/notification_model.dart';
import 'package:fourtyninehub/features/notifications/data/repostiory/notification_repostiory.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepostiory repostiory;
  NotificationsCubit({required this.repostiory})
      : super(NotificationsInitial());
  getAllNotification() async {
    var response = await repostiory.getAllNotification();
    response.fold(
      (l) {},
      (r) {},
    );
  }
}
