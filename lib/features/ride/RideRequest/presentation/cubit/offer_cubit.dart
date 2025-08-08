import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_trip_from_driver_model/check_accept_trip_from_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

class OfferCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  OfferCubit({required this.repository}) : super(InitalRiderState());
  acceptOffer({required String tripId, required String subCategory}) async {
    var response = await repository.acceptOfferRide(
        tripId: tripId, subCategory: subCategory);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        log(r.toString(), name: "sldkfjsldkjfdkdkdkdkdkdkkkkkk");
        print("response $response\n");
        Map<String, dynamic> jsonData = r['data']['isTripExists'];
        jsonData['driverPhone'] = r['data']['driverPhone'];
        jsonData['userPhone'] = r['data']['userPhone'];
        CheckAcceptTripFromDriverModel model =
            CheckAcceptTripFromDriverModel.fromJson(r['data']['isTripExists']);
        model.otp = r['data']['OTP'];
        emit(SuccessAcceptOfferRideState(model: model));
        log(r['data'].toString(), name: "sldkfjsldkjfdkdkdkdkdkdkkkkkk");
      },
    );
  }

  declineOffer({required String tripId}) async {
    var response = await repository.declineOfferRide(tripId: tripId);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessDclineOfferRideState());
      },
    );
  }
}
