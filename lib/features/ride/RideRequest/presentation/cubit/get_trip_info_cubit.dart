import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_model/get_trip_info_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class GetTripInfoCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetTripInfoRequestModel model = GetTripInfoRequestModel();
  GetTripInfoCubit({required this.repository}) : super(RiderInitial());
  getTripInfoRequest() async {
    var response = await repository.getTripInfo(
        model: GetTripInfoRequestModel(
            startLocation: [29.962565, 31.261392],
            targetLocation: [30.098281, 31.329383],
            subCateogryId: "62c8ba9f8e28a58a3edf57eb",
            comfort: true));
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        log(r.toString(), name: "lklkkkkkkkkkkkkkkkkkkkkkkjjjjjjjjjjjjj");
        emit(SuccessGetTripInfoState(
            model: GetTripInfoModel.fromJson(r['data'])));
      },
    );
  }

  comfort(bool value) {
    model.comfort = value;
  }

  autoAccept(bool value) {
    model.autoAccept = value;
  }
}
