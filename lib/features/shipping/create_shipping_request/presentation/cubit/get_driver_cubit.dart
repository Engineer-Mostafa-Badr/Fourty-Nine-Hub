import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/get_driver_data_model/get_driver_data_model.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';

class GetDriverCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  GetDriverCubit({required this.repository}) : super(ShippingInitial());
  getDriverData() async {
    var response = await repository.getDriverData();
    response.fold(
      (l) {
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
