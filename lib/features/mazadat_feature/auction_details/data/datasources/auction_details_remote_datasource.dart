import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/domain/entities/auction_entity.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../res/assets/jsons.dart';
import '../../../auction_list/data/models/auction_model.dart';

abstract class AuctionDetailsRemoteDataSource {
  Future<Either<Failure, AuctionEntity>> getAuctionDetails(
      {required String id});
  Future<Either<Failure, bool>> sendAuction();
  Future<Either<Failure, bool>> followUserAuctions({required int userId});
}

class AuctionDetailsRemoteDataSourceImpl
    implements AuctionDetailsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  AuctionDetailsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, bool>> followUserAuctions(
      {required int userId}) async {
    return Right(true);
  }

  @override
  Future<Either<Failure, AuctionEntity>> getAuctionDetails(
      {required String id}) async {
    final response = await _apiConsumer.get(EndPoints.auctionDetails(id));
    return response.fold((failure) => Left(failure),
        (data) => Right(AuctionModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, bool>> sendAuction() async {
    return Right(true);
  }
}
