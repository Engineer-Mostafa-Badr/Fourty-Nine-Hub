import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

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
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessPartialPaymentState());
      },
    );
  }
}
