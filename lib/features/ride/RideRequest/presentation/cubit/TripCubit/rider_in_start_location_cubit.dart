import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class RiderInStartLocationCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  RiderInStartLocationCubit({required this.repository}) : super(RiderInitial());
  riderInStartLocation({required String id}) async {
    log("lsdkflskdf llllll");
    var response = await repository.riderInStartLocation(id: id);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessRiderInStartLocationState());
      },
    );
  }
}
