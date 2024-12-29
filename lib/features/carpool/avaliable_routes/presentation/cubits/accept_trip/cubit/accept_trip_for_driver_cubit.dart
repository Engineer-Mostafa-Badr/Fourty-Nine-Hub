import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';

part 'accept_trip_for_driver_state.dart';

class AcceptTripForDriverCubit extends Cubit<AcceptTripForDriverState> {
  AcceptTripForDriverCubit(this.apiConsumer)
      : super(AcceptTripForDriverInitial());
  final ApiConsumer apiConsumer;

  Future<void> acceptTripForDriver({required String tripId}) async {
    try {
      print("Loading $tripId\n");

      emit(AcceptTripForDriverLoading());
      final Either<Failure, Map<String, dynamic>> response =
          await apiConsumer.patch(EndPoints.acceptTripForDriver(tripId));
      print("Loading 2 $tripId\n");

      response.fold(
        (failure) {
          print("EROOOOOR FAilure \n");
          emit(AcceptTripForDriverFailure(
              errorMessage: "You cannot accept this trip"));
        },
        (data) {
          if (data['status']) {
            print("SSSSSSSuccceeeeeeees \n");
            emit(AcceptTripForDriverSuccess());
          } else {
            print("EROOOOOR FAilure \n");
            emit(AcceptTripForDriverFailure(
                errorMessage: "You cannot accept this trip"));
          }
        },
      );
    } catch (e) {
      print("EROOOOOR FAilure \n");

      emit(AcceptTripForDriverFailure(errorMessage: 'Please Try again'));
    }
  }
}
