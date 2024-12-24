import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/my_trip_ride_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class GetUserLoginTripNoSocketCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetUserLoginTripNoSocketCubit({required this.repository})
      : super(RiderInitial());
  get() async {
    log("lsdkfsldjfsldf");
    var response = await repository.getUserLoginTripNoSocket();
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        if (r['data'] == null) {
          emit(FailureRiderState(failure: const ServerFailure(message: "Not Found Trip")));
        }
        emit(SuccessGetUserLoginTripNoSocketState(
            model: MyTripRideModel.fromJson(r['data'])));
      },
    );
  }
}
