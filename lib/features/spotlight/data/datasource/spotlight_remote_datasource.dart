import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/spotlight/data/models/spotlight_model.dart';
import 'package:fourtyninehub/features/spotlight/domain/entities/spotlight_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/data/models/trip_join_card_model/available_trip_join_model.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/available_trip_join_entity.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/data/datasources/remote/socket/socket_data_source.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared_web_socket.dart';



abstract class SpotlightRemoteDataSource {
  /*
  Future<Either<Failure, List<GetAvailableAuctionEntity >>> getAvailableAuction({required GetAuctionParams params});
   void listenToNewAuction(Function(GetAvailableAuctionEntity trip) params);
  void joinAuction(String auctionId); // 🔥 add this
  Future<Either<Failure, GetAvailableAuctionEntity>> getSingleAuction({required SingleAuctionParams params});
  Future<Either<Failure, List<AuctionParticipantsEntity>>> getParticipantsAuction({required PriceAuctionParams params});
  void sendBid(String auctionId, int newPrice);
  void listenToNewBidAuction(Function(AuctionParticipantsEntity trip) params);
  Future<Either<Failure, List<AuctionMainCategoryEntity>>> getAuctionMainCategory({required GetAuctionParams params});
  Future<Either<Failure, List<AuctionSubCategoryEntity>>> getAuctionSubCategory({required GetSubCategoryAuctionParams params});
  Future<Either<Failure, List<GetAvailableAuctionEntity >>> getExpiredAuction({required GetAuctionParams params});
  Future<Either<Failure, List<GetAvailableAuctionEntity >>> getFavoriteAuction({required GetAuctionParams params});
  Future<Either<Failure, AddFavoriteAuctionEntity >> addFavoriteAuction({required FavoriteAuctionParams params});
  Future<Either<Failure, List<GetAvailableAuctionEntity >>> getMyAuction({required GetAuctionParams params});
  void listenToBidError(Function(BidErrorEntity error) onError);
  void listenToBidWinner(Function(BidWinnerEntity winner) onData);
  void leaveAuction(String auctionId);
  Future<Either<Failure, CreateAuctionEntity  >> createAuction({required CreateAuctionParams  params});
  Future<Either<Failure, List<MyBiddersEntity>>> getMyBidderAuction({required GetAuctionParams params});
  Future<Either<Failure, AuctionBannerEntity>> bannerAuction();
  Future<Either<Failure, AuctionWinnerDataEntity >> getAllWinnerAuction();
  Future<Either<Failure, List<GetAvailableAuctionEntity >>> searchAuction({required SearchAuctionParams params});
  Future<Either<Failure, List<ViewerEntity>>> getViewerAuction({required FavoriteAuctionParams params});
  Future<Either<Failure, List<AuctionAllWinnerEntity>>> getAuctionWinners({required GetAuctionParams params});
*/
  Future<Either<Failure, SpotlightEntity>> getSpotLight();

}

class SpotlightRemoteDataSourceImpl
    implements SpotlightRemoteDataSource {
  final ApiConsumer _apiConsumer;

  SpotlightRemoteDataSourceImpl(this._apiConsumer);


  // @override
  // Future<Either<Failure, GetAvailableAuctionEntity>> getSingleAuction({required SingleAuctionParams params}) async{
  //   final url = "${EndPoints.fetchSingleAuction}${params.id}";
  //   final response = await _apiConsumer.get(url,);
  //
  //   return response.fold(
  //         (l) => Left(l),
  //         (data) {
  //       final blockRestaurantModel = GetAvailableAuctionModel.fromJson(data["data"]);
  //       return Right(blockRestaurantModel);
  //     },
  //   );
  // }

  @override
  Future<Either<Failure, SpotlightEntity>> getSpotLight() async{
    final url = "${EndPoints.getMyProfileSpotlight}";
    final response = await _apiConsumer.get(url,);

    return response.fold(
          (l) => Left(l),
          (data) {
        final blockRestaurantModel = SpotlightModel.fromJson(data["data"]["profile"]);
        return Right(blockRestaurantModel);
      },
    );
  }





}
