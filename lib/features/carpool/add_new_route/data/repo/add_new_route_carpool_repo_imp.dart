import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/data_source/add_new_route_remote_data_source.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/models/carpool_route_info_model.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/get_price_carpool_param.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/repo/add_new_route_carpool_repo.dart';

class AddNewRouteCarpoolRepoImp extends AddNewRouteCarpoolRepo {
  final AddNewRouteRemoteDataSource addNewRouteRemoteDataSource;

  AddNewRouteCarpoolRepoImp({required this.addNewRouteRemoteDataSource});
  @override
  Future<Either<Failure, CarpoolRouteInfoModel>> getPriceCarpool(
      {required GetPriceCarpoolParam getPriceCarpoolParam}) {
    return addNewRouteRemoteDataSource.getPriceCarpool(
      getPriceCarpoolParam: getPriceCarpoolParam,
    );
  }
}
