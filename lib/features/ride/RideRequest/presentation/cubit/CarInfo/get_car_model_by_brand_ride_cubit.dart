import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/car_models_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class GetCarModelByBrandRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetCarModelByBrandRideCubit({required this.repository})
      : super(RiderInitial());
  get({required String brand}) async {
    emit(LoadingRiderState());
    var response = await repository.getCarModelByBrand(brand: brand);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
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
