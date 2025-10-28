import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/routes/pages.dart';

class RiderInStartLocationCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  RiderInStartLocationCubit({required this.repository}) : super(RiderInitial());
  riderInStartLocation({required String id}) async {
    log("lsdkflskdf llllll");
    var response = await repository.riderInStartLocation(id: id);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessRiderInStartLocationState());
      },
    );
  }
}
