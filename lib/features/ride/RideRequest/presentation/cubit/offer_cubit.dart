import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class OfferCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  OfferCubit({required this.repository}) : super(InitalRiderState());
  acceptOffer({required String tripId, required String subCategory}) async {
    var response = await repository.acceptOfferRide(
        tripId: tripId, subCategory: subCategory);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessAcceptOfferRideState());
      },
    );
  }

  declineOffer({required String tripId}) async {
    var response = await repository.declineOfferRide(tripId: tripId);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessDclineOfferRideState());
      },
    );
  }
}
