import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/models/carpool_route_info_model.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/get_price_carpool_param.dart';

abstract class AddNewRouteCarpoolRepo {
  Future<Either<Failure, CarpoolRouteInfoModel>> getPriceCarpool({required GetPriceCarpoolParam getPriceCarpoolParam});
}
