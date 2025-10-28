import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/color_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/routes/pages.dart';
class GetCarColorsRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetCarColorsRideCubit({required this.repository}) : super(RiderInitial());

  get() async {
    emit(LoadingRiderState());
    var response = await repository.ridersColors();
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        List<ColorModel> list =
            (r['data'] as List).map((e) => ColorModel.fromJson(e)).toList();
        emit(SuccessGetCarColorsRideState(list: list));
      },
    );
  }
}
