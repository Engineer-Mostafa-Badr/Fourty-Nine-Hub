import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';

class TripCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  TripCubit({required this.repository}) : super(ShippingInitial());
  acceptOffer({required String id}) async {
    emit(LoadingShippingState());
    var response = await repository.acceptLoadingTripOffer(id: id);
    response.fold(
      (l) {
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessAcceptOfferState(
            message: "The request has been successfully approved."));
      },
    );
  }

  newOffer(
      {required String id,
      required double price,
      required String message}) async {
    emit(LoadingShippingState());
    var response = await repository.sendOffer(id: id, price: price);
    response.fold(
      (l) {
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessSendNewOfferState(message: message));
      },
    );
  }

  sendOfferPremium({required String id, required double price}) async {
    emit(LoadingShippingState());
    var response = await repository.sendOfferPremium(id: id, price: price);
    response.fold(
      (l) {
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessAcceptPremiumOfferState(
            message: "The request has been successfully approved."));
      },
    );
  }

  // call() {}
  // message() {}
  report() async {
    // var response = await repository.report();
  }
}
