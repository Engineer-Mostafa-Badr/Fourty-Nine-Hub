import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class SendOfferByDriverCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  SendOfferByDriverCubit({required this.repository}) : super(RiderInitial());
  send({required String id, required double price}) async {
    emit(LoadingRiderState());
    var response = await repository.createOfferByDriver(id: id, price: price);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessSendOfferByDriverState());
      },
    );
  }
}
