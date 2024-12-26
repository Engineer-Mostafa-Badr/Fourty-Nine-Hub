import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_by_rider_model/check_accept_by_rider_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class CheckAcceptByRiderCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  CacheService cacheService = CacheServiceImpl();
  bool isCheck = false;
  CheckAcceptByRiderCubit({required this.repository}) : super(RiderInitial());
  check() async {
    if (!isCheck) {
      isCheck = true;
      CheckAcceptByRiderModel? rider = await cacheService.getDriverTripInfo();
      if (rider != null) {
        emit(SuccessCheckAcceptByRiderState(model: rider));
      }
    }

    repository.checkAcceptByRider(
      onData: (model) {
        log(model.toString(), name: "checkAcceptByRidercheckAcceptByRider");
        emit(SuccessCheckAcceptByRiderState(model: model));
      },
    );
  }
}
