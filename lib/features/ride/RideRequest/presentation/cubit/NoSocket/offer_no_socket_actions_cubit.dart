import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class OfferNoSocketActionsCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  OfferNoSocketActionsCubit({required this.repository}) : super(RiderInitial());
  accept({required String id}) async {
    var response = await repository.offerAcceptNoSocket(id: id);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessAcceptOfferNoSocketState());
      },
    );
  }

  offerRejectNoSocket({required String id}) async {
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

  delete({required String id}) async {
    var response = await repository.deleteTripNoSocket(id: id);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessDeleteTripNoSocketState());
      },
    );
  }
}
