import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/data/models/auction_model.dart';
import '../../../../../core/api/api_consumer.dart';
import '../../../../../core/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../../../../food_feature/restaurants_list/domain/usecases/get_nearby_restaurants_usecase.dart';
import '../../domain/entities/auction_entity.dart';

abstract class AuctionListRemoteDataSource {
  Future<Either<Failure, List<AuctionEntity>>> getAuctions(
      {required LocationParams params});
}

class AuctionListRemoteDataSourceImpl implements AuctionListRemoteDataSource {
  final ApiConsumer _apiConsumer;
  AuctionListRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<AuctionEntity>>> getAuctions(
      {required LocationParams params}) async {
    final response = await _apiConsumer.get(EndPoints.auctionsList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['docs'] as List)
            .map((e) => AuctionModel.fromJson(e))
            .toList()));
  }
}
