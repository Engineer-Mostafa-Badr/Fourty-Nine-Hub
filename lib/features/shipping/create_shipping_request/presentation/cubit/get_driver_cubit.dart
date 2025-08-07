import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/get_driver_data_model/get_driver_data_model.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class GetDriverCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  GetDriverCubit({required this.repository}) : super(ShippingInitial());
  getDriverData() async {
    var response = await repository.getDriverData();
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureShippingState(failure: l));
      },
      (r) {
        // log(r.toString(), name: "lskdddddd");
        emit(SuccessGetDriverDataState(
            model: GetDriverDataModel.fromJson(r['data'])));
      },
    );
  }
}
