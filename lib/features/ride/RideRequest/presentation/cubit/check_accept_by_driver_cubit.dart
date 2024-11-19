import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_trip_from_driver_model/check_accept_trip_from_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class CheckAcceptByDriverCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  CacheService cacheService = CacheServiceImpl();
  bool isCheck = false;
  CheckAcceptByDriverCubit({required this.repository}) : super(RiderInitial());
  check() async {
    if (!isCheck) {
      isCheck = true;
      CheckAcceptTripFromDriverModel? driver =
          await cacheService.getRiderTripInfo();
      if (driver != null) {
        emit(SuccessCheckAcceptByDriverState(model: driver));
      }
    }
    log(isCheck.toString(), name: "lkdkdkdkk20394820394");
    repository.checkAcceptByDriver(
      onData: (model) {
        emit(SuccessCheckAcceptByDriverState(model: model));
      },
    );
  }
}
