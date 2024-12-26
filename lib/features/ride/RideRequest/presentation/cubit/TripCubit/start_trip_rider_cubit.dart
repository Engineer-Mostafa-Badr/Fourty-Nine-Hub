import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class StartTripRiderCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  StartTripRiderCubit({required this.repository}) : super(RiderInitial());
  startTripRider({required String id, required int otp}) async {
    var response = await repository.startTripRider(id: id, otp: otp);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessStartTripRiderState());
      },
    );
  }
}
