// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
part 'delete_notification_state.dart';

class DeleteNotificationCubit extends Cubit<DeleteNotificationState> {
  final DeleteNotificationUseCase deleteNotificationUseCase;
  DeleteNotificationCubit({
    required this.deleteNotificationUseCase,
  }) : super(DeleteNotificationInitial());
  Future<void> deleteNotification({required String id}) async {
    emit(DeleteNotificationLoading());
    final response = await deleteNotificationUseCase.call(id: id);
    response.fold(
      (Failure failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        pr('Delete Failed ');
        emit(DeleteNotificationFailed(Labels.errorHappened));
      },
      (data) {
        pr('Delete Success ');
        emit(DeleteNotificationSuccess());
      },
    );
  }
}
