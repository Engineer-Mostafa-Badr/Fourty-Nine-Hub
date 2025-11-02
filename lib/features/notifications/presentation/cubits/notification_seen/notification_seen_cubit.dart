// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/notification_seen_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
part 'notification_seen_state.dart';

class NotificationSeenCubit extends Cubit<NotificationSeenState> {
  final NotificationSeenUseCase notificationSeenUseCase;
  NotificationSeenCubit({
    required this.notificationSeenUseCase,
  }) : super(NotificationSeenInitial());

  Future<void> notificationSeen({required String id}) async {
    emit(NotificationSeenLoading());
    final response = await notificationSeenUseCase.call(id: id);
    response.fold(
      (Failure failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        emit(NotificationSeenFailed(Labels.errorHappened));
      },
      (data) {
        emit(NotificationSeenSuccess());
      },
    );
  }
}
