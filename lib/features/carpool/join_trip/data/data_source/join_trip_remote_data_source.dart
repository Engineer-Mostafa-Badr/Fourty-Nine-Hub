import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/join_trip/data/models/join_trip_carpool_model.dart';
import 'package:fourtyninehub/features/carpool/join_trip/domain/entities/join_trip_entity.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';

abstract class JoinTripRemoteDataSource {
  Future<Either<Failure, JoinTripCarpoolModel>> joinTripCarpool({
    required JoinTripCarPoolParam joinTripCarPoolParam,
  });
}

class JoinTripRemoteDataSourceImp extends JoinTripRemoteDataSource {
  final ApiConsumer apiConsumer;
  JoinTripRemoteDataSourceImp({required this.apiConsumer});

  @override
  Future<Either<Failure, JoinTripCarpoolModel>> joinTripCarpool(
      {required JoinTripCarPoolParam joinTripCarPoolParam}) async {
    const trip = 'joinTripCarPool - JoinTripRemoteDataSourceImp ';
    final response = await apiConsumer.post(
      EndPoints.joinTripCarPool,
      data: joinTripCarPoolParam.toMap(),
    );
    print("this is response1 ===============================\n");
    print(response);
    return response.fold((failure) => Left(pr(failure, trip)), (data) {
      print("this is response 2 ===============================\n");

      JoinTripCarpoolModel joinTripCarpoolModel =
          JoinTripCarpoolModel.fromJson(data);
      print("this is response 3===============================\n");

      pr(joinTripCarpoolModel.toString(), trip);
      return right(joinTripCarpoolModel);
    });
  }
}
