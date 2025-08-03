import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/driver_statistice_model.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';

class DriverStatisticsCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  DriverStatisticsCubit({required this.repository}) : super(ShippingInitial());
  get() async {
    var response = await repository.driverStatistics();
    response.fold(
      (l) {
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessGetDriverStatisticsState(
            model: DriverStatisticeModel.fromJson(r['data'])));
      },
    );
  }
}
