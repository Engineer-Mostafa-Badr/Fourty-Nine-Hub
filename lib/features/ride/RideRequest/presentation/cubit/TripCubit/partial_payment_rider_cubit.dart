import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

class PartialPaymentRiderCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  PartialPaymentRiderCubit({required this.repository}) : super(RiderInitial());
  partialPayment(
      {required String id,
      required double amount,
      required String paymentMethod}) async {
    var response = await repository.partialPayment(
        id: id, amount: amount, paymentMethod: paymentMethod);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessPartialPaymentState());
      },
    );
  }
}
