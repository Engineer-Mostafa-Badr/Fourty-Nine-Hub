// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/delete_all_notifications_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

part 'delete_all_notifications_state.dart';

class DeleteAllNotificationsCubit extends Cubit<DeleteAllNotificationsState> {
  final DeleteAllNotificationsUseCase deleteAllNotificationsUseCase;
  DeleteAllNotificationsCubit({
    required this.deleteAllNotificationsUseCase,
  }) : super(DeleteAllNotificationsInitial());
  Future<void> deleteAllNotifications({required String type}) async {
    emit(DeleteAllNotificationsLoading());
    final response = await deleteAllNotificationsUseCase.call(type: type);
    response.fold(
      (Failure failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        emit(DeleteAllNotificationsFailed(Labels.errorHappened));
      },
      (data) {
        emit(DeleteAllNotificationsSuccess());
      },
    );
  }
}
