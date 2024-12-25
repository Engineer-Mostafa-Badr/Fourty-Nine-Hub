import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class DeleteDriverRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  DeleteDriverRideCubit({required this.repository}) : super(RiderInitial());
  delete() async {
    var response = await repository.deleteDriver();
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessDeleteDriverState());
      },
    );
  }
}
