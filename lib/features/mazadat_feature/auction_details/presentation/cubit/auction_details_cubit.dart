import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/domain/entities/auction_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

import '../../domain/usecases/follow_users_auction_usecase.dart';
import '../../domain/usecases/get_auction_details_usecase.dart';
import '../../domain/usecases/send_bidding_usecase.dart';

part 'auction_details_state.dart';

class AuctionDetailsCubit extends Cubit<AuctionDetailsState> {
  final FollowUsersAuctionUseCase _followUsersAuctionUseCase;
  final GetAuctionDetailsUseCase _getAuctionDetailsUseCase;
  final SendBiddingUseCase _sendBiddingUseCase;
  AuctionDetailsCubit(
    this._followUsersAuctionUseCase,
    this._getAuctionDetailsUseCase,
    this._sendBiddingUseCase,
  ) : super(const AuctionDetailsState());

  void loadData() async {
    await getAuctionDetails();
  }

  Future<void> getAuctionDetails() async {
    final response = await _getAuctionDetailsUseCase.call(0);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: AuctionDetailsStates.error)),
        (data) => emit(state.copyWith(
            auction: data, status: AuctionDetailsStates.initState)));
  }

  Future<void> sendBidding({
    required num bidding
  }) async {
    final response = await _followUsersAuctionUseCase.call(0);
    response.fold(
        (failure) => emit(state.copyWith(
            status: AuctionDetailsStates.error,
            failure: failure)),
        (done) =>emit(state.copyWith(status:AuctionDetailsStates.success, successMessage: Labels.biddingPlacedSuccess )));
 
  }
  Future<void> followUser() async {
    final response = await _sendBiddingUseCase.call(0);
    response.fold(
        (failure) => emit(state.copyWith(
            status: AuctionDetailsStates.error,
            failure: failure)),
        (done) =>emit(state.copyWith(status:AuctionDetailsStates.success, successMessage: Labels.followedSuccess )));
  }
}
