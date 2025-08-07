import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/trip_by_user_model.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class GetMyTripCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  GetMyTripCubit({required this.repository}) : super(ShippingInitial());
  getMyTrip() async {
    log("lksjdflskdjfslkdjflsdkjfd");
    var response = await repository.getMyTrip();
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureShippingState(failure: l));
      },
      (r) {
        // log(r['data'][1]['id'].toString(), name: "lskdfjlskdjfkdddd");
        if ((r['data'] as List).isNotEmpty) {
          TripByUserModel model =
              TripByUserModel.fromJson((r['data'] as List).first);
          emit(SuccessGetMyTripState(model: model));
        }
      },
    );
  }
}
