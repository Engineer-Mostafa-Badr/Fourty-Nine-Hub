import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/requests_history/data/models/request_history_ride_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/routes/pages.dart';

class RequestHistoryRideCubit extends Cubit<RiderState> {
  final ApiConsumer apiConsumer;

  RequestHistoryRideCubit({required this.apiConsumer}) : super(RiderInitial());

  Future<void> getRideTrips() async {
    try {
      print("hello from ==ride cubit \n");
      final response =
          await apiConsumer.get("https://e2088eefa04f.ngrok-free.app/api/v1/ride/trips/user");
      print("ride response== $response\n");
      response.fold(
        (failure) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
          emit(FailureRiderState(failure: failure));
        },
        (data) {
          if (data['data'] != null && data['data']['trips'] != null) {
            final trips = (data['data']['trips'] as List)
                .map((e) => RequestHistoryRideModel.fromJson(e))
                .toList();

            print("SucccessHistoryRiderState");
            emit(SucccessHistoryRiderState(trips: trips));
          } else {
            print("FailureHistoryRiderState");

            emit(FailureRiderState(
                failure:
                    const ServerFailure(message: "Invalid response format")));
          }
        },
      );
    } catch (error) {
      print("error ==${error.toString()}");
      emit(
          FailureRiderState(failure: ServerFailure(message: error.toString())));
    }
  }
}
