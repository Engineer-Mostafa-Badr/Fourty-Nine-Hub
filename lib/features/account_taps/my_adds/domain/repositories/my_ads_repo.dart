import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../ads_feature/ads/domain/entities/ad_entity.dart';
import '../../../../ride/trip_details/domain/entities/trip_and_request_entity.dart';
import '../entity/my_ads_auction.dart';
import '../entity/my_ads_trip_join_entity.dart';

abstract class MyAdsRepo {
  Future<Either<Failure, List<AdEntity>>> getAds();
  Future<Either<Failure, bool>> cancelAd({required String id});
  Future<Either<Failure, bool>> deactivateAd({required int id});
  Future<Either<Failure, List<TripAndRequestEntity>>> getComeWithMeAds();
  Future<Either<Failure, List<TripAndRequestEntity>>> getPickMeAds();
  Future<Either<Failure, bool>> deleteComeWithMeAd({required String id});
  Future<Either<Failure, bool>> deletePickMeAd({required String id});
  Future<Either<Failure, bool>> acceptPickMeRequest({required String id});
  Future<Either<Failure, bool>> rejectPickMeRequest({required String id});
  Future<Either<Failure, bool>> acceptComeWithYouRequests({required String id});
  Future<Either<Failure, bool>> rejectComeWithYouRequests({required String id});
  Future<Either<Failure, List<MyAuctionAdsEntity>>> getMyAuctions();
  Future<Either<Failure, List<MyAuctionAdsEntity>>> getMyInstallments();
  Future<Either<Failure, List<MyAuctionAdsEntity>>> getMyOtherAds();
  Future<Either<Failure, MyAdsTripJoinEntity>> getMyTripJoin();
  Future<Either<Failure, bool>> deleteMyTripJoin({required String id});
  Future<Either<Failure, bool>> deleteMyInstallment({required String id});
}
