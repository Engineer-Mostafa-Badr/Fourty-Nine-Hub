import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'accept_trip_for_driver_state.dart';

class AcceptTripForDriverCubit extends Cubit<AcceptTripForDriverState> {
  AcceptTripForDriverCubit(this.apiConsumer)
      : super(AcceptTripForDriverInitial());
  final ApiConsumer apiConsumer;

  Future<void> acceptTripForDriver({required String tripId}) async {
    try {
      emit(AcceptTripForDriverLoading());
      final Either<Failure, Map<String, dynamic>> response =
          await apiConsumer.patch(EndPoints.acceptTripForDriver(tripId));

      response.fold(
        (failure) => emit(
            AcceptTripForDriverFailure(errorMessage: Labels.errorHappened)),
        (data) {
          if (data['status']) {
            emit(AcceptTripForDriverSuccess());
          } else {
            emit(AcceptTripForDriverFailure(errorMessage: 'Please Try again'));
          }
        },
      );
    } catch (e) {
      emit(AcceptTripForDriverFailure(errorMessage: 'Please Try again'));
    }
  }
}
