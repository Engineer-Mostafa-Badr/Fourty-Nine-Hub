import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rating_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class RatingDriverCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  RatingDriverCubit({required this.repository}) : super(RiderState());
  rate({required RattingDriverModel model}) async {
    var response = await repository.rating(model: model);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        log("lskdjflskjflksjdkdkdkdksldkjflskdjflskdjf");
        emit(SuccessRateDvierState());
      },
    );
  }
}
