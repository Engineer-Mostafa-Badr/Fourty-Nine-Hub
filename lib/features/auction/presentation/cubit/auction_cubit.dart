import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/auction/auction_helper.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../common/functions/global/upload_image.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/messages/messages.dart';
import '../../../../shared_web_socket.dart';
import '../../domain/entities/add_favorite_auction_entity.dart';
import '../../domain/entities/auction_all_winner_entity.dart';
import '../../domain/entities/auction_banner_entity.dart';
import '../../domain/entities/auction_main_category_entity.dart';
import '../../domain/entities/auction_participants_entity.dart';
import '../../domain/entities/auction_sub_category_entity.dart';
import '../../domain/entities/error_bid_auction_entity.dart';
import '../../domain/entities/get_all_auction_entity.dart';
import '../../domain/entities/listen_winner_bid_entity.dart';
import '../../domain/entities/my_bidders_entity.dart';
import '../../domain/usecases/add_favorite_auction_use_case.dart';
import '../../domain/usecases/banner_auction_use_case.dart';
import '../../domain/usecases/bid_auction_use_case.dart';
import '../../domain/usecases/bid_winner_auction_use_case.dart';
import '../../domain/usecases/create_auction_use_case.dart';
import '../../domain/usecases/error_bid_auction_use_case.dart';
import '../../domain/usecases/fetch_all_winner_auction_use_case.dart';
import '../../domain/usecases/fetch_available_auction_use_case.dart';
import '../../domain/usecases/fetch_expired_auction_use_case.dart';
import '../../domain/usecases/fetch_favorite_auction_use_case.dart';
import '../../domain/usecases/fetch_main_category_auction_use_case.dart';
import '../../domain/usecases/fetch_my_bidder_auction_use_case.dart';
import '../../domain/usecases/fetch_myauction_use_case.dart';
import '../../domain/usecases/fetch_participants_auction_use_case.dart';
import '../../domain/usecases/fetch_single_auction_use_case.dart';
import '../../domain/usecases/fetch_sub_category_auction_use_case.dart';
import '../../domain/usecases/join_auction_use_case.dart';
import '../../domain/usecases/leave_auction_use_case.dart';
import '../../domain/usecases/listen_to_new_auction_use_case.dart';
import '../../domain/usecases/listen_to_new_bid_auction_use_case.dart';
import '../../domain/usecases/search_auction_use_case.dart';


part 'auction_state.dart';

class AuctionCubit extends Cubit<AuctionState> {
  AuctionCubit(this.getAvailableAuctionUseCase, this.listenToNewAuctionUseCase, this.joinToAuctionUseCase, this.getSingleAuctionUseCase, this.getParticipantsAuctionUseCase, this.bidAuctionUseCase, this.listenToNewBidAuctionUseCase, this.getAuctionMainCategoryUseCase, this.getAuctionSubCategoryUseCase, this.getExpiredAuctionUseCase, this.getFavoriteAuctionUseCase, this.addFavoriteAuctionUseCase, this.getMyAuctionUseCase, this.errorBidAuctionUseCase, this.bidWinnerAuctionUseCase, this.leaveToAuctionUseCase, this.createAuctionUseCase, this.getMyBiddersAuctionUseCase, this.bannerAuctionUseCase, this.getAllWinnerAuctionUseCase, this.searchAuctionUseCase)  : super(AuctionState());

  final GetAvailableAuctionUseCase getAvailableAuctionUseCase;
  final ListenToNewAuctionUseCase listenToNewAuctionUseCase;
  final JoinToAuctionUseCase joinToAuctionUseCase;
  final GetSingleAuctionUseCase getSingleAuctionUseCase;
  final GetParticipantsAuctionUseCase getParticipantsAuctionUseCase;
  final BidAuctionUseCase bidAuctionUseCase;
  final ListenToNewBidAuctionUseCase listenToNewBidAuctionUseCase;
  final GetAuctionMainCategoryUseCase getAuctionMainCategoryUseCase;
  final GetAuctionSubCategoryUseCase getAuctionSubCategoryUseCase;
  final GetExpiredAuctionUseCase getExpiredAuctionUseCase;
  final GetFavoriteAuctionUseCase getFavoriteAuctionUseCase;
  final AddFavoriteAuctionUseCase addFavoriteAuctionUseCase;
  final GetMyAuctionUseCase getMyAuctionUseCase;
  final ErrorBidAuctionUseCase errorBidAuctionUseCase;
  final BidWinnerAuctionUseCase bidWinnerAuctionUseCase;
  final LeaveToAuctionUseCase leaveToAuctionUseCase;
  final CreateAuctionUseCase createAuctionUseCase;
  final GetMyBiddersAuctionUseCase getMyBiddersAuctionUseCase;
  final BannerAuctionUseCase bannerAuctionUseCase;
  final GetAllWinnerAuctionUseCase getAllWinnerAuctionUseCase;
  final SearchAuctionUseCase searchAuctionUseCase;

  // 📌 Auction Cubit Pagination Properties
  List<GetAvailableAuctionEntity> searchAuctionData = [];
  bool hasMoreSearchAuction = true;
  int currentPageSearchAuction = 1;
  bool isAuctionMoreSearchAuction = false;
  String currentSearchQuery = ''; // 👈 track current query
  void loadInitialSearchAuction(BuildContext context, String query) async {
    print("🚀 CUBIT: loadInitialSearchAuction() called with query=$query");

    isAuctionInitialLoading = true;
    searchAuctionData.clear();
    currentPageSearchAuction = 1;
    hasMoreSearchAuction = true;
    currentSearchQuery = query; // 👈 set query

    emit(state.copyWith(
      status: StateStatus.loading,
      searchAuction: [],
    ));

    await getSearchAuction(context);

    isAuctionInitialLoading = false;
  }

// Pagination call
  Future<void> getSearchAuction(BuildContext context) async {
    print("🚀 CUBIT: getSearchAuction() called");
    print("📊 State: hasMore=$hasMoreSearchAuction, "
        "isLoading=$isAuctionMoreSearchAuction, "
        "page=$currentPageSearchAuction, "
        "query=$currentSearchQuery");

    if (!hasMoreSearchAuction || isAuctionMoreSearchAuction) {
      return;
    }

    isAuctionMoreSearchAuction = true;

    final response = await searchAuctionUseCase(
      SearchAuctionParams(
        page: currentPageSearchAuction,
        limit: auctionPageSize,
        searchQuery: currentSearchQuery, // 👈 pass query
      ),
    );

    response.fold(
          (failure) {
        isAuctionMoreSearchAuction = false;
        emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ));
      },
          (data) {
        if (currentPageSearchAuction == 1) {
          searchAuctionData = List.from(data);
        } else {
          searchAuctionData.addAll(data);
        }

        if (data.length < auctionPageSize) {
          hasMoreSearchAuction = false;
        } else {
          currentPageSearchAuction++;
        }

        isAuctionMoreSearchAuction = false;

        emit(state.copyWith(
          status: StateStatus.success,
          searchAuction: searchAuctionData,
        ));
      },
    );
  }


  Future<void> fetchAuctionAllWinner() async {
    emit(state.copyWith(status: StateStatus.loading, isLoading: true));
    final response = await getAllWinnerAuctionUseCase(NoParams());

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: StateStatus.error,
          isLoading: false,
        ));
      },
          (updatedRestaurant) {
        emit(state.copyWith(
          auctionWinnerData: updatedRestaurant,
          status: StateStatus.success,
          isLoading: false,
        ));
      },
    );
  }

  Future<void> fetchAuctionBanner() async {
    emit(state.copyWith(status: StateStatus.loading, isLoading: true));
    final response = await bannerAuctionUseCase(NoParams());

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: StateStatus.error,
          isLoading: false,
        ));
      },
          (updatedRestaurant) {
        emit(state.copyWith(
          auctionBanner: updatedRestaurant,
          status: StateStatus.success,
          isLoading: false,
        ));
      },
    );
  }
  Future<void> createAuction({required CreateAuctionParams params}) async {
    emit(state.copyWith(status: StateStatus.loading));

    final response = await createAuctionUseCase(params);

    response.fold(
          (failure) {
        emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
          createAuction: null, // ✅ Clear previous response
        ));
      },
          (updatedRestaurant) {
        emit(state.copyWith(
          createAuction: updatedRestaurant,
          status: StateStatus.success,
        ));
      },
    );
  }

// ✅ Add this method to clear createAuction after handling
  void clearCreateAuctionResponse() {
    emit(state.copyWith(createAuction: null));
  }
  Future<void> createAuction1({required CreateAuctionParams params}) async {
    emit(state.copyWith(status: StateStatus.loading));

    final response = await createAuctionUseCase(params);

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: StateStatus.error,

        ));
      },
          (updatedRestaurant) {
        emit(state.copyWith(
            createAuction: updatedRestaurant,
            status: StateStatus.success,
            // showSnackbar: true
        ));
      },
    );
  }

  void leaveAuction(String auctionId) {
    try {
      CliLogger.info("Cubit: leaving auction $auctionId");
      leaveToAuctionUseCase(auctionId); // 🔥 just send ID
    } catch (e) {
      CliLogger.info("Cubit: error leaving auction: $e");
    }
  }


  Future<void> toggleFavoriteAuction(String auctionId) async {
    emit(state.copyWith(status: StateStatus.loading));

    final response = await addFavoriteAuctionUseCase(
      FavoriteAuctionParams(id: auctionId),
    );

    response.fold(
          (failure) {
        emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ));
      },
          (entity) {
        // ✅ Update Available auctions
        availableAuctionNonSocketData =
            availableAuctionNonSocketData.map((a) {
              if (a.id == auctionId) {
                return a.copyWith(isFavorite: !(a.isFavorite ?? false));
              }
              return a;
            }).toList();
        myAuctionNonSocketData =
            myAuctionNonSocketData.map((a) {
              if (a.id == auctionId) {
                return a.copyWith(isFavorite: !(a.isFavorite ?? false));
              }
              return a;
            }).toList();
        // ✅ Update Expired auctions
        expiredAuctionNonSocketData =
            expiredAuctionNonSocketData.map((a) {
              if (a.id == auctionId) {
                return a.copyWith(isFavorite: !(a.isFavorite ?? false));
              }
              return a;
            }).toList();

        // ✅ Update Favorites list
        final index =
        favoriteAuctionNonSocketData.indexWhere((a) => a.id == auctionId);

        if (index != -1) {
          // Already in favorites → unfavorite → remove from list
          favoriteAuctionNonSocketData = favoriteAuctionNonSocketData
              .where((a) => a.id != auctionId)
              .toList();
        } else {
          // Not in favorites → favorited from Available/Expired → add to list

          final addedFromAvailable =
          availableAuctionNonSocketData.firstWhereOrNull((a) => a.id == auctionId);
          final addedFromExpired =
          expiredAuctionNonSocketData.firstWhereOrNull((a) => a.id == auctionId);

          final newFav = addedFromAvailable ?? addedFromExpired;
          if (newFav != null) {
            favoriteAuctionNonSocketData = [
              ...favoriteAuctionNonSocketData,
              newFav.copyWith(isFavorite: true),
            ];
          }
        }

        emit(state.copyWith(
          status: StateStatus.success,
          addFavoriteAuctionEntity: entity,
          getAvailableAuction: availableAuctionNonSocketData,
          getExpiredAuction: expiredAuctionNonSocketData,
          getFavoriteAuction: favoriteAuctionNonSocketData,
        ));
      },
    );
  }

  void listenToBidWinner() {
    CliLogger.info('👑 Listening for auction winners...');

    bidWinnerAuctionUseCase((winner) {
      CliLogger.info("👑 Winner announced: ${winner.username} won ${winner.auctionTitle} at ${winner.price}");

      if (isClosed) {
        CliLogger.info("⚠️ Tried to emit after cubit closed. Ignoring winner event.");
        return;
      }

      emit(state.copyWith(
        status: StateStatus.success,
        bidWinner: winner,
      ));
    });
  }


  void listenToBidErrors() {
    CliLogger.info('🎧 Listening to bid errors...');

    errorBidAuctionUseCase((error) {
      CliLogger.info("❌ Bid error received: ${error.error}");

      emit(state.copyWith(
        status: StateStatus.error,
        bidError: error, // 👈 add a field for bid errors in AuctionState
      ));
    });
  }





  Future<void> uploadMedia({required bool isImage}) async {
    emit(state.copyWith(isUploading: true, status: StateStatus.loading));

    try {
      await UploadMediaHelper.uploadMedia(
        isImage: isImage,
        onUploaded: (uploadFileEntity) {
          final newList = List<UploadFileEntity>.from(state.uploadedFiles)
            ..add(uploadFileEntity);

          emit(state.copyWith(
            uploadedFiles: newList,
            status: StateStatus.success,
            isUploading: false,
          ));
        },
      );

      // If user cancels picker, hide loading
      if (!state.isUploading) return; // already handled by onUploaded
      emit(state.copyWith(isUploading: false));

    } catch (e) {
      // In case of error or cancellation
      emit(state.copyWith(isUploading: false, status: StateStatus.error));
    }
  }


  void deleteUploadedFile(UploadFileEntity file) {
    final newList = List<UploadFileEntity>.from(state.uploadedFiles)
      ..remove(file);

    emit(state.copyWith(uploadedFiles: newList));
  }


  List<String> getAllMediaIds() {
    return state.uploadedFiles.map((e) => e.mediaId).toList();
  }




  List<AuctionParticipantsEntity> participants = [];
  bool hasMoreParticipants = true;
  int currentPageParticipants = 1;
  bool isLoadingMoreParticipants = false;
  bool isInitialLoadingParticipants = false;

  /// Initial load (reset participants and fetch page 1)
  void loadInitialParticipants2(String auctionId) async {
    emit(state.copyWith(status: StateStatus.loading)); // show loader
    isInitialLoadingParticipants = true;
    participants.clear();
    currentPageParticipants = 1;
    hasMoreParticipants = true;
    await getParticipants(auctionId);
    isInitialLoadingParticipants = false;
    emit(state.copyWith(status: StateStatus.success));
  }

  void loadInitialParticipants(String auctionId) async {
    emit(state.copyWith(participantsStatus: StateStatus.loading));
    isInitialLoadingParticipants = true;
    participants.clear();
    currentPageParticipants = 1;
    hasMoreParticipants = true;

    await getParticipants(auctionId);

    isInitialLoadingParticipants = false;
  }

  Future<void> getParticipants(String auctionId) async {
    if (!hasMoreParticipants || isLoadingMoreParticipants) return;

    isLoadingMoreParticipants = true;
    emit(state.copyWith(participantsStatus: StateStatus.loading));

    final response = await getParticipantsAuctionUseCase(
      PriceAuctionParams(
        id: auctionId,
        page: currentPageParticipants,
        limit: 10,
      ),
    );

    response.fold(
          (failure) {
        isLoadingMoreParticipants = false;
        emit(state.copyWith(
          failure: failure,
          participantsStatus: StateStatus.error,
        ));
      },
          (data) {
        participants.addAll(data);

        if (data.length < 10) {
          hasMoreParticipants = false;
        } else {
          currentPageParticipants++;
        }

        isLoadingMoreParticipants = false;
        emit(state.copyWith(
          auctionParticipants: List.from(participants),
          participantsStatus: StateStatus.success,
        ));
      },
    );
  }


  void listenToNewBids() {
    CliLogger.info('🎧 Listening to new bids...');

    listenToNewBidAuctionUseCase((newParticipant) {
      CliLogger.info("📩 New bid participant: ${newParticipant.userId}");

      if (isClosed) {
        CliLogger.info("⚠️ Cubit closed, skipping emit...");
        return;
      }

      participants.removeWhere((p) => p.userId == newParticipant.userId);
      participants.insert(0, newParticipant);

      emit(state.copyWith(
        auctionParticipants: List.from(participants),
        status: StateStatus.success,
      ));
    });
  }




  void sendBid(String auctionId, int amount) async {
    try {
      CliLogger.info("Cubit: send bid $amount");
      await bidAuctionUseCase(BidAuctionParams(
        auctionId: auctionId,
        newPrice: amount,
      ));
      emit(state.copyWith(status: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.error,
      ));
    }
  }

  // 📌 Auction Cubit Pagination Properties
  List<GetAvailableAuctionEntity> availableAuctionNonSocketData = [];
  bool hasMoreAvailableNonSocketAuction = true;
  int currentPageAvailableNonSocketAuction = 1;
  bool isAuctionMoreAvailableNonSocketAuction = false;
  bool isAuctionInitialLoading = false;
  final int auctionPageSize = 5;

// 📌 Initial load (refreshes and loads first page)
  void loadInitialAvailableNonSocketAuction(BuildContext context) async {
    print("🚀 CUBIT: loadInitialAvailableNonSocketAuction() called");

    isAuctionInitialLoading = true;
    availableAuctionNonSocketData.clear();
    currentPageAvailableNonSocketAuction = 1;
    hasMoreAvailableNonSocketAuction = true;

    emit(state.copyWith(
      status: StateStatus.loading,
      getAvailableAuction: [],
    ));

    await getAvailableNonSocketAuction(context);

    isAuctionInitialLoading = false;
  }

  Future<void> getAvailableNonSocketAuction(BuildContext context) async {
    print("🚀 CUBIT: getAvailableNonSocketAuction() called");
    print("📊 State: hasMore=$hasMoreAvailableNonSocketAuction, isLoading=$isAuctionMoreAvailableNonSocketAuction, page=$currentPageAvailableNonSocketAuction");

    if (!hasMoreAvailableNonSocketAuction || isAuctionMoreAvailableNonSocketAuction) {
      print("⚠️ Skipping API call - no more data or already loading");
      return;
    }

    isAuctionMoreAvailableNonSocketAuction = true;

    // 🔄 Only emit loading if it's the first page
    if (currentPageAvailableNonSocketAuction == 1) {
      emit(state.copyWith(status: StateStatus.loading));
    }

    final response = await getAvailableAuctionUseCase(
      GetAuctionParams(
        page: currentPageAvailableNonSocketAuction,
        limit: auctionPageSize,
      ),
    );

    response.fold(
          (failure) {
        print("❌ API call failed: $failure");
        isAuctionMoreAvailableNonSocketAuction = false;

        emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ));
      },
          (data) {
        print("✅ API call success, received ${data.length} items");

        // ➕ Append or reset list depending on page
        if (currentPageAvailableNonSocketAuction == 1) {
          availableAuctionNonSocketData = List.from(data);
        } else {
          availableAuctionNonSocketData.addAll(data);
        }

        print("📊 Total Auction items now: ${availableAuctionNonSocketData.length}");

        // 🔄 Check for more data
        if (data.length < auctionPageSize) {
          hasMoreAvailableNonSocketAuction = false;
          print("🛑 No more auction pages");
        } else {
          currentPageAvailableNonSocketAuction++;
          print("➡️ Next auction page: $currentPageAvailableNonSocketAuction");
        }

        isAuctionMoreAvailableNonSocketAuction = false;

        emit(state.copyWith(
          status: StateStatus.success,
          getAvailableAuction: availableAuctionNonSocketData,
        ));
      },
    );
  }




  void joinAuction(String auctionId) {
    try {
      CliLogger.info("Cubit: joining auction $auctionId");
      joinToAuctionUseCase(auctionId); // 🔥 just send ID
    } catch (e) {
      CliLogger.info("Cubit: error joining auction: $e");
    }
  }

  void listenToNewAuction() {
    CliLogger.info('Listen To New Auction');
    // TripsResponseEntity
    listenToNewAuctionUseCase((trip) {
      List<GetAvailableAuctionEntity> list =
          availableAuctionNonSocketData ?? [];
      list.insert(0, trip);
      emit(state.copyWith(getAvailableAuction: list));
      log(trip.toString());
    });
  }

  Future<void> getSingleAuction(String id) async {
    emit(state.copyWith(status: StateStatus.loading));

    final response = await getSingleAuctionUseCase(
      SingleAuctionParams(id: id),
    );

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
          (blockHealthEntity) async {
        emit(state.copyWith(
          singleAuction: blockHealthEntity,
          status: StateStatus.success,
        ));
      },
    );
  }




  List<AuctionMainCategoryEntity> mainCategories = [];
  bool hasMoreMainCategories = true;
  int currentPageMainCategories = 1;
  bool isMoreMainCategoryAuction = false;
  bool isMainCategoryAuction = false;

  void loadInitialMainCategoryAuction() async {
    emit(state.copyWith(status: StateStatus.loading)); // emit loading state
    isMainCategoryAuction = true;
    availableAuctionNonSocketData.clear();
    currentPageMainCategories = 1;
    hasMoreMainCategories = true;
    await getMainCategoryAuction();
    isMainCategoryAuction = false;
    emit(state.copyWith(status: StateStatus.success));
  }

  Future<void> getMainCategoryAuction() async {
    if (!hasMoreMainCategories || isMoreMainCategoryAuction) {
      return;
    }
    isMoreMainCategoryAuction = true;
    emit(state.copyWith(status: StateStatus.loading));
    final response = await getAuctionMainCategoryUseCase(
        GetAuctionParams(
            page: currentPageMainCategories, limit: 5));
    response.fold(
          (failure) {
        isMoreMainCategoryAuction = false;
        emit(state.copyWith(
            failure: failure,
            // isAuctionMoreLogs: false,
            status: StateStatus.error));
      },
          (data) {
            mainCategories.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreMainCategories = false;
          // emit(state.copyWith(isAuctionMore: false));
          emit(state.copyWith(status: StateStatus.loading));
        } else {
          currentPageMainCategories++;
        }

        isMoreMainCategoryAuction = false;
        emit(state.copyWith(
          auctionMainData: data,
        ));
      },
    );
  }

  /// Load subcategories by mainCategoryId
  Future<void> loadSubCategories(String mainCategoryId) async {
    emit(state.copyWith(status: StateStatus.loading));
    subCategories.clear();
    currentPageSubCategories = 1;
    hasMoreSubCategories = true;
    await getSubCategories(mainCategoryId);
    emit(state.copyWith(status: StateStatus.success));
  }

  Future<void> getSubCategories(String mainCategoryId) async {
    if (!hasMoreSubCategories || isLoadingMoreSubCategories) return;

    isLoadingMoreSubCategories = true;
    final response = await getAuctionSubCategoryUseCase(
      GetSubCategoryAuctionParams(
        id: mainCategoryId,
        page: currentPageSubCategories,
        limit: 10,
      ),
    );

    response.fold(
          (failure) {
        isLoadingMoreSubCategories = false;
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
          (data) {
        subCategories.addAll(data);
        if (data.length < 10) {
          hasMoreSubCategories = false;
        } else {
          currentPageSubCategories++;
        }
        isLoadingMoreSubCategories = false;
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }
  List<AuctionSubCategoryEntity> subCategories = [];
  bool hasMoreSubCategories = true;
  int currentPageSubCategories = 1;
  bool isLoadingMoreSubCategories = false;


  List<GetAvailableAuctionEntity> expiredAuctionNonSocketData = [];
  bool hasMoreExpiredNonSocketAuction = true;
  int currentPageExpiredNonSocketAuction = 1;
  bool isAuctionMoreExpiredNonSocketAuction = false;
  bool isAuctionExpiredNonSocketAuction = false;

  void loadInitialExpiredNonSocketAuction() async {
    print("🚀🚀🚀 CUBIT: loadInitialExpiredNonSocketAuction() called");
    emit(state.copyWith(status: StateStatus.loading)); // emit loading state
    isAuctionExpiredNonSocketAuction = true;
    expiredAuctionNonSocketData.clear();
    currentPageExpiredNonSocketAuction = 1;
    hasMoreExpiredNonSocketAuction = true;
    await getExpiredNonSocketAuction();
    isAuctionExpiredNonSocketAuction = false;
    emit(state.copyWith(status: StateStatus.success));
  }

  Future<void> getExpiredNonSocketAuction() async {
    print("🚀🚀🚀 CUBIT: getExpiredNonSocketAuction() called");
    print("📊 Current state: hasMore=$hasMoreExpiredNonSocketAuction, isLoading=$isAuctionMoreExpiredNonSocketAuction");
    print("📊 Current data length: ${expiredAuctionNonSocketData.length}");
    print("📊 Current page: $currentPageExpiredNonSocketAuction");

    if (!hasMoreExpiredNonSocketAuction || isAuctionMoreExpiredNonSocketAuction) {
      print("⚠️ CUBIT: Skipping call - no more data or already loading");
      return;
    }

    isAuctionMoreExpiredNonSocketAuction = true;

    // Only emit loading if it's the first page (initial load)
    if (currentPageExpiredNonSocketAuction == 1) {
      print("⏳ CUBIT: Emitting loading state for initial load");
      emit(state.copyWith(status: StateStatus.loading));
    }

    print("📡 CUBIT: Making API call for page $currentPageExpiredNonSocketAuction");
    final response = await getExpiredAuctionUseCase(
        GetAuctionParams(
            page: currentPageExpiredNonSocketAuction, limit: 5));

    response.fold(
          (failure) {
        print("❌ CUBIT: API call failed: $failure");
        isAuctionMoreExpiredNonSocketAuction = false;
        emit(state.copyWith(
            failure: failure,
            status: StateStatus.error));
      },
          (data) {
        print("✅ CUBIT: API call successful, received ${data.length} items");
        print("📦 CUBIT: Data received: $data");

        // If it's the first page, replace the data, otherwise add to it
        if (currentPageExpiredNonSocketAuction == 1) {
          expiredAuctionNonSocketData = List.from(data);
          print("🔄 CUBIT: Replaced data for first page");
        } else {
          expiredAuctionNonSocketData.addAll(data);
          print("➕ CUBIT: Added data to existing list");
        }

        print("📊 CUBIT: Total items now: ${expiredAuctionNonSocketData.length}");

        if (data.isEmpty || data.length < 5) {
          hasMoreExpiredNonSocketAuction = false;
          print("🛑 CUBIT: No more pages expired");
        } else {
          currentPageExpiredNonSocketAuction++;
          print("➡️ CUBIT: Moving to next page: $currentPageExpiredNonSocketAuction");
        }

        isAuctionMoreExpiredNonSocketAuction = false;

        // Emit success state with the data
        print("✅ CUBIT: Emitting success state");
        emit(state.copyWith(
          status: StateStatus.success,
          getExpiredAuction: expiredAuctionNonSocketData, // Use the full list, not just the new data
        ));
      },
    );
  }

  List<GetAvailableAuctionEntity> favoriteAuctionNonSocketData = [];
  bool hasMoreFavoriteNonSocketAuction = true;
  int currentPageFavoriteNonSocketAuction = 1;
  bool isAuctionMoreFavoriteNonSocketAuction = false;
  bool isAuctionFavoriteNonSocketAuction = false;

  void loadInitialFavoriteNonSocketAuction() async {
    print("🚀🚀🚀 CUBIT: loadInitialFavoriteNonSocketAuction() called");
    emit(state.copyWith(status: StateStatus.loading)); // emit loading state
    isAuctionFavoriteNonSocketAuction = true;
    favoriteAuctionNonSocketData.clear();
    currentPageFavoriteNonSocketAuction = 1;
    hasMoreFavoriteNonSocketAuction = true;
    await getFavoriteNonSocketAuction();
    isAuctionFavoriteNonSocketAuction = false;
    emit(state.copyWith(status: StateStatus.success));
  }

  Future<void> getFavoriteNonSocketAuction() async {
    print("🚀🚀🚀 CUBIT: getFavoriteNonSocketAuction() called");
    print("📊 Current state: hasMore=$hasMoreFavoriteNonSocketAuction, isLoading=$isAuctionMoreFavoriteNonSocketAuction");
    print("📊 Current data length: ${favoriteAuctionNonSocketData.length}");
    print("📊 Current page: $currentPageFavoriteNonSocketAuction");

    if (!hasMoreFavoriteNonSocketAuction || isAuctionMoreFavoriteNonSocketAuction) {
      print("⚠️ CUBIT: Skipping call - no more data or already loading");
      return;
    }

    isAuctionMoreFavoriteNonSocketAuction = true;

    // Only emit loading if it's the first page (initial load)
    if (currentPageFavoriteNonSocketAuction == 1) {
      print("⏳ CUBIT: Emitting loading state for initial load");
      emit(state.copyWith(status: StateStatus.loading));
    }

    print("📡 CUBIT: Making API call for page $currentPageFavoriteNonSocketAuction");
    final response = await getFavoriteAuctionUseCase(
        GetAuctionParams(
            page: currentPageFavoriteNonSocketAuction, limit: 5));

    response.fold(
          (failure) {
        print("❌ CUBIT: API call failed: $failure");
        isAuctionMoreFavoriteNonSocketAuction = false;
        emit(state.copyWith(
            failure: failure,
            status: StateStatus.error));
      },
          (data) {
        print("✅ CUBIT: API call successful, received ${data.length} items");
        print("📦 CUBIT: Data received: $data");

        // If it's the first page, replace the data, otherwise add to it
        if (currentPageFavoriteNonSocketAuction == 1) {
          favoriteAuctionNonSocketData = List.from(data);
          print("🔄 CUBIT: Replaced data for first page");
        } else {
          favoriteAuctionNonSocketData.addAll(data);
          print("➕ CUBIT: Added data to existing list");
        }

        print("📊 CUBIT: Total items now: ${favoriteAuctionNonSocketData.length}");

        if (data.isEmpty || data.length < 5) {
          hasMoreFavoriteNonSocketAuction = false;
          print("🛑 CUBIT: No more pages favorite");
        } else {
          currentPageFavoriteNonSocketAuction++;
          print("➡️ CUBIT: Moving to next page: $currentPageFavoriteNonSocketAuction");
        }

        isAuctionMoreFavoriteNonSocketAuction = false;

        // Emit success state with the data
        print("✅ CUBIT: Emitting success state");
        emit(state.copyWith(
          status: StateStatus.success,
          getFavoriteAuction: favoriteAuctionNonSocketData, // Use the full list, not just the new data
        ));
      },
    );
  }




  List<GetAvailableAuctionEntity> myAuctionNonSocketData = [];
  bool hasMoreMyAuction = true;
  int currentPageMyAuction = 1;
  bool isAuctionMoreMyAuction = false;
  bool isAuctionMyAuction = false;


  void loadInitialMyAuction() async {
    print("🚀🚀🚀 CUBIT: loadInitialMyAuction() called");
    emit(state.copyWith(status: StateStatus.loading)); // emit loading state
    isAuctionMyAuction = true;
    myAuctionNonSocketData.clear();
    currentPageMyAuction = 1;
    hasMoreMyAuction = true;
    await getMyAuction();
    isAuctionMyAuction = false;
    emit(state.copyWith(status: StateStatus.success));
  }

  Future<void> getMyAuction() async {
    print("🚀🚀🚀 CUBIT: getMyAuction() called");
    print("📊 Current state: hasMore=$hasMoreMyAuction, isLoading=$isAuctionMoreMyAuction");
    print("📊 Current data length: ${myAuctionNonSocketData.length}");
    print("📊 Current page: $currentPageMyAuction");

    if (!hasMoreMyAuction || isAuctionMoreMyAuction) {
      print("⚠️ CUBIT: Skipping call - no more data or already loading");
      return;
    }

    isAuctionMoreMyAuction = true;

    // Only emit loading if it's the first page (initial load)
    if (currentPageMyAuction == 1) {
      print("⏳ CUBIT: Emitting loading state for initial load");
      emit(state.copyWith(status: StateStatus.loading));
    }

    print("📡 CUBIT: Making API call for page $currentPageMyAuction");
    final response = await getMyAuctionUseCase(
        GetAuctionParams(
            page: currentPageMyAuction, limit: 5));

    response.fold(
          (failure) {
        print("❌ CUBIT: API call failed: $failure");
        isAuctionMoreMyAuction = false;
        emit(state.copyWith(
            failure: failure,
            status: StateStatus.error));
      },
          (data) {
        print("✅ CUBIT: API call successful, received ${data.length} items");
        print("📦 CUBIT: Data received: $data");

        // If it's the first page, replace the data, otherwise add to it
        if (currentPageMyAuction == 1) {
          myAuctionNonSocketData = List.from(data);
          print("🔄 CUBIT: Replaced data for first page");
        } else {
          myAuctionNonSocketData.addAll(data);
          print("➕ CUBIT: Added data to existing list");
        }

        print("📊 CUBIT: Total items now: ${myAuctionNonSocketData.length}");

        if (data.isEmpty || data.length < 5) {
          hasMoreMyAuction = false;
          print("🛑 CUBIT: No more pages my");
        } else {
          currentPageMyAuction++;
          print("➡️ CUBIT: Moving to next page: $currentPageMyAuction");
        }

        isAuctionMoreMyAuction = false;

        // Emit success state with the data
        print("✅ CUBIT: Emitting success state");
        emit(state.copyWith(
          status: StateStatus.success,
           getMyAuction: myAuctionNonSocketData, // Use the full list, not just the new data
        ));
      },
    );
  }


  List<MyBiddersEntity> myBiddersData = [];
  bool hasMoreMyBidders = true;
  int currentPageMyBidders = 1;
  bool isAuctionMoreMyBidders = false;
  bool isAuctionMyBidders = false;

  void loadInitialMyBidders() async {
    print("🚀🚀🚀 CUBIT: loadInitialMyBidders() called");
    emit(state.copyWith(status: StateStatus.loading)); // emit loading state
    isAuctionMyBidders = true;
    myBiddersData.clear();
    currentPageMyBidders = 1;
    hasMoreMyBidders = true;
    await getMyBidders();
    isAuctionMyBidders = false;
    emit(state.copyWith(status: StateStatus.success));
  }

  Future<void> getMyBidders() async {
    print("🚀🚀🚀 CUBIT: getMyBidders() called");
    print("📊 Current state: hasMore=$hasMoreMyBidders, isLoading=$isAuctionMoreMyBidders");
    print("📊 Current data length: ${myBiddersData.length}");
    print("📊 Current page: $currentPageMyBidders");

    if (!hasMoreMyBidders || isAuctionMoreMyBidders) {
      print("⚠️ CUBIT: Skipping call - no more data or already loading");
      return;
    }

    isAuctionMoreMyBidders = true;

    // Only emit loading if it's the first page (initial load)
    if (currentPageMyBidders == 1) {
      print("⏳ CUBIT: Emitting loading state for initial load");
      emit(state.copyWith(status: StateStatus.loading));
    }

    print("📡 CUBIT: Making API call for page $currentPageMyBidders");
    final response = await getMyBiddersAuctionUseCase(
        GetAuctionParams(
            page: currentPageMyBidders, limit: 5));

    response.fold(
          (failure) {
        print("❌ CUBIT: API call failed: $failure");
        isAuctionMoreMyBidders = false;
        emit(state.copyWith(
            failure: failure,
            status: StateStatus.error));
      },
          (data) {
        print("✅ CUBIT: API call successful, received ${data.length} items");
        print("📦 CUBIT: Data received: $data");

        // If it's the first page, replace the data, otherwise add to it
        if (currentPageMyBidders == 1) {
          myBiddersData = List.from(data);
          print("🔄 CUBIT: Replaced data for first page");
        } else {
          myBiddersData.addAll(data);
          print("➕ CUBIT: Added data to existing list");
        }

        print("📊 CUBIT: Total items now: ${myBiddersData.length}");

        if (data.isEmpty || data.length < 5) {
          hasMoreMyBidders = false;
          print("🛑 CUBIT: No more pages my");
        } else {
          currentPageMyBidders++;
          print("➡️ CUBIT: Moving to next page: $currentPageMyBidders");
        }

        isAuctionMoreMyBidders = false;

        // Emit success state with the data
        print("✅ CUBIT: Emitting success state");
        emit(state.copyWith(
          status: StateStatus.success,
          myBiddersData: myBiddersData, // Use the full list, not just the new data
        ));
      },
    );
  }




}
