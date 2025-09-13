import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/auction/auction_helper.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../common/functions/global/upload_image.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/add_favorite_auction_entity.dart';
import '../../domain/entities/auction_main_category_entity.dart';
import '../../domain/entities/auction_participants_entity.dart';
import '../../domain/entities/auction_sub_category_entity.dart';
import '../../domain/entities/get_all_auction_entity.dart';
import '../../domain/usecases/add_favorite_auction_use_case.dart';
import '../../domain/usecases/bid_auction_use_case.dart';
import '../../domain/usecases/fetch_available_auction_use_case.dart';
import '../../domain/usecases/fetch_expired_auction_use_case.dart';
import '../../domain/usecases/fetch_favorite_auction_use_case.dart';
import '../../domain/usecases/fetch_main_category_auction_use_case.dart';
import '../../domain/usecases/fetch_participants_auction_use_case.dart';
import '../../domain/usecases/fetch_single_auction_use_case.dart';
import '../../domain/usecases/fetch_sub_category_auction_use_case.dart';
import '../../domain/usecases/join_auction_use_case.dart';
import '../../domain/usecases/listen_to_new_auction_use_case.dart';
import '../../domain/usecases/listen_to_new_bid_auction_use_case.dart';


part 'auction_state.dart';

class AuctionCubit extends Cubit<AuctionState> {
  AuctionCubit(this.getAvailableAuctionUseCase, this.listenToNewAuctionUseCase, this.joinToAuctionUseCase, this.getSingleAuctionUseCase, this.getParticipantsAuctionUseCase, this.bidAuctionUseCase, this.listenToNewBidAuctionUseCase, this.getAuctionMainCategoryUseCase, this.getAuctionSubCategoryUseCase, this.getExpiredAuctionUseCase, this.getFavoriteAuctionUseCase, this.addFavoriteAuctionUseCase)  : super(AuctionState());

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



  /*
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
        // Find the auction in all lists and flip its isFavorite flag
        favoriteAuctionNonSocketData =
            favoriteAuctionNonSocketData.map((a) {
              if (a.id == auctionId) {
                return a.copyWith(isFavorite: !(a.isFavorite ?? false));
              }
              return a;
            }).toList();

        availableAuctionNonSocketData =
            availableAuctionNonSocketData.map((a) {
              if (a.id == auctionId) {
                return a.copyWith(isFavorite: !(a.isFavorite ?? false));
              }
              return a;
            }).toList();

        expiredAuctionNonSocketData =
            expiredAuctionNonSocketData.map((a) {
              if (a.id == auctionId) {
                return a.copyWith(isFavorite: !(a.isFavorite ?? false));
              }
              return a;
            }).toList();

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
*/
/*
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
        // Entity comes from AddFavoriteAuctionEntity
        CliLogger.info("⭐ Favorite updated: ${entity.message}");

        emit(state.copyWith(
          status: StateStatus.success,
          addFavoriteAuctionEntity: entity,
        ));
      },
    );
  }
*/
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
  void loadInitialParticipants(String auctionId) async {
    emit(state.copyWith(status: StateStatus.loading)); // show loader
    isInitialLoadingParticipants = true;
    participants.clear();
    currentPageParticipants = 1;
    hasMoreParticipants = true;
    await getParticipants(auctionId);
    isInitialLoadingParticipants = false;
    emit(state.copyWith(status: StateStatus.success));
  }
  void listenToNewBids() {
    CliLogger.info('🎧 Listening to new bids...');

    listenToNewBidAuctionUseCase((newParticipant) {
      CliLogger.info("📩 New bid participant: ${newParticipant.userId}");

      // remove if exists
      participants.removeWhere((p) => p.userId == newParticipant.userId);

      // always insert on top
      participants.insert(0, newParticipant);

      emit(state.copyWith(
        auctionParticipants: List.from(participants),
        status: StateStatus.success,
      ));
    });
  }


  /// Fetch paginated participants
  Future<void> getParticipants(String auctionId) async {
    if (!hasMoreParticipants || isLoadingMoreParticipants) return;

    isLoadingMoreParticipants = true;
    emit(state.copyWith(status: StateStatus.loading));

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
        emit(state.copyWith(failure: failure, status: StateStatus.error));
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
          status: StateStatus.success,
        ));
      },
    );
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

  List<GetAvailableAuctionEntity> availableAuctionNonSocketData = [];
  bool hasMoreAvailableNonSocketAuction = true;
  int currentPageAvailableNonSocketAuction = 1;
  bool isAuctionMoreAvailableNonSocketAuction = false;
  bool isAuctionAvailableNonSocketAuction = false;

  void loadInitialAvailableNonSocketAuction() async {
    print("🚀🚀🚀 CUBIT: loadInitialAvailableNonSocketAuction() called");
    emit(state.copyWith(status: StateStatus.loading)); // emit loading state
    isAuctionAvailableNonSocketAuction = true;
    availableAuctionNonSocketData.clear();
    currentPageAvailableNonSocketAuction = 1;
    hasMoreAvailableNonSocketAuction = true;
    await getAvailableNonSocketAuction();
    isAuctionAvailableNonSocketAuction = false;
    emit(state.copyWith(status: StateStatus.success));
  }

  Future<void> getAvailableNonSocketAuction() async {
    print("🚀🚀🚀 CUBIT: getAvailableNonSocketAuction() called");
    print("📊 Current state: hasMore=$hasMoreAvailableNonSocketAuction, isLoading=$isAuctionMoreAvailableNonSocketAuction");
    print("📊 Current data length: ${availableAuctionNonSocketData.length}");
    print("📊 Current page: $currentPageAvailableNonSocketAuction");

    if (!hasMoreAvailableNonSocketAuction || isAuctionMoreAvailableNonSocketAuction) {
      print("⚠️ CUBIT: Skipping call - no more data or already loading");
      return;
    }

    isAuctionMoreAvailableNonSocketAuction = true;

    // Only emit loading if it's the first page (initial load)
    if (currentPageAvailableNonSocketAuction == 1) {
      print("⏳ CUBIT: Emitting loading state for initial load");
      emit(state.copyWith(status: StateStatus.loading));
    }

    print("📡 CUBIT: Making API call for page $currentPageAvailableNonSocketAuction");
    final response = await getAvailableAuctionUseCase(
        GetAuctionParams(
            page: currentPageAvailableNonSocketAuction, limit: 5));

    response.fold(
          (failure) {
        print("❌ CUBIT: API call failed: $failure");
        isAuctionMoreAvailableNonSocketAuction = false;
        emit(state.copyWith(
            failure: failure,
            status: StateStatus.error));
      },
          (data) {
        print("✅ CUBIT: API call successful, received ${data.length} items");
        print("📦 CUBIT: Data received: $data");

        // If it's the first page, replace the data, otherwise add to it
        if (currentPageAvailableNonSocketAuction == 1) {
          availableAuctionNonSocketData = List.from(data);
          print("🔄 CUBIT: Replaced data for first page");
        } else {
          availableAuctionNonSocketData.addAll(data);
          print("➕ CUBIT: Added data to existing list");
        }

        print("📊 CUBIT: Total items now: ${availableAuctionNonSocketData.length}");

        if (data.isEmpty || data.length < 5) {
          hasMoreAvailableNonSocketAuction = false;
          print("🛑 CUBIT: No more pages available");
        } else {
          currentPageAvailableNonSocketAuction++;
          print("➡️ CUBIT: Moving to next page: $currentPageAvailableNonSocketAuction");
        }

        isAuctionMoreAvailableNonSocketAuction = false;

        // Emit success state with the data
        print("✅ CUBIT: Emitting success state");
        emit(state.copyWith(
          status: StateStatus.success,
          getAvailableAuction: availableAuctionNonSocketData, // Use the full list, not just the new data
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

/*
  List<AuctionMainCategoryEntity> mainCategories = [];
  bool hasMoreMainCategories = true;
  int currentPageMainCategories = 1;
  bool isLoadingMoreMainCategories = false;
*/

/*
  /// Load initial main categories
  Future<void> loadInitialMainCategories() async {
    emit(state.copyWith(status: StateStatus.loading));
    mainCategories.clear();
    currentPageMainCategories = 1;
    hasMoreMainCategories = true;
    await getMainCategories();
    emit(state.copyWith(status: StateStatus.success));
  }

  Future<void> getMainCategories() async {
    if (!hasMoreMainCategories || isLoadingMoreMainCategories) return;

    isLoadingMoreMainCategories = true;
    final response = await getAuctionMainCategoryUseCase(
      GetAuctionParams(page: currentPageMainCategories, limit: 10),
    );

    response.fold(
          (failure) {
        isLoadingMoreMainCategories = false;
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
          (data) {
        mainCategories.addAll(data);
        if (data.length < 10) {
          hasMoreMainCategories = false;
        } else {
          currentPageMainCategories++;
        }
        isLoadingMoreMainCategories = false;
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }
*/


}
