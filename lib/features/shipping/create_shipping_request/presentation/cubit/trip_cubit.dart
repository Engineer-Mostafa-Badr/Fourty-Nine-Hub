import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

class TripCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  TripCubit({required this.repository}) : super(ShippingInitial());
  // acceptOffer({required String id}) async {
  //   emit(LoadingShippingState());
  //   var response = await repository.acceptLoadingTripOffer(id: id);
  //   response.fold(
  //     (l) {
  //       emit(FailureShippingState(failure: l));
  //     },
  //     (r) {
  //       emit(SuccessAcceptOfferState(
  //           message: "The request has been successfully approved."));
  //     },
  //   );
  // }

  newOffer(
      {required String id,
      required double price,
      required String message}) async {
    emit(LoadingShippingState());
    var response = await repository.sendOffer(id: id, price: price);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
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
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
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
  report({required String loadingTripId}) async {
    var response = await repository.report(loadingTripId: loadingTripId);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessReportState());
      },
    );
  }
}
