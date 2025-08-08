import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class OfferNoSocketActionsCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  OfferNoSocketActionsCubit({required this.repository}) : super(RiderInitial());
  accept({required String id}) async {
    var response = await repository.offerAcceptNoSocket(id: id);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
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
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
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
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessDeleteTripNoSocketState());
      },
    );
  }
}
