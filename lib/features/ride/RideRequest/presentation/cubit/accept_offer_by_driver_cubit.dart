import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_by_rider_model/check_accept_by_rider_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class AcceptOfferByDriverCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  AcceptOfferByDriverCubit({required this.repository}) : super(RiderInitial());
  accept({required String id}) async {
    emit(LoadingRiderState());
    log("",
        name: "SuccessAcceptOfferByDriverStateSuccessAcceptOfferByDriverState");
    var response = await repository.acceptTripByDriver(id: id);

    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        print("response $response\n");
        CheckAcceptByRiderModel model =
            CheckAcceptByRiderModel.fromJson(r['data']);
        log(r.toString(),
            name:
                "SuccessAcceptOfferByDriverStateSuccessAcceptOfferByDriverState");
        emit(SuccessAcceptOfferByDriverState(model: model));
      },
    );
  }
}
