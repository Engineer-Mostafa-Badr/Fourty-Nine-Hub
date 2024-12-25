import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class GetRideCurrenttripCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetRideCurrenttripCubit({required this.repository}) : super(RiderInitial());
  get() async {
    await repository.currentTrip(
      (model) {
        emit(SuccessGetCurrentTripState(model: model));
      },
    );
  }
}
