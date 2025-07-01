import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class ChangeDriverStatusCubit extends Cubit<RiderState> {
  final ApiConsumer apiConsumer;
  ChangeDriverStatusCubit(this.apiConsumer) : super(RiderInitial());
  Future<void> getDriverStatus() async {
    emit(LoadingGetDriverStatus());
    var response = await apiConsumer
        .get("https://1220-41-239-172-48.ngrok-free.app/api/v1/ride/riders/check-activate");

    response.fold(
      (left) {
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
        await apiConsumer.put("https://1220-41-239-172-48.ngrok-free.app/api/v1/ride/riders/activate");

    response.fold(
      (left) {
        emit(FailureGetDriverStatus());
      },
      (data) {
        print("response ===${data["data"]}\n");
        emit(SuccessGetDriverStatus(status: data["data"]));
      },
    );
  }
}
