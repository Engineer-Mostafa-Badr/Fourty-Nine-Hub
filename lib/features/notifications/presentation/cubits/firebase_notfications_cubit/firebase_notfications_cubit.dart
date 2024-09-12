// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/set_intercepted_notification_message_usecase.dart';

part 'firebase_notfications_state.dart';

class FirebaseNotficationsCubit extends Cubit<FirebaseNotficationsState> {
  SetInterceptedNotificationMessageUseCase
      setInterceptedNotificationMessageUseCase;
  FirebaseNotficationsCubit(
    this.setInterceptedNotificationMessageUseCase,
  ) : super(FirebaseNotficationsInitial());

  Future<void> setupInterceptedMessage({required BuildContext context}) async {
    await setInterceptedNotificationMessageUseCase.call(context: context);
  }
}
