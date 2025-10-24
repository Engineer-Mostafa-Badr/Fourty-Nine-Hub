import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/routes/pages.dart';
class CheckDriverTypeCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  CheckDriverTypeCubit({required this.repository}) : super(RiderInitial());
  checkDriverType() async {
    var resposne = await repository.checkDriverType();
    resposne.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccesCheckDriverTypeState(
            rider: r['data']['ride'] as bool,
            shipping: r['data']['shipping'] as bool));
      },
    );
  }
}
