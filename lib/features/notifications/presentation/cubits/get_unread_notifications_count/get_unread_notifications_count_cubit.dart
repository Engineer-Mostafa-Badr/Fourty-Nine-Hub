// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/unread_notifications_count_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_unread_notifications_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'get_unread_notifications_count_state.dart';

class GetUnreadNotificationsCountCubit extends Cubit<GetUnreadNotificationsCountState> {
  GetUnreadNotificationsCountUseCase getUnreadNotificationsCountUseCase;
  GetUnreadNotificationsCountCubit({
    required this.getUnreadNotificationsCountUseCase,
  }) : super(GetUnreadNotificationsCountInitial());

  UnreadNotificationsCountEntity? unreadNotificationsCountEntity;

  Future<void> getUnreadNotificationsCount() async {
    emit(GetUnreadNotificationsCountLoading());
    final response = await getUnreadNotificationsCountUseCase.call();
    response.fold(
      (Failure failure) {
        emit(GetUnreadNotificationsCountFailed(Labels.errorHappened));
      },
      (data) {
        unreadNotificationsCountEntity = data;
        emit(GetUnreadNotificationsCountSuccess(data));
      },
    );
  }
}
