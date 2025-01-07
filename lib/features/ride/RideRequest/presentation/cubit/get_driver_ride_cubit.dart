import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/driver_ride_model/driver_ride_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class GetDriverRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetDriverRideCubit({required this.repository}) : super(RiderInitial());

  get() async {
    emit(LoadingRiderState());
    var response = await repository.getRideDriver();
    response.fold(
      (l) {},
      (r) {
        DriverRideModel model = DriverRideModel.fromJson(r['data']);
        emit(SuccessGetDriverRideState(model: model));
      },
    );
  }
}
