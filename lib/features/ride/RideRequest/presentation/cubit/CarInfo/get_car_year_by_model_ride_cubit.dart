import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/models/car_year_type_model.dart';

class GetCarYearByModelRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetCarYearByModelRideCubit({required this.repository})
      : super(RiderInitial());
  get({required String brand, required String model}) async {
    emit(LoadingRiderState());
    var response = await repository.getCarYearType(brand: brand, model: model);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        List<CarYearTypeModel> list = (r['data'] as List)
            .map((e) => CarYearTypeModel.fromJson(e))
            .toList();
        emit(SuccessGetCarYearTypeRideState(list: list));
      },
    );
  }
}
