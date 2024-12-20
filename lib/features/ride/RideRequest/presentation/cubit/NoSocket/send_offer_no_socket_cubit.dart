import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/create_offer_no_socket_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class SendOfferNoSocketCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  SendOfferNoSocketCubit({required this.repository}) : super(RiderInitial());
  send(
      {required CreateOfferNoSocketModel model, required String tripId}) async {
    var response =
        await repository.createOfferNoSocket(model: model, tripId: tripId);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessSendOfferNoSocketState());
      },
    );
  }
}
