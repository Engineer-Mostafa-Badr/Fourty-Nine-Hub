import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/routes/pages.dart';

class CheckPaymentCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  CheckPaymentCubit({required this.repository}) : super(RiderInitial());
  check({required String amount}) async {
    var resposne = await repository.checkPayment(amount: amount);
    resposne.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        if (r['data'] ?? false) {
          emit(WalletPayemntState());
        } else {
          emit(CashPaymentState());
        }
      },
    );
  }
}
