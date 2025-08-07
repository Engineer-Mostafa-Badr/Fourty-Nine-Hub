import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

class AcceptDeclineTripCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  AcceptDeclineTripCubit({required this.repository}) : super(ShippingInitial());
  accept({required String loadingRequestId}) async {
    var response =
        await repository.acceptTrip(loadingRequestId: loadingRequestId);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessAcceptState());
      },
    );
  }

  decline({required String loadingRequestId}) async {
    var response =
        await repository.declineTrip(loadingRequestId: loadingRequestId);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessDeclineState());
      },
    );
  }

  cancel({required String tripId}) async {
    log("message");
    var response = await repository.cancelTrip(tripId: tripId);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessCancelState());
      },
    );
  }

  complete({required String loadingTrip}) async {
    var response = await repository.completeTrip(loadingTrip: loadingTrip);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessCompleteTripState());
      },
    );
  }
}
