import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import 'package:fourtyninehub/features/mazadat_feature/auction_details/data/models/bidding_model.dart';

import 'package:fourtyninehub/features/mazadat_feature/auction_list/domain/entities/auction_entity.dart';

import '../../../../../core/error/failure.dart';

import '../../../auction_list/data/models/auction_model.dart';
import '../../domain/entities/bidding_entity.dart';
import '../../domain/usecases/send_bidding_usecase.dart';

abstract class AuctionDetailsRemoteDataSource {
  Future<Either<Failure, AuctionEntity>> getAuctionDetails(
      {required String id});
  Future<Either<Failure, bool>> sendAuction(
      {required SendBiddingParams params});
  Future<Either<Failure, bool>> followUserAuctions({required String userId});
  Future<Either<Failure, bool>> finishAuction({required String id});
  Future<Either<Failure, List<BiddingEntity>>> getAuctionRequests(
      {required String id});
}

class AuctionDetailsRemoteDataSourceImpl
    implements AuctionDetailsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  AuctionDetailsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, bool>> followUserAuctions(
      {required String userId}) async {
    final response =
        await _apiConsumer.post(EndPoints.followUserAuctions(userId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, AuctionEntity>> getAuctionDetails(
      {required String id}) async {
    final response = await _apiConsumer.get(EndPoints.auctionDetails(id));
    return response.fold((failure) => Left(failure),
        (data) => Right(AuctionModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, bool>> sendAuction(
      {required SendBiddingParams params}) async {
    final response = await _apiConsumer.post(
        EndPoints.sendAuctionRequest(params.auctionId),
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> finishAuction({required String id}) async {
    final response = await _apiConsumer.put(EndPoints.endAuction(id));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<BiddingEntity>>> getAuctionRequests(
      {required String id}) async {
    final response = await _apiConsumer.get(EndPoints.getAuctionRequests(id));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => BiddingModel.fromJson(e))
            .toList()));
  }
}
