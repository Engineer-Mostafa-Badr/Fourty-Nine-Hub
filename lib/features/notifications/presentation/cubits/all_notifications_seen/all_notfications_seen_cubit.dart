// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/all_notifications_seen_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'all_notfications_seen_state.dart';

class AllNotficationsSeenCubit extends Cubit<AllNotficationsSeenState> {
  final AllNotificationSeenUseCase allNotificationSeenUseCase;
  AllNotficationsSeenCubit({
    required this.allNotificationSeenUseCase,
  }) : super(AllNotficationsSeenInitial());
  Future<void> allNotificationSeen({required String type}) async {
    emit(AllNotficationsSeenLoading());
    final response = await allNotificationSeenUseCase.call(type: type);
    response.fold(
      (Failure failure) {
        emit(AllNotficationsSeenFailed(Labels.errorHappened));
      },
      (data) {
        emit(AllNotficationsSeenSuccess());
      },
    );
  }
}
