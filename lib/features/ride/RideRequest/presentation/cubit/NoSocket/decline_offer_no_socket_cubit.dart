import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class DeclineOfferNoSocketCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  DeclineOfferNoSocketCubit({required this.repository}) : super(RiderInitial());
  decline({required String id}) async {
    var response = await repository.offerRejectNoSocket(id: id);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessRejectOfferNoSocketState());
      },
    );
  }
}
