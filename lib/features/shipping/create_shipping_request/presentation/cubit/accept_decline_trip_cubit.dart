import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';

class AcceptDeclineTripCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  AcceptDeclineTripCubit({required this.repository}) : super(ShippingInitial());
  accept({required String loadingRequestId}) async {
    var response =
        await repository.acceptTrip(loadingRequestId: loadingRequestId);
    response.fold(
      (l) {
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
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessCompleteTripState());
      },
    );
  }
}
