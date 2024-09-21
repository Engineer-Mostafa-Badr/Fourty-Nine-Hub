import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class RequestRiderTripCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  RequestRiderTripCubit({required this.repository}) : super(RiderInitial());
  request({required TripRequestModel model}) async {
    var response = await repository.request(model: model);
    response.fold(
      (error) {
        emit(FailureRiderState(failure: error));
      },
      (data) {
        emit(SuccessRequestTripState());
      },
    );
  }
}
