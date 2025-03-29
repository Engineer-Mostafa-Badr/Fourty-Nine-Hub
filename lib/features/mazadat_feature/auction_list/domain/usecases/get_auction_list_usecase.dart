import 'package:dartz/dartz.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../food_feature/restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';
import '../entities/auction_entity.dart';
import '../repositories/auction_list_repo.dart';

class GetAuctionListUseCase
    extends UseCase<List<AuctionEntity>, LocationParams> {
  final AuctionListRepo _repo;
  GetAuctionListUseCase(this._repo);

  @override
  Future<Either<Failure, List<AuctionEntity>>> call(LocationParams params) {
    return _repo.getAuctions(params: params);
  }
}
