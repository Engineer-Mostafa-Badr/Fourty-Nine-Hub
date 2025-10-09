import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/auction/domain/entities/add_favorite_auction_entity.dart';
import 'package:fourtyninehub/features/auction/domain/entities/auction_all_winner_entity.dart';
import 'package:fourtyninehub/features/auction/domain/entities/auction_banner_entity.dart';
import 'package:fourtyninehub/features/auction/domain/entities/auction_main_category_entity.dart';
import 'package:fourtyninehub/features/auction/domain/entities/auction_participants_entity.dart';
import 'package:fourtyninehub/features/auction/domain/entities/auction_sub_category_entity.dart';
import 'package:fourtyninehub/features/auction/domain/entities/auction_viewer_entity.dart';
import 'package:fourtyninehub/features/auction/domain/entities/error_bid_auction_entity.dart';
import 'package:fourtyninehub/features/auction/domain/entities/get_all_auction_entity.dart';
import 'package:fourtyninehub/features/auction/domain/entities/listen_winner_bid_entity.dart';
import 'package:fourtyninehub/features/auction/domain/entities/my_bidders_entity.dart';
import 'package:fourtyninehub/features/auction/domain/usecases/add_favorite_auction_use_case.dart';
import 'package:fourtyninehub/features/auction/domain/usecases/create_auction_use_case.dart';
import 'package:fourtyninehub/features/auction/domain/usecases/fetch_available_auction_use_case.dart';
import 'package:fourtyninehub/features/auction/domain/usecases/fetch_sub_category_auction_use_case.dart';
import 'package:fourtyninehub/features/auction/domain/usecases/search_auction_use_case.dart';

import '../../domain/repositories/auction_repo.dart';
import '../../domain/usecases/fetch_participants_auction_use_case.dart';
import '../../domain/usecases/fetch_single_auction_use_case.dart';
import '../datasource/auction_remote_datasource.dart';

class AuctionRepoImpl implements AuctionRepository {
  final AuctionRemoteDataSource _remoteDataSource;
  AuctionRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<GetAvailableAuctionEntity>>> getAvailableAuction({required GetAuctionParams params}) {
    return _remoteDataSource.getAvailableAuction(params: params);
  }

  @override
  void listenToNewAuction(Function(GetAvailableAuctionEntity trip) params) {
    _remoteDataSource.listenToNewAuction(params);

  }

  @override
  void joinAuction(String auctionId) {
    _remoteDataSource.joinAuction(auctionId);
  }

  @override
  Future<Either<Failure, GetAvailableAuctionEntity>> getSingleAuction({required SingleAuctionParams params}) {
    return _remoteDataSource.getSingleAuction(params: params);
  }

  @override
  Future<Either<Failure, List<AuctionParticipantsEntity>>> getParticipantsAuction({required PriceAuctionParams params}) {
    return _remoteDataSource.getParticipantsAuction(params: params);
  }

  @override
  Future<void> sendBid(String auctionId, int newPrice) async {
    return _remoteDataSource.sendBid(auctionId, newPrice);
  }

  @override
  void listenToNewBidAuction(Function(AuctionParticipantsEntity trip) params) {
    return _remoteDataSource.listenToNewBidAuction(params);
  }

  @override
  Future<Either<Failure, List<AuctionMainCategoryEntity>>> getAuctionMainCategory({required GetAuctionParams params}) {
    return _remoteDataSource.getAuctionMainCategory(params: params);
  }

  @override
  Future<Either<Failure, List<AuctionSubCategoryEntity>>> getAuctionSubCategory({required GetSubCategoryAuctionParams params}) {
    return _remoteDataSource.getAuctionSubCategory(params: params);
  }

  @override
  Future<Either<Failure, List<GetAvailableAuctionEntity>>> getExpiredAuction({required GetAuctionParams params}) {
    return _remoteDataSource.getExpiredAuction(params: params);
  }

  @override
  Future<Either<Failure, List<GetAvailableAuctionEntity>>> getFavoriteAuction({required GetAuctionParams params}) {
    return _remoteDataSource.getFavoriteAuction(params: params);
  }

  @override
  Future<Either<Failure, AddFavoriteAuctionEntity>> addFavoriteAuction({required FavoriteAuctionParams params}) {
    return _remoteDataSource.addFavoriteAuction(params: params);
  }

  @override
  Future<Either<Failure, List<GetAvailableAuctionEntity>>> getMyAuction({required GetAuctionParams params}) {
    return _remoteDataSource.getMyAuction(params: params);
  }

  @override
  void listenToBidError(Function(BidErrorEntity error) onError) {
    return  _remoteDataSource.listenToBidError(onError);
  }

  @override
  void listenToBidWinner(Function(BidWinnerEntity winner) onData) {
    return  _remoteDataSource.listenToBidWinner(onData);
  }

  @override
  void leaveAuction(String auctionId) {
    _remoteDataSource.leaveAuction(auctionId);
  }

  @override
  Future<Either<Failure, CreateAuctionEntity >> createAuction({required CreateAuctionParams params}) {
    return _remoteDataSource.createAuction(params: params);
  }

  @override
  Future<Either<Failure, List<MyBiddersEntity>>> getMyBidderAuction({required GetAuctionParams params}) {
    return _remoteDataSource.getMyBidderAuction(params: params);
  }

  @override
  Future<Either<Failure, AuctionBannerEntity>> bannerAuction() {
    return _remoteDataSource.bannerAuction();
  }

  @override
  Future<Either<Failure, AuctionWinnerDataEntity>> getAllWinnerAuction() {
    return _remoteDataSource.getAllWinnerAuction();
  }

  @override
  Future<Either<Failure, List<GetAvailableAuctionEntity>>> searchAuction({required SearchAuctionParams params}) {
    return _remoteDataSource.searchAuction(params: params);
  }

  @override
  Future<Either<Failure, List<AuctionViewerEntity>>> getViewerAuction({required FavoriteAuctionParams params}) {
    return _remoteDataSource.getViewerAuction(params: params);
  }







}
