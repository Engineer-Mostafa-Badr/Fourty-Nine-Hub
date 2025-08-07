import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/my_trip_offer_ride_model/my_trip_offer_ride_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

class GetTripOffersNoSocketCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetTripOffersNoSocketCubit({required this.repository})
      : super(RiderInitial());
  get({required String id}) async {
    log("sldkfjslkdfddddddddddddddddddjjjjjjjjjj");
    var response = await repository.getTripOffersNoSocket(id: id);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        List<MyTripOfferRideModel> list = (r['data'] as List)
            .map(
              (e) => MyTripOfferRideModel.fromJson(e),
            )
            .toList();
        emit(SuccessGetAllOfferNoSocketState(list: list));
      },
    );
  }
}
