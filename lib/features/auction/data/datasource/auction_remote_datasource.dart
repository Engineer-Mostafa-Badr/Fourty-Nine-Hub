import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/data/datasources/remote/socket/socket_data_source.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared_web_socket.dart';
import '../../domain/entities/auction_main_category_entity.dart';
import '../../domain/entities/auction_participants_entity.dart';
import '../../domain/entities/auction_sub_category_entity.dart';
import '../../domain/entities/get_all_auction_entity.dart';
import '../../domain/usecases/fetch_available_auction_use_case.dart';
import '../../domain/usecases/fetch_participants_auction_use_case.dart';
import '../../domain/usecases/fetch_single_auction_use_case.dart';
import '../../domain/usecases/fetch_sub_category_auction_use_case.dart';
import '../models/auction_main_category_model.dart';
import '../models/auction_participants_model.dart';
import '../models/auction_sub_category_model.dart';
import '../models/get_all_auction_model.dart';


abstract class AuctionRemoteDataSource {
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

}

class AuctionRemoteDataSourceImpl
    implements AuctionRemoteDataSource {
  final ApiConsumer _apiConsumer;

  AuctionRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<GetAvailableAuctionEntity>>> getAvailableAuction({required GetAuctionParams params})async {
    final url = "${EndPoints.fetchAvailableAuction}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rideList = (data['data'] as List)
            .map((e) => GetAvailableAuctionModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }
  @override
  void joinAuction(String auctionId) {
    try {
      CliLogger.info("Joining auction $auctionId");
      // send just the string ID
      SharedWebSocket.socket?.emit(
        SocketIOListeners.joinAuction,
        auctionId,
      );
    } catch (e) {
      CliLogger.info("Error while joining auction: $e");
    }
  }


@override
  void listenToNewAuction(Function(GetAvailableAuctionEntity trip) params) {
    try {
      CliLogger.info("auction NewAuction ");
      log("auction NewAuction ");
      SharedWebSocket.socket!.emit(SocketIOListeners.joinAuction, (data) {
        // final decodedData = jsonDecode(data);
        // CliLogger.info("offer data :  $decodedData");
        // params(RideOfferModel.fromJson(decodedData));
        CliLogger.info("New Trip data :  $data");
        log("New Trip data :  $data");
        log("New Trip data['newAvailableTrip'] :  ${data['newAvailableTrip']}");
        params(GetAvailableAuctionModel.fromJson(data['newAvailableTrip']));
      });
    } catch (e) {
      CliLogger.info("can't listen to trip price error $e");
    }
  }

  @override
  Future<Either<Failure, GetAvailableAuctionEntity>> getSingleAuction({required SingleAuctionParams params}) async{
    final url = "${EndPoints.fetchSingleAuction}${params.id}";
    final response = await _apiConsumer.get(url,);

    return response.fold(
          (l) => Left(l),
          (data) {
        final blockRestaurantModel = GetAvailableAuctionModel.fromJson(data["data"]);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, List<AuctionParticipantsEntity>>> getParticipantsAuction({required PriceAuctionParams params})async {
    final url = "${EndPoints.fetchParticipantAuction}${params.id}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rideList = (data['data'] as List)
            .map((e) => AuctionParticipantsModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }

  @override
  void sendBid(String auctionId, int newPrice) {
    try {
      final payload = {
        "auctionId": auctionId,
        "bidAmount": newPrice,
      };

      CliLogger.info("➡️ Sending bid: $payload");

      SharedWebSocket.socket?.emit(
        "auction:add:bid:amount",
        jsonEncode(payload),   // 👈 send as raw JSON string
      );

    } catch (e) {
      CliLogger.info("❌ Error while sending bid: $e");
    }
  }

  @override
  void listenToNewBidAuction(Function(AuctionParticipantsEntity participant) onData) {
    try {
      CliLogger.info("🔔 Listening to new bids...");

      SharedWebSocket.socket?.on("auction:new-amount-bid", (data) {
        CliLogger.info("📩 New bid received: $data");

        try {
          final decoded = (data is String) ? jsonDecode(data) : data;

          // 👇 unwrap "data" if the backend sends { "data": {...} }
          final payload = decoded is Map && decoded.containsKey("data")
              ? decoded["data"]
              : decoded;

          final participant = AuctionParticipantsModel.fromJson(payload);
          onData(participant);
        } catch (e, st) {
          CliLogger.info("❌ Error parsing new bid: $e\n$st");
        }
      });
    } catch (e, st) {
      CliLogger.info("❌ Error while setting up bid listener: $e\n$st");
    }
  }

  @override
  Future<Either<Failure, List<AuctionMainCategoryEntity>>> getAuctionMainCategory({required GetAuctionParams params})async {
    final url = "${EndPoints.fetchAuctionMainCategory}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rideList = (data['data'] as List)
            .map((e) => AuctionMainCategoryModel .fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }

  @override
  Future<Either<Failure, List<AuctionSubCategoryEntity>>> getAuctionSubCategory({required GetSubCategoryAuctionParams params}) async{
    final url = "${EndPoints.fetchAuctionSubCategory}${params.id}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rideList = (data['data'] as List)
            .map((e) => AuctionSubCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }

  @override
  Future<Either<Failure, List<GetAvailableAuctionEntity>>> getExpiredAuction({required GetAuctionParams params})async {
    final url = "${EndPoints.fetchExpiredAuction}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rideList = (data['data'] as List)
            .map((e) => GetAvailableAuctionModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }

  @override
  Future<Either<Failure, List<GetAvailableAuctionEntity>>> getFavoriteAuction({required GetAuctionParams params}) async{
    final url = "${EndPoints.fetchFavoriteAuction}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rideList = (data['data'] as List)
            .map((e) => GetAvailableAuctionModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }



// @override
  // void sendBid(String auctionId, int newPrice) {
  //   try {
  //     CliLogger.info("Sending bid: $newPrice on auction $auctionId");
  //
  //     SharedWebSocket.socket?.emit(
  //       SocketIOListeners.bidAuction, // "auction:add:bid:amount"
  //       {
  //         "auctionId": auctionId,
  //         "bidAmount": newPrice,
  //       },
  //     );
  //
  //
  //   } catch (e) {
  //     CliLogger.info("Error while sending bid: $e");
  //   }
  // }



}
