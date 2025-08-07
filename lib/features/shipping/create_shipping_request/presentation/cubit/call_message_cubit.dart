import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';

class CallMessageCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  CallMessageCubit({required this.repository}) : super(ShippingInitial());
  getCallMessage(
      {required String ownerId, required String subcategoryId}) async {
    var response = await repository.getCallMessage(
        ownerId: ownerId, subcategoryId: subcategoryId);
    response.fold(
      (l) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(currentContext, getFailureMessage(l, currentContext));
        log(l.toString(), name: "lksjdflskdjlskdjfslkdfjsf");
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessGetCallMessageState(data: r['data'] != "disable"));
      },
    );
  }
}
