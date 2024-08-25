import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubit/notifications_state.dart';

import '../../data/repository/notification_repo.dart';


class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this.notificationRepo) : super(NotificationsInitial());

 final NotificationRepo notificationRepo;
  static NotificationsCubit get(context)=>BlocProvider.of(context);

  void fetchNotification()async{
    emit(NotificationsLoadingState());
   var result=await notificationRepo.fetchNotifications();

    result.fold((failure) {
      emit(NotificationsErrorState(errMessage: 'failure'));
     // print(failure.errMessage.toString());
    }, (notification) {
      emit(NotificationsSuccessState(notificationModel: notification));
    });
  }
}
