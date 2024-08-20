import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../food_feature/restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';
import '../entities/auction_entity.dart';

abstract class AuctionListRepo {
  Future<Either<Failure, List<AuctionEntity>>> getAuctions(
      {required LocationParams params});
}
