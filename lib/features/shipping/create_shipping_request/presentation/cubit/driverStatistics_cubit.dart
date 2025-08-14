import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/driver_statistice_model.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class DriverStatisticsCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  DriverStatisticsCubit({required this.repository}) : super(ShippingInitial());
  get() async {
    var response = await repository.driverStatistics();
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessGetDriverStatisticsState(
            model: DriverStatisticeModel.fromJson(r['data'])));
      },
    );
  }
}
