import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/driver_info_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class GetDriverInfoCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetDriverInfoCubit({required this.repository}) : super(RiderInitial());

  get() async {
    var response = await repository.getDriverInfo();
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessGetDriverInfoState(
            model: DriverInfoModel.fromJson(r['data'])));
      },
    );
  }
}
