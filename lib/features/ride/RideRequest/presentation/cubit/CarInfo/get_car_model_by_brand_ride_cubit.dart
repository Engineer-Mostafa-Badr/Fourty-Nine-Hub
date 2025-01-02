import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/car_models_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class GetCarModelByBrandRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetCarModelByBrandRideCubit({required this.repository})
      : super(RiderInitial());
  get({required String brand}) async {
    emit(LoadingRiderState());
    var response = await repository.getCarModelByBrand(brand: brand);
    response.fold(
      (l) {
        emit(FailureRiderState(failure: l));
      },
      (r) {
        List<CarModelsModel> list =
            (r['data'] as List).map((e) => CarModelsModel.fromJson(e)).toList();
        emit(SuccessGetCarModelByBrandRideState(list: list));
      },
    );
  }
}
