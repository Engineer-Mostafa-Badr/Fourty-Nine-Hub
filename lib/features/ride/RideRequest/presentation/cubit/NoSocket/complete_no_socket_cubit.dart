import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class CompleteNoSocketCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  CompleteNoSocketCubit({required this.repository}) : super(RiderInitial());
  complete({required String id}) async {
    var response = await repository.completeTripNoSocket(id: id);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessCompleteOfferNoSocketState());
      },
    );
  }
}
