import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class DeleteDriverCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  DeleteDriverCubit({required this.repository}) : super(ShippingInitial());

  delete() async {
    var resposen = await repository.deleteDriver();
    resposen.fold(
      (l) {var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessDeleteDriver(message: "Success Delete Driver"));
      },
    );
  }
}
