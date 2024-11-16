import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/models/get_lat_and_long_model.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';

abstract class GetLatLongFromAddressRemoteDataSource {
  Future<Either<Failure, LatLongData>> getLatAndLong({
    required String address,
  });
}

class GetLatLongFromAddressRemoteDataSourceImp
    extends GetLatLongFromAddressRemoteDataSource {
  final ApiConsumer apiConsumer;

  GetLatLongFromAddressRemoteDataSourceImp({required this.apiConsumer});
  @override
  Future<Either<Failure, LatLongData>> getLatAndLong({
    required String address,
  }) async {
    const t = 'GetLatAndLong - GetLatAndLongRemoteDataSourceImp ';
    final response = await apiConsumer
        .get(EndPoints.getLatAndLongFromAddress, data: {"address": address});

    return response.fold(
      (failure) => Left(pr(failure, t)),
      (data) {
        GetLatAndLongModel getLatAndLongModel =
            GetLatAndLongModel.fromJson(data);
        pr(getLatAndLongModel.toString(), t);
        return Right(getLatAndLongModel.data);
      },
    );
  }
}
