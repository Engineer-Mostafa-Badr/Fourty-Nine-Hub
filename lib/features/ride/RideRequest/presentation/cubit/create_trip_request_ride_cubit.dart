import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/create_trip_ride_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

class CreateTripRequestRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  CreateTripRequestRideCubit({required this.repository})
      : super(RiderInitial());
  request({required CreateTripRideRequestModel model}) async {
    emit(LoadingRiderState());
    var response = await repository.createRequest(model: model);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessCreateRequestTripRideState());
      },
    );
  }

  createRequestPremium({required CreateTripRideRequestModel model}) async {
    emit(LoadingRiderState());
    var response = await repository.createRequestPremium(model: model);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessCreateRequestTripRideState());
      },
    );
  }

  String? validation({required String message, required bool condition}) {
    if (condition) {
      return message;
    }
    return null;
  }
}
