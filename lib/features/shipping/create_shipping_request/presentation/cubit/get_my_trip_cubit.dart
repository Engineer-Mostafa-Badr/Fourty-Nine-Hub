import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/trip_by_user_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';

class GetMyTripCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  GetMyTripCubit({required this.repository}) : super(ShippingInitial());
  getMyTrip() async {
    log("lksjdflskdjfslkdjflsdkjfd");
    var response = await repository.getMyTrip();
    response.fold(
      (l) {
        emit(FailureShippingState(failure: l));
      },
      (r) {
        TripByUserModel model =
            TripByUserModel.fromJson((r['data'] as List).first);
        emit(SuccessGetMyTripState(model: model));
      },
    );
  }
}
