import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class CompletedTripRiderCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  CompletedTripRiderCubit({required this.repository}) : super(RiderInitial());
  completedTripRider({
    required String id,
  }) async {
    var response = await repository.completedTripRider(id: id);
    response.fold(
      (l) {
        log(l.toString());
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessCompletedTripRiderState());
      },
    );
  }
}
