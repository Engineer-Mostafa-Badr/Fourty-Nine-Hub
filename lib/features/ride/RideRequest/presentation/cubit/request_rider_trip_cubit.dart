import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/success_request_trip_model/success_request_trip_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class RequestRiderTripCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  SuccessRequestTripModel? trip;
  RequestRiderTripCubit({required this.repository}) : super(RiderInitial());
  request({required TripRequestModel model}) async {
    var response = await repository.request(model: model);
    response.fold(
      (error) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(error, currentContext));
        emit(FailureRiderState(failure: error));
      },
      (data) {
        log(data.toString(), name: "lsjfsdfjklkkkkkkkkkkkllllllksdlklkkk");
        SuccessRequestTripModel model =
            SuccessRequestTripModel.fromJson(data['data']);
        trip = model;
        emit(SuccessRequestTripState(model: model));
      },
    );
  }
}
