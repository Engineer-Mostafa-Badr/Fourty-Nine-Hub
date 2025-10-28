import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class GetTripInfoCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetTripInfoRequestModel model = GetTripInfoRequestModel();
  // dynamic polyLine = "";
  bool isBottomSheetShown = false;
  bool record = false;
  GetTripInfoCubit({required this.repository}) : super(RiderInitial());

  Future<void> getTripInfoRequest(
      {required LatLng startLatLng,
      required LatLng destinationLatLng,
      required String subCateogryId}) async {
    var response = await repository.getTripInfo(
        model: GetTripInfoRequestModel(startLocation: [
      startLatLng.latitude,
      startLatLng.longitude
    ], targetLocation: [
      destinationLatLng.latitude,
      destinationLatLng.longitude
    ], subCateogryId: subCateogryId, comfort: true));
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        // polyLine = r['data']['polyline'];

        // print("polyLine ${polyLine} \n");
        log(r.toString(), name: "lklkkkkkkkkkkkkkkkkkkkkkkjjjjjjjjjjjjj");
        emit(SuccessGetTripInfoState(
            model: GetTripInfoModel.fromJson(r['data'])));
      },
    );
  }

//  [29.962565, 31.261392],
//  [30.098281, 31.329383]
  comfort(bool value) {
    model.comfort = value;
  }

  recordChange(bool value) {
    record = value;
  }

  autoAccept(bool value) {
    model.autoAccept = value;
  }
}
