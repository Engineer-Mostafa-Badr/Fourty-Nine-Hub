import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/data/models/trip_join_card_model/available_trip_join_model.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/available_trip_join_entity.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/data/datasources/remote/socket/socket_data_source.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared_web_socket.dart';
import '../../domain/entities/add_favorite_auction_entity.dart';
import '../../domain/entities/auction_all_winner_entity.dart';
import '../../domain/entities/auction_banner_entity.dart';
import '../../domain/entities/auction_main_category_entity.dart';
import '../../domain/entities/auction_participants_entity.dart';
import '../../domain/entities/auction_sub_category_entity.dart';
import '../../domain/entities/auction_viewer_entity.dart';
import '../../domain/entities/error_bid_auction_entity.dart';
import '../../domain/entities/get_all_auction_entity.dart';
import '../../domain/entities/listen_winner_bid_entity.dart';
import '../../domain/entities/my_bidders_entity.dart';
import '../../domain/usecases/add_favorite_auction_use_case.dart';
import '../../domain/usecases/create_auction_use_case.dart';
import '../../domain/usecases/fetch_available_auction_use_case.dart';
import '../../domain/usecases/fetch_participants_auction_use_case.dart';
import '../../domain/usecases/fetch_single_auction_use_case.dart';
import '../../domain/usecases/fetch_sub_category_auction_use_case.dart';
import '../../domain/usecases/search_auction_use_case.dart';
import '../models/add_favorite_auction_model.dart';
import '../models/auction_all_winner_model.dart';
import '../models/auction_banner_model.dart';
import '../models/auction_main_category_model.dart';
import '../models/auction_participants_model.dart';
import '../models/auction_sub_category_model.dart';
import '../models/auction_viewer_model.dart';
import '../models/error_bid_auction_model.dart';
import '../models/get_all_auction_model.dart';
import '../models/listen_winner_bid_model.dart';
import '../models/my_bidders_model.dart';


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



  // @override
  // void listenToNewBidAuction(Function(AuctionParticipantsEntity participant) onData) {
  //   try {
  //     CliLogger.info("🔔 Listening to new bids...");
  //
  //     SharedWebSocket.socket?.on("auction:new-amount-bid", (data) {
  //       CliLogger.info("📩 New bid received: $data");
  //
  //       try {
  //         final decoded = (data is String) ? jsonDecode(data) : data;
  //
  //         // 👇 unwrap "data" if the backend sends { "data": {...} }
  //         final payload = decoded is Map && decoded.containsKey("data")
  //             ? decoded["data"]
  //             : decoded;
  //
  //         final participant = AuctionParticipantsModel.fromJson(payload);
  //         onData(participant);
  //       } catch (e, st) {
  //         CliLogger.info("❌ Error parsing new bid: $e\n$st");
  //       }
  //     });
  //   } catch (e, st) {
  //     CliLogger.info("❌ Error while setting up bid listener: $e\n$st");
  //   }
  // }

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

  @override
  Future<Either<Failure, AddFavoriteAuctionEntity>> addFavoriteAuction({required FavoriteAuctionParams params}) async{
    final url = "${EndPoints.addFavoriteAuction}${params.id}/addOrRemove";
    final response = await _apiConsumer.post(url,);

    return response.fold(
          (l) => Left(l),
          (data) {
        final blockRestaurantModel = AddFavoriteAuctionModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, List<GetAvailableAuctionEntity>>> getMyAuction({required GetAuctionParams params})async {
    final url = "${EndPoints.fetchMyAuction}?page=${params.page}&limit=${params.limit}";

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
  Future<Either<Failure, CreateAuctionEntity >> createAuction({required CreateAuctionParams params}) async{
    final url = "${EndPoints.createAuction2}";
    final response = await _apiConsumer.post(url,data: params.toJson());

    return response.fold(
          (l) => Left(l),
          (data) {
        final blockRestaurantModel = CreateAuctionModel .fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, List<MyBiddersEntity>>> getMyBidderAuction({required GetAuctionParams params})async {
    final url = "${EndPoints.fetchMyBidders}?page=${params.page}&limit=${params.limit}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rideList = (data['data'] as List)
            .map((e) => MyBiddersModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }

  @override
  Future<Either<Failure, AuctionBannerEntity>> bannerAuction() async{
    final url = "${EndPoints.auctionBanner}";
    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final blockRestaurantModel = AuctionBannerModel.fromJson(data);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, AuctionWinnerDataEntity>> getAllWinnerAuction() async{
    final url = "${EndPoints.auctionAllWinner}";
    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final blockRestaurantModel = AuctionWinnerDataModel.fromJson(data['data']);
        return Right(blockRestaurantModel);
      },
    );
  }

  @override
  Future<Either<Failure, List<GetAvailableAuctionEntity>>> searchAuction({required SearchAuctionParams params})async {
    final url = "${EndPoints.searchAuction}?page=${params.page}&limit=${params.limit}&searchQuery=${params.searchQuery}";

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
  void listenToBidError(Function(BidErrorEntity error) onError) {
    try {
      CliLogger.info("🔔 Listening to bid errors...");

      SharedWebSocket.socket?.on("error", (data) {
        CliLogger.info("📩 Bid error received: $data");

        try {
          final decoded = (data is String) ? jsonDecode(data) : data;

          // 👇 unwrap "data" if the backend sends { "data": {...} }
          final payload = decoded is Map && decoded.containsKey("data")
              ? decoded["data"]
              : decoded;

          final errorEntity = BidErrorModel.fromJson(payload);
          onError(errorEntity);
        } catch (e, st) {
          CliLogger.info("❌ Error parsing bid error: $e\n$st");
        }
      });
    } catch (e, st) {
      CliLogger.info("❌ Error while setting up bid error listener: $e\n$st");
    }
  }

  @override
  void listenToBidWinner(Function(BidWinnerEntity winner) onData) {
    try {
      CliLogger.info("👑 Listening for auction winners...");
      SharedWebSocket.socket?.off(SocketIOListeners.auctionWinner);

      SharedWebSocket.socket?.on(
          SocketIOListeners.auctionWinner,
              (data) {
            CliLogger.info("👑 Winner event received: $data");

            try {
              final decoded = (data is String) ? jsonDecode(data) : data;

              // 👇 unwrap "data" if backend sends { "data": {...} }
              final payload = decoded is Map && decoded.containsKey("data")
                  ? decoded["data"]
                  : decoded;

              final winner = BidWinnerModel.fromJson(payload);
              onData(winner); // ✅ forward to cubit via repository
            } catch (e, st) {
              CliLogger.info("❌ Error parsing winner event: $e\n$st");
            }
          });
    } catch (e, st) {
      CliLogger.info("❌ Error while setting up winner listener: $e\n$st");
    }
  }

  @override
  void leaveAuction(String auctionId) {
    try {
      CliLogger.info("Leaving auction $auctionId");
      // send just the string ID
      SharedWebSocket.socket?.emit(
        SocketIOListeners.leaveAuction,
        auctionId,
      );
    } catch (e) {
      CliLogger.info("Error while joining auction: $e");
    }
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
        // "auction:add:bid:amount",
        SocketIOListeners.bidAuction,
        // "auction:add:bid:amount",
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

      // ✅ Always clear any previous listeners for this event first
      // SharedWebSocket.socket?.off(SocketIOListeners.auctionNewAmountBid);

      // ✅ Then add a fresh listener
      SharedWebSocket.socket?.on(SocketIOListeners.auctionNewAmountBid, (data) {
        CliLogger.info("📩 New bid received: $data");

        try {
          final decoded = (data is String) ? jsonDecode(data) : data;

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

  // @override
  // void listenToNewBidAuction(Function(AuctionParticipantsEntity participant) onData) {
  //   try {
  //     CliLogger.info("🔔 Listening to new bids...");
  //
  //     // remove any old listeners to avoid duplicates
  //     // SharedWebSocket.socket?.off("auction:new-amount-bid");
  //
  //     SharedWebSocket.socket?.on(SocketIOListeners.auctionNewAmountBid, (data) {
  //       // SharedWebSocket.socket?.on("auction:new-amount-bid", (data) {
  //       CliLogger.info("📩 New bid received: $data");
  //
  //       try {
  //         final decoded = (data is String) ? jsonDecode(data) : data;
  //
  //         final payload = decoded is Map && decoded.containsKey("data")
  //             ? decoded["data"]
  //             : decoded;
  //
  //         final participant = AuctionParticipantsModel.fromJson(payload);
  //         onData(participant);
  //       } catch (e, st) {
  //         CliLogger.info("❌ Error parsing new bid: $e\n$st");
  //       }
  //     });
  //   } catch (e, st) {
  //     CliLogger.info("❌ Error while setting up bid listener: $e\n$st");
  //   }
  // }

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
  Future<Either<Failure, List<ViewerEntity>>> getViewerAuction({required FavoriteAuctionParams params}) async{
    final url = "${EndPoints.getAuctionViewers}${params.id}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final rideList = (data['data']['views'] as List)
            .map((e) => ViewerModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(rideList);
      },
    );
  }



}
