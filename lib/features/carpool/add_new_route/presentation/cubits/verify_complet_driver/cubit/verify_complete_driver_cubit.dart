import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/data_source/verify_otp_complete_seat_driver_remote_data_source.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/complete_seat_param.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/verify_otp_param.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/get_current_location_driver.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart';

part 'verify_complete_driver_state.dart';

class VerifyCompleteDriverCubit extends Cubit<VerifyCompleteDriverState> {
  final VerifyOtpCompleteSeatDriverRemoteDataSource
      verifyOtpCompleteSeatDriverRemoteDataSource;
  VerifyCompleteDriverCubit(
      {required this.verifyOtpCompleteSeatDriverRemoteDataSource})
      : super(VerifyCompleteDriverInitial());

  Future<void> completeSeat(
      {required CompleteSeatParam completeSeatParam}) async {
    emit(CompleteSeatLoading());
    final response =
        await verifyOtpCompleteSeatDriverRemoteDataSource.completeUserSeat(
      completeSeatParam: completeSeatParam,
    );

    response.fold(
        (Failure failure) => emit(
              CompleteSeatFailure(errorMessage: Labels.errorHappened),
            ), (data) async {
      emit(CompleteSeatSuccess());
    });
  }

  Future<void> verifyUserOtp(
      {required VerifyOtpParam verifyOtpParam, required String tripId}) async {
    emit(VerifyOtpLoading());
    Position position = await GetCurrentLocationDriver.getCurrentPosition();

    verifyOtpParam.driverLocation = [position.latitude, position.longitude];
    final response =
        await verifyOtpCompleteSeatDriverRemoteDataSource.verifyUserOtp(
      tripId: tripId,
      verifyOtpParam: verifyOtpParam,
    );

    response.fold(
      (Failure failure) => emit(
        VerifyOtpFailure(errorMessage: Labels.errorHappened),
      ),
      (data) async {
        print("Response 1=============\n");
        print(data);
        print("Response 2=============\n");

        emit(VerifyOtpSuccess());
      },
    );
  }

  Future<void> getAcceptedTrips() async {
    emit(GetAcceptedTripLoading());
    final response =
        await verifyOtpCompleteSeatDriverRemoteDataSource.getAcceptedTrips();

    response.fold(
      (Failure failure) => emit(
        GetAcceptedTripFailure(errorMessage: Labels.errorHappened),
      ),
      (data) async {
        print("Response 1=============\n");
        print(data);
        print("Response 2=============\n");

        emit(GetAcceptedTripSuccess(carpoolTripParam: data));
      },
    );
  }
}
