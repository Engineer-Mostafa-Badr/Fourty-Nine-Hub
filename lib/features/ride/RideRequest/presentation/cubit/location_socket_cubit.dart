import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class LocationSocketCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  LocationSocketCubit({required this.repository}) : super(RiderInitial());

  sendSubCategoryId({required String subCategoryId, required String address}) {
    repository.setSubCateogryId(subCategoryId: subCategoryId, address: address);
  }

  updateDriverLocationOn() {
    log("slkdjfsldkjflskdjlskdjflskdjflskjdf");
    repository.updateDriverLocationOn();
  }

  // updateDriverLocationEmit() {
  //   repository.updateDriverLocationEmit();
  // }

  nearbyDriversEmit({
    required List<dynamic> location,
    required String subcategoryId,
    required String tripId,
  }) {
    repository.nearbyDriversEmit(
        location: location, subcategoryId: subcategoryId, tripId: tripId);
    nearbyDriversOn();
  }

  nearbyDriversOn() {
    // var response = repository.nearbyDriversOn();
    // log(response.drivers.toString() ?? "00000000000", name: "driversList");
  }
}

// const { location, subcategoryId , tripId} = JSON.parse(data) as {
//         location: number[];
//         subcategoryId: string;
//         tripId : string;
//       };
