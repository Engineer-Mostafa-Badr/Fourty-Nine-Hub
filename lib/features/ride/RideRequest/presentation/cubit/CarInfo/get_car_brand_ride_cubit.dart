import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/models/car_brand_model.dart';
import 'package:fourtyninehub/routes/pages.dart';

class GetCarBrandRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetCarBrandRideCubit({required this.repository}) : super(RiderInitial());
  get() async {
    emit(LoadingRiderState());
    var response = await repository.getCarBrand();
    response.fold(
      (l) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        List<CarBrandModel> list =
            (r['data'] as List).map((e) => CarBrandModel.fromJson(e)).toList();
        emit(SuccessGetCarBrandRideState(list: list));
      },
    );
  }
}
