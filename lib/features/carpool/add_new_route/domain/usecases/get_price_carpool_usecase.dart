import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/models/carpool_route_info_model.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/get_price_carpool_param.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/repo/add_new_route_carpool_repo.dart';

class GetPriceCarpoolUsecase {
  final AddNewRouteCarpoolRepo addNewRouteCarpoolRepo;

  GetPriceCarpoolUsecase({required this.addNewRouteCarpoolRepo});
  Future<Either<Failure, CarpoolRouteInfoModel>> call({
    required GetPriceCarpoolParam getPriceCarpoolParam,
  }) {
    return addNewRouteCarpoolRepo.getPriceCarpool(
        getPriceCarpoolParam: getPriceCarpoolParam);
  }
}
