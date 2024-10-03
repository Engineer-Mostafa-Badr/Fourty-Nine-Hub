import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/models/carpool_route_info_model.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/get_price_carpool_param.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';

abstract class AddNewRouteRemoteDataSource {
  Future<Either<Failure, CarpoolRouteInfoModel>> getPriceCarpool({
    required GetPriceCarpoolParam getPriceCarpoolParam,
  });
}

class AddNewRouteRemoteDataSourceImp extends AddNewRouteRemoteDataSource {
  final ApiConsumer apiConsumer;

  AddNewRouteRemoteDataSourceImp({required this.apiConsumer});
  @override
  Future<Either<Failure, CarpoolRouteInfoModel>> getPriceCarpool({
    required GetPriceCarpoolParam getPriceCarpoolParam,
  }) async {
    const t = 'getPriceCarpool - AddNewRouteRemoteDataSourceImp ';
    final response = await apiConsumer.post(
      EndPoints.carpoolRoutePrice,
      data: getPriceCarpoolParam.toMap(),
    );

    return response.fold(
      (failure) => Left(pr(failure, t)),
      (data) {
        CarpoolRouteInfoModel carpoolRouteInfoModel = CarpoolRouteInfoModel.fromJson(data['data']);
        pr(carpoolRouteInfoModel.toString(), t);
        return Right(carpoolRouteInfoModel);
      },
    );
  }
}
