import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/auction_participants_entity.dart';
import '../../domain/entities/get_all_auction_entity.dart';
import '../../domain/usecases/bid_auction_use_case.dart';
import '../../domain/usecases/fetch_available_auction_use_case.dart';
import '../../domain/usecases/fetch_participants_auction_use_case.dart';
import '../../domain/usecases/fetch_single_auction_use_case.dart';
import '../../domain/usecases/join_auction_use_case.dart';
import '../../domain/usecases/listen_to_new_auction_use_case.dart';
import '../../domain/usecases/listen_to_new_bid_auction_use_case.dart';


part 'auction_state.dart';

class AuctionCubit extends Cubit<AuctionState> {
  AuctionCubit(this.getAvailableAuctionUseCase, this.listenToNewAuctionUseCase, this.joinToAuctionUseCase, this.getSingleAuctionUseCase, this.getParticipantsAuctionUseCase, this.bidAuctionUseCase, this.listenToNewBidAuctionUseCase)  : super(AuctionState());

  final GetAvailableAuctionUseCase getAvailableAuctionUseCase;
  final ListenToNewAuctionUseCase listenToNewAuctionUseCase;
  final JoinToAuctionUseCase joinToAuctionUseCase;
  final GetSingleAuctionUseCase getSingleAuctionUseCase;
  final GetParticipantsAuctionUseCase getParticipantsAuctionUseCase;
  final BidAuctionUseCase bidAuctionUseCase;
  final ListenToNewBidAuctionUseCase listenToNewBidAuctionUseCase;

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

  // void listenToNewBids() {
  //   CliLogger.info('🎧 Listening to new bids...');
  //
  //   listenToNewBidAuctionUseCase((newParticipant) {
  //     CliLogger.info("📩 New bid participant: ${newParticipant.userId}");
  //
  //     // check if user already exists in participants
  //     final index = participants.indexWhere((p) => p.userId == newParticipant.userId);
  //
  //     if (index != -1) {
  //       // update existing participant bid
  //       participants[index] = newParticipant;
  //     } else {
  //       // add new participant
  //       participants.insert(0, newParticipant);
  //     }
  //
  //     emit(state.copyWith(
  //       auctionParticipants: List.from(participants),
  //       status: StateStatus.success,
  //     ));
  //   });
  // }

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
    if (!hasMoreAvailableNonSocketAuction || isAuctionMoreAvailableNonSocketAuction) {
      return;
    }
    isAuctionMoreAvailableNonSocketAuction = true;
    emit(state.copyWith(status: StateStatus.loading));
    final response = await getAvailableAuctionUseCase(
        GetAuctionParams(
            page: currentPageAvailableNonSocketAuction, limit: 5));
    response.fold(
          (failure) {
        isAuctionMoreAvailableNonSocketAuction = false;
        emit(state.copyWith(
            failure: failure,
            // isAuctionMoreLogs: false,
            status: StateStatus.error));
      },
          (data) {
        availableAuctionNonSocketData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreAvailableNonSocketAuction = false;
          // emit(state.copyWith(isAuctionMore: false));
          emit(state.copyWith(status: StateStatus.loading));
        } else {
          currentPageAvailableNonSocketAuction++;
        }

        isAuctionMoreAvailableNonSocketAuction = false;
        emit(state.copyWith(
          getAvailableAuction: data,
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

}
