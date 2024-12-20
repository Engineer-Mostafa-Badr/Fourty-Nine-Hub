import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class CheckTripEndCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  CheckTripEndCubit({required this.repository}) : super(RiderInitial());
  check() {
    repository.checkTripEnd(
      check: () {
        emit(SuccessCheckTripEndState());
      },
    );
  }
}
