import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/routes/pages.dart';

class ChangeDriverStatusCubit extends Cubit<RiderState> {
  final ApiConsumer apiConsumer;
  ChangeDriverStatusCubit(this.apiConsumer) : super(RiderInitial());
  Future<void> getDriverStatus() async {
    emit(LoadingGetDriverStatus());
    var response = await apiConsumer
        .get("https://07dbd6ba05fc.ngrok-free.app/api/v1/ride/riders/check-activate");

    response.fold(
      (left) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(left, currentContext));
        emit(FailureGetDriverStatus());
      },
      (data) {
        print("response ===${data["data"]}\n");
        emit(SuccessGetDriverStatus(status: data["data"]));
      },
    );
  }

  Future<void> changeDriverStatus() async {
    emit(LoadingGetDriverStatus());
    var response =
        await apiConsumer.put("https://07dbd6ba05fc.ngrok-free.app/api/v1/ride/riders/activate");

    response.fold(
      (left) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(left, currentContext));
        emit(FailureGetDriverStatus());
      },
      (data) {
        print("response ===${data["data"]}\n");
        emit(SuccessGetDriverStatus(status: data["data"]));
      },
    );
  }
}
