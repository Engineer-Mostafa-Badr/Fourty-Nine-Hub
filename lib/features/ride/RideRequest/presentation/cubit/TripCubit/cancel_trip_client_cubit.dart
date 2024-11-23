import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class CancelTripClientCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  CancelTripClientCubit({required this.repository}) : super(RiderInitial());
  cancelTripClient({
    required String id,
    required String reasonId,
    required String note,
  }) async {
    var response = await repository.cancelTripClient(
        id: id, reasonId: reasonId, note: note);
    response.fold(
      (l) {
        log('lkdjslkdfjslkdjflskdjf failure');
        emit(FailureRiderState(failure: l));
      },
      (r) {
        log('lkdjslkdfjslkdjflskdjf success');
        emit(SuccessCancelTripClientState());
      },
    );
  }
}
