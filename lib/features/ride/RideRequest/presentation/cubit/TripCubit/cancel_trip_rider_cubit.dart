import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class CancelTripRiderCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  CancelTripRiderCubit({required this.repository}) : super(RiderInitial());
  cancelTripRider({
    required String id,
    required String reasonId,
    required String note,
  }) async {
    var response = await repository.cancelTripRider(
        id: id, reasonId: reasonId, note: note);
    response.fold(
      (l) {
        log("failure Cancel trip");
        emit(FailureRiderState(failure: l));
      },
      (r) {
        log("succes Cancel trip");
        emit(SuccessCancelTripRiderState());
      },
    );
  }
}
