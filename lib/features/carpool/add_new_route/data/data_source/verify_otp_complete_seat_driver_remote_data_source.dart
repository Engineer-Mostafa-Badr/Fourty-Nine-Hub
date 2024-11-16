import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/complete_seat_param.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/verify_otp_param.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';

abstract class VerifyOtpCompleteSeatDriverRemoteDataSource {
  Future<Either<Failure, Map<String, dynamic>>> verifyUserOtp(
      {required VerifyOtpParam verifyOtpParam, required String tripId});
  Future<Either<Failure, Map<String, dynamic>>> completeUserSeat({
    required CompleteSeatParam completeSeatParam,
  });
}

class VerifyOtpCompleteSeatDriverRemoteDataSourceImp
    extends VerifyOtpCompleteSeatDriverRemoteDataSource {
  final ApiConsumer apiConsumer;

  VerifyOtpCompleteSeatDriverRemoteDataSourceImp({required this.apiConsumer});

  @override
  Future<Either<Failure, Map<String, dynamic>>> completeUserSeat(
      {required CompleteSeatParam completeSeatParam}) async {
    const t =
        'VerifyOtpCompleteSeatDriverRemoteDataSourceImp - completeUserSeat ';
    final response = await apiConsumer.post(
      EndPoints.completeUserSeat,
      data: completeSeatParam.toMap(),
    );

    return response.fold(
      (failure) => Left(pr(failure, t)),
      (data) {
        pr(data.toString(), t);
        return Right(data);
      },
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyUserOtp(
      {required VerifyOtpParam verifyOtpParam, required String tripId}) async {
    const t =
        'VerifyOtpCompleteSeatDriverRemoteDataSourceImp - completeUserSeat ';
    final response = await apiConsumer.post(
      EndPoints.verifyUserOtp(tripId),
      data: verifyOtpParam.toMap(),
    );

    return response.fold(
      (failure) => Left(pr(failure, t)),
      (data) {
        pr(data.toString(), t);
        return Right(data);
      },
    );
  }
}
