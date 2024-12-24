import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class DeleteOfferRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  DeleteOfferRideCubit({required this.repository}) : super(RiderInitial());
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
