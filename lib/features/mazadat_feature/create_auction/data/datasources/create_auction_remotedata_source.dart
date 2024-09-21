import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/usecases/create_auction_usecase.dart';

abstract class CreateAuctionRemoteDataSource {
  Future<Either<Failure, bool>> createAuction(
      {required CreateAuctionParams params});
}

class CreateAuctionRemoteDataSourceImpl
    implements CreateAuctionRemoteDataSource {
  final ApiConsumer _apiConsumer;
  CreateAuctionRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, bool>> createAuction(
      {required CreateAuctionParams params}) async {
    final response = await _apiConsumer
        .post(EndPoints.createAuction(params.adId), data: params.toJson());
    return response.fold((l) => Left(l), (r) => Right(r['status']));
  }
}
